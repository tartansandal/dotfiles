#!/usr/bin/env ruby
# frozen_string_literal: true

# Simplified Claude status line for Pro plan
# Based entirely on claude_monitor_statusline.rb logic
# Shows: session % (messages), reset time, context %

require 'json'
require 'date'
require 'time'
require 'set'

class ClaudeStatusPro
  # Pro plan limits (2025)
  PRO_MESSAGE_LIMIT = 250
  SESSION_DURATION_HOURS = 5
  SECONDS_PER_DAY = 86_400
  
  # Block boundary timing - set to 0 for top of hour (8:00am) or 59 for end of hour (7:59am)
  # Current value based on observation, but may need adjustment after testing
  BLOCK_BOUNDARY_MINUTE = 0

  # Context window limit (tokens)
  CONTEXT_LIMIT = 200_000

  def initialize
    begin
      @input = JSON.parse($stdin.read)
    rescue JSON::ParserError => e
      $stderr.puts "Error: Invalid JSON input: #{e.message}"
      exit 1
    end
    
    @transcript_path = @input['transcript_path']
    @session_id = @input['session_id']
    @model_id = @input.dig('model', 'id') || ''
    @context_limit = CONTEXT_LIMIT
  end

  def generate
    # Calculate session usage from transcript (5-hour blocks)
    session_data = calculate_session_usage

    # Calculate current conversation context usage
    context_pct = calculate_context_usage

    # Debug output (to stderr so it doesn't interfere with statusline)
    if ENV['CLAUDE_STATUS_DEBUG'] == '1'
      $stderr.puts "=== DEBUG ==="
      $stderr.puts "Transcripts scanned: #{session_data[:transcript_count]}" if session_data[:transcript_count]
      $stderr.puts "Session messages: #{session_data[:message_count]} / #{PRO_MESSAGE_LIMIT} = #{session_data[:message_pct]}%"
      $stderr.puts "Session tokens: #{session_data[:total_tokens]}"
      $stderr.puts "Reset time: #{session_data[:reset_time]}"
      $stderr.puts "Context tokens: #{context_pct ? (context_pct * @context_limit / 100).to_i : 'N/A'} / #{@context_limit} = #{context_pct}%"
      $stderr.puts "Block end time: #{session_data[:block_end_time]}" if session_data[:block_end_time]
      $stderr.puts "Block start time: #{session_data[:block_start_time]}" if session_data[:block_start_time]
      $stderr.puts "Total blocks found: #{session_data[:total_blocks]}" if session_data[:total_blocks]
      $stderr.puts "============="
    end

    # Build output
    parts = []
    parts << "✏️ #{session_data[:message_pct]}%" if session_data[:message_pct]
    parts << "⏱️ #{session_data[:reset_time]}" if session_data[:reset_time]
    parts << "📓 #{context_pct}%" if context_pct

    puts parts.join(" | ")
  end

  private



  def calculate_session_usage
    return default_session_data unless @transcript_path && File.exist?(@transcript_path)

    # Find all transcript files in the same directory (all conversations)
    transcript_dir = File.dirname(@transcript_path)
    all_transcripts = Dir.glob(File.join(transcript_dir, '*.jsonl'))

    # Parse all transcripts into 5-hour blocks
    # Pro plan limit applies across ALL conversations in the same 5-hour block
    all_blocks = {}

    all_transcripts.each do |transcript_file|
      blocks = parse_transcript_file(transcript_file)
      blocks.each do |block|
        key = block[:start_time]
        if all_blocks[key]
          # Merge blocks with same start time
          all_blocks[key][:total_tokens] += block[:total_tokens]
          all_blocks[key][:message_count] += block[:message_count]
          existing_ts = all_blocks[key][:last_timestamp]
          new_ts = block[:last_timestamp]
          all_blocks[key][:last_timestamp] = [existing_ts, new_ts].compact.max if existing_ts || new_ts
        else
          all_blocks[key] = block
        end
      end
    end

    blocks = all_blocks.values.sort_by { |b| b[:start_time] }
    active_block = find_active_block(blocks)

    return default_session_data.merge(total_blocks: blocks.length) unless active_block

    # Calculate MESSAGE percentage (Pro plan: 250 messages per 5 hours ACROSS ALL CONVERSATIONS)
    message_pct = ((active_block[:message_count] / PRO_MESSAGE_LIMIT.to_f) * 100).round(1)

    # Calculate reset time
    current_time = Time.now
    seconds_until_reset = [(active_block[:end_time] - current_time).to_i, 0].max
    hours = seconds_until_reset / 3600
    minutes = (seconds_until_reset % 3600) / 60
    reset_time = "#{hours}h#{minutes}m"

    {
      message_pct: message_pct,
      reset_time: reset_time,
      total_tokens: active_block[:total_tokens],
      block_end_time: active_block[:end_time],
      block_start_time: active_block[:start_time],
      total_blocks: blocks.length,
      message_count: active_block[:message_count],
      transcript_count: all_transcripts.length
    }
  rescue => e
    $stderr.puts "Error calculating session usage: #{e.message}" if ENV['CLAUDE_STATUS_DEBUG'] == '1'
    default_session_data
  end

  def calculate_context_usage
    return nil unless @transcript_path && File.exist?(@transcript_path)

    # With prompt caching, we need to track the cumulative context
    # Each message's cache_read represents the entire cached context so far
    # Total context = max(cache_read + input + output) across all messages
    max_context_tokens = 0
    processed_hashes = Set.new
    message_count = 0
    skipped_count = 0

    File.foreach(@transcript_path) do |line|
      data = JSON.parse(line.strip)
      next unless data.is_a?(Hash)

      timestamp = parse_timestamp(data['timestamp'])
      next unless timestamp

      # Process and get total context for this message
      result = process_transcript_entry_with_cache(data, processed_hashes)
      if result
        max_context_tokens = [max_context_tokens, result].max
        message_count += 1
      else
        skipped_count += 1
      end
    end

    if ENV['CLAUDE_STATUS_DEBUG'] == '1'
      $stderr.puts "Context debug: #{message_count} messages counted, #{skipped_count} skipped"
      $stderr.puts "Max context: #{max_context_tokens} tokens"
    end

    # Calculate percentage of context window used
    ((max_context_tokens / @context_limit.to_f) * 100).round(1)
  rescue => e
    $stderr.puts "Error calculating context usage: #{e.message}" if ENV['CLAUDE_STATUS_DEBUG'] == '1'
    nil
  end

  def parse_transcript_file(transcript_path)
    blocks = []
    current_block = nil
    processed_hashes = Set.new

    File.foreach(transcript_path) do |line|
      data = JSON.parse(line.strip)
      next unless data.is_a?(Hash)

      timestamp = parse_timestamp(data['timestamp'])
      next unless timestamp

      # Process entry for block counting
      result = process_block_entry(data, timestamp, processed_hashes)
      next unless result

      timestamp, total_tokens = result
      block_key = round_to_block_start(timestamp)

      # Create or update block
      if current_block.nil? || current_block[:start_time] != block_key
        current_block = create_new_block(block_key)
        blocks << current_block
      end

      update_block(current_block, timestamp, total_tokens)
    end

    blocks
  rescue => e
    $stderr.puts "Error parsing transcript #{transcript_path}: #{e.message}" if ENV['CLAUDE_STATUS_DEBUG'] == '1'
    []
  end

  def validate_and_extract_tokens(data, processed_hashes, debug: false)
    # Common validation logic for transcript entries
    # Returns tokens hash if valid, nil if should be skipped
    
    # Type checking
    entry_type = data['type'] || data.dig('message', 'type')
    unless ['user', 'assistant', 'message'].include?(entry_type)
      $stderr.puts "  Skipped: type=#{entry_type.inspect} (not user/assistant)" if debug
      return nil
    end

    # Deduplication
    hash = unique_hash(data)
    if hash && processed_hashes.include?(hash)
      $stderr.puts "  Skipped: duplicate hash=#{hash}" if debug
      return nil
    end

    # Extract tokens
    tokens = extract_tokens(data)
    
    if tokens.values_at(:input_tokens, :output_tokens, :cache_creation_tokens, :cache_read_tokens).sum <= 0
      $stderr.puts "  Skipped: no tokens (#{tokens.inspect})" if debug
      return nil
    end

    # Mark as processed
    processed_hashes.add(hash) if hash
    
    tokens
  end

  def process_block_entry(data, timestamp, processed_hashes)
    # For 5-hour block tracking
    tokens = validate_and_extract_tokens(data, processed_hashes)
    return nil unless tokens
    
    [timestamp, tokens[:total_tokens]]
  end

  def process_transcript_entry_with_cache(data, processed_hashes)
    # For context calculation (includes cache_read for total context size)
    debug = ENV['CLAUDE_STATUS_DEBUG'] == '1'
    tokens = validate_and_extract_tokens(data, processed_hashes, debug: debug)
    return nil unless tokens

    # Total context = cache_read (all previous context) + input (new) + output (new)
    total_context = tokens[:cache_read_tokens] + tokens[:input_tokens] + tokens[:output_tokens]

    if debug
      $stderr.puts "  Counted: #{total_context} context tokens (cache=#{tokens[:cache_read_tokens]} in=#{tokens[:input_tokens]} out=#{tokens[:output_tokens]})"
    end

    total_context
  end

  def create_new_block(start_time)
    {
      start_time: start_time,
      end_time: start_time + (SESSION_DURATION_HOURS * 3600),
      first_timestamp: nil,
      last_timestamp: nil,
      total_tokens: 0,
      message_count: 0,
      is_active: false
    }
  end

  def update_block(block, timestamp, tokens)
    block[:first_timestamp] ||= timestamp
    block[:total_tokens] += tokens
    block[:message_count] += 1
    block[:last_timestamp] = timestamp
  end

  def round_to_block_start(timestamp)
    # Claude's 5-hour blocks start at specific times
    # Standard blocks: 8am, 1pm, 6pm, 11pm, 4am (or offset by BLOCK_BOUNDARY_MINUTE)

    local_time = timestamp.getlocal
    hour = local_time.hour

    # Determine which 5-hour block this falls into
    # Returns the starting hour for each block period
    block_start_hour = case hour
    when 0..3   then 23  # 11pm-4am block (previous day)
    when 4..7   then 4   # 4am-9am block
    when 8..12  then 8   # 8am-1pm block
    when 13..17 then 13  # 1pm-6pm block
    when 18..22 then 18  # 6pm-11pm block
    else 23              # 11pm-4am block
    end

    # Create block start time using configured boundary minute
    if block_start_hour == 23 && hour < 4
      # Previous day's 11pm block
      prev_day = local_time - SECONDS_PER_DAY
      Time.new(prev_day.year, prev_day.month, prev_day.day, block_start_hour, BLOCK_BOUNDARY_MINUTE, 0, local_time.utc_offset)
    else
      Time.new(local_time.year, local_time.month, local_time.day, block_start_hour, BLOCK_BOUNDARY_MINUTE, 0, local_time.utc_offset)
    end
  end

  def find_active_block(blocks)
    current_time = Time.now

    # Mark active blocks
    blocks.each { |block| block[:is_active] = block[:end_time] > current_time }

    # Return first active block or most recent
    blocks.find { |block| block[:is_active] } ||
      blocks.max_by { |block| block[:last_timestamp] || block[:first_timestamp] || block[:start_time] }
  end

  def parse_timestamp(timestamp_str)
    return nil unless timestamp_str
    DateTime.parse(timestamp_str).to_time
  rescue ArgumentError
    nil
  end

  def unique_hash(data)
    message_id = data['message_id'] || data.dig('message', 'id')
    request_id = data['requestId'] || data['request_id']
    "#{message_id}:#{request_id}" if message_id && request_id
  end

  def extract_tokens(data)
    tokens = { input_tokens: 0, output_tokens: 0, cache_creation_tokens: 0, cache_read_tokens: 0, total_tokens: 0 }

    # Token sources (from claude_monitor_statusline.rb)
    sources = [
      data['usage'],
      data.dig('message', 'usage'),
      data.dig('response', 'usage')
    ].compact

    sources.each do |source|
      next unless source.is_a?(Hash)

      input = extract_token_field(source, %w[input_tokens inputTokens prompt_tokens])
      output = extract_token_field(source, %w[output_tokens outputTokens completion_tokens])
      cache_creation = extract_token_field(source, %w[cache_creation_tokens cache_creation_input_tokens cacheCreationInputTokens])
      cache_read = extract_token_field(source, %w[cache_read_input_tokens cache_read_tokens cacheReadInputTokens])

      if input > 0 || output > 0
        tokens[:input_tokens] = input
        tokens[:output_tokens] = output
        tokens[:cache_creation_tokens] = cache_creation
        tokens[:cache_read_tokens] = cache_read
        # Total for usage limits: input + output only
        # (cache_read tokens are reused, not counted toward limits)
        tokens[:total_tokens] = input + output
        break
      end
    end

    tokens
  end

  def extract_token_field(source, field_names)
    field_names.each do |field|
      value = source[field]
      return value.to_i if value && value.to_i > 0
    end
    0
  end

  def default_session_data
    {
      message_pct: 0.0,
      reset_time: "5h0m"
    }
  end
end

# Execute
ClaudeStatusPro.new.generate
