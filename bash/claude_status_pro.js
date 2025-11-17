#!/usr/bin/env node
'use strict';

// Simplified Claude status line for Pro plan
// Node.js port of claude_status_pro.rb
// Shows: session % (messages), reset time, context %

const fs = require('fs');
const path = require('path');

class ClaudeStatusPro {
  // Pro plan limits (2025)
  static PRO_MESSAGE_LIMIT = 250;
  static SESSION_DURATION_HOURS = 5;
  
  // Block boundary timing - set to 0 for top of hour (8:00am) or 59 for end of hour (7:59am)
  // Current value based on observation, but may need adjustment after testing
  static BLOCK_BOUNDARY_MINUTE = 0;

  // Context window limit (tokens)
  static CONTEXT_LIMIT = 200_000;

  constructor() {
    try {
      const input = fs.readFileSync(0, 'utf-8');
      this.input = JSON.parse(input);
    } catch (e) {
      if (e instanceof SyntaxError) {
        console.error(`Error: Invalid JSON input: ${e.message}`);
      } else {
        console.error(`Error: Failed to read input: ${e.message}`);
      }
      process.exit(1);
    }
    
    this.transcriptPath = this.input.transcript_path;
    this.sessionId = this.input.session_id;
    this.modelId = this.input.model?.id || '';
    this.contextLimit = ClaudeStatusPro.CONTEXT_LIMIT;
  }

  generate() {
    // Calculate session usage from transcript (5-hour blocks)
    const sessionData = this.calculateSessionUsage();

    // Calculate current conversation context usage
    const contextPct = this.calculateContextUsage();

    // Debug output (to stderr so it doesn't interfere with statusline)
    if (process.env.CLAUDE_STATUS_DEBUG === '1') {
      console.error('=== DEBUG ===');
      if (sessionData.transcript_count) {
        console.error(`Transcripts scanned: ${sessionData.transcript_count}`);
      }
      console.error(`Session messages: ${sessionData.message_count} / ${ClaudeStatusPro.PRO_MESSAGE_LIMIT} = ${sessionData.message_pct}%`);
      console.error(`Session tokens: ${sessionData.total_tokens}`);
      console.error(`Reset time: ${sessionData.reset_time}`);
      console.error(`Context tokens: ${contextPct ? Math.round(contextPct * this.contextLimit / 100) : 'N/A'} / ${this.contextLimit} = ${contextPct}%`);
      if (sessionData.block_end_time) {
        console.error(`Block end time: ${sessionData.block_end_time}`);
      }
      if (sessionData.block_start_time) {
        console.error(`Block start time: ${sessionData.block_start_time}`);
      }
      if (sessionData.total_blocks) {
        console.error(`Total blocks found: ${sessionData.total_blocks}`);
      }
      console.error('=============');
    }

    // Build output
    const parts = [];
    if (sessionData.message_pct != null) {
      parts.push(`✏️ ${sessionData.message_pct}%`);
    }
    if (sessionData.reset_time) {
      parts.push(`⏱️ ${sessionData.reset_time}`);
    }
    if (contextPct != null) {
      parts.push(`📓 ${contextPct}%`);
    }

    console.log(parts.join(' | '));
  }

  calculateSessionUsage() {
    if (!this.transcriptPath || !fs.existsSync(this.transcriptPath)) {
      return this.defaultSessionData();
    }

    try {
      // Find all transcript files in the same directory (all conversations)
      const transcriptDir = path.dirname(this.transcriptPath);
      const allTranscripts = fs.readdirSync(transcriptDir)
        .filter(f => f.endsWith('.jsonl'))
        .map(f => path.join(transcriptDir, f));

      // Parse all transcripts into 5-hour blocks
      // Pro plan limit applies across ALL conversations in the same 5-hour block
      const allBlocks = new Map();

      for (const transcriptFile of allTranscripts) {
        const blocks = this.parseTranscriptFile(transcriptFile);
        for (const block of blocks) {
          const key = block.start_time.getTime();
          if (allBlocks.has(key)) {
            // Merge blocks with same start time
            const existing = allBlocks.get(key);
            existing.total_tokens += block.total_tokens;
            existing.message_count += block.message_count;
            
            const existingTs = existing.last_timestamp;
            const newTs = block.last_timestamp;
            if (newTs && (!existingTs || newTs > existingTs)) {
              existing.last_timestamp = newTs;
            }
          } else {
            allBlocks.set(key, block);
          }
        }
      }

      const blocks = Array.from(allBlocks.values()).sort((a, b) => 
        a.start_time.getTime() - b.start_time.getTime()
      );
      const activeBlock = this.findActiveBlock(blocks);

      if (!activeBlock) {
        return { ...this.defaultSessionData(), total_blocks: blocks.length };
      }

      // Calculate MESSAGE percentage (Pro plan: 250 messages per 5 hours ACROSS ALL CONVERSATIONS)
      const messagePct = Math.round((activeBlock.message_count / ClaudeStatusPro.PRO_MESSAGE_LIMIT) * 1000) / 10;

      // Calculate reset time
      const currentTime = new Date();
      const secondsUntilReset = Math.max(Math.floor((activeBlock.end_time - currentTime) / 1000), 0);
      const hours = Math.floor(secondsUntilReset / 3600);
      const minutes = Math.floor((secondsUntilReset % 3600) / 60);
      const resetTime = `${hours}h${minutes}m`;

      return {
        message_pct: messagePct,
        reset_time: resetTime,
        total_tokens: activeBlock.total_tokens,
        block_end_time: activeBlock.end_time,
        block_start_time: activeBlock.start_time,
        total_blocks: blocks.length,
        message_count: activeBlock.message_count,
        transcript_count: allTranscripts.length
      };
    } catch (e) {
      if (process.env.CLAUDE_STATUS_DEBUG === '1') {
        console.error(`Error calculating session usage: ${e.message}`);
      }
      return this.defaultSessionData();
    }
  }

  readJsonLines(filePath) {
    const content = fs.readFileSync(filePath, 'utf-8');
    return content.split('\n').filter(line => line.trim());
  }

  calculateContextUsage() {
    if (!this.transcriptPath || !fs.existsSync(this.transcriptPath)) {
      return null;
    }

    try {
      // With prompt caching, we need to track the cumulative context
      // Each message's cache_read represents the entire cached context so far
      // Total context = max(cache_read + input + output) across all messages
      let maxContextTokens = 0;
      const processedHashes = new Set();
      let messageCount = 0;
      let skippedCount = 0;

      const lines = this.readJsonLines(this.transcriptPath);

      for (const line of lines) {
        try {
          const data = JSON.parse(line);
          if (typeof data !== 'object' || data === null) continue;

          const timestamp = this.parseTimestamp(data.timestamp);
          if (!timestamp) continue;

          // Process and get total context for this message
          const result = this.processTranscriptEntryWithCache(data, processedHashes);
          if (result != null) {
            maxContextTokens = Math.max(maxContextTokens, result);
            messageCount++;
          } else {
            skippedCount++;
          }
        } catch (e) {
          // Skip invalid JSON lines
          if (process.env.CLAUDE_STATUS_DEBUG === '1') {
            console.error(`  Skipped invalid JSON line: ${e.message}`);
          }
          continue;
        }
      }

      if (process.env.CLAUDE_STATUS_DEBUG === '1') {
        console.error(`Context debug: ${messageCount} messages counted, ${skippedCount} skipped`);
        console.error(`Max context: ${maxContextTokens} tokens`);
      }

      // Calculate percentage of context window used
      return Math.round((maxContextTokens / this.contextLimit) * 1000) / 10;
    } catch (e) {
      if (process.env.CLAUDE_STATUS_DEBUG === '1') {
        console.error(`Error calculating context usage: ${e.message}`);
      }
      return null;
    }
  }

  parseTranscriptFile(transcriptPath) {
    const blocks = [];
    let currentBlock = null;
    const processedHashes = new Set();

    try {
      const lines = this.readJsonLines(transcriptPath);

      for (const line of lines) {
        try {
          const data = JSON.parse(line);
          if (typeof data !== 'object' || data === null) continue;

          const timestamp = this.parseTimestamp(data.timestamp);
          if (!timestamp) continue;

          // Process entry for block counting
          const result = this.processBlockEntry(data, timestamp, processedHashes);
          if (!result) continue;

          const [ts, totalTokens] = result;
          const blockKey = this.roundToBlockStart(ts);

          // Create or update block
          if (!currentBlock || currentBlock.start_time.getTime() !== blockKey.getTime()) {
            currentBlock = this.createNewBlock(blockKey);
            blocks.push(currentBlock);
          }

          this.updateBlock(currentBlock, ts, totalTokens);
        } catch (e) {
          // Skip invalid JSON lines
          if (process.env.CLAUDE_STATUS_DEBUG === '1') {
            console.error(`  Skipped invalid JSON line: ${e.message}`);
          }
          continue;
        }
      }

      return blocks;
    } catch (e) {
      if (process.env.CLAUDE_STATUS_DEBUG === '1') {
        console.error(`Error parsing transcript ${transcriptPath}: ${e.message}`);
      }
      return [];
    }
  }

  validateAndExtractTokens(data, processedHashes, debug = false) {
    // Common validation logic for transcript entries
    // Returns tokens object if valid, null if should be skipped
    
    // Type checking
    const entryType = data.type || data.message?.type;
    if (!['user', 'assistant', 'message'].includes(entryType)) {
      if (debug) {
        console.error(`  Skipped: type=${JSON.stringify(entryType)} (not user/assistant)`);
      }
      return null;
    }

    // Deduplication
    const hash = this.uniqueHash(data);
    if (hash && processedHashes.has(hash)) {
      if (debug) {
        console.error(`  Skipped: duplicate hash=${hash}`);
      }
      return null;
    }

    // Extract tokens
    const tokens = this.extractTokens(data);
    
    const tokenSum = tokens.input_tokens + tokens.output_tokens + 
                     tokens.cache_creation_tokens + tokens.cache_read_tokens;
    if (tokenSum <= 0) {
      if (debug) {
        console.error(`  Skipped: no tokens (${JSON.stringify(tokens)})`);
      }
      return null;
    }

    // Mark as processed
    if (hash) processedHashes.add(hash);
    
    return tokens;
  }

  processBlockEntry(data, timestamp, processedHashes) {
    // For 5-hour block tracking
    const tokens = this.validateAndExtractTokens(data, processedHashes);
    if (!tokens) return null;
    
    return [timestamp, tokens.total_tokens];
  }

  processTranscriptEntryWithCache(data, processedHashes) {
    // For context calculation (includes cache_read for total context size)
    const debug = process.env.CLAUDE_STATUS_DEBUG === '1';
    const tokens = this.validateAndExtractTokens(data, processedHashes, debug);
    if (!tokens) return null;

    // Total context = cache_read (all previous context) + input (new) + output (new)
    const totalContext = tokens.cache_read_tokens + tokens.input_tokens + tokens.output_tokens;

    if (debug) {
      console.error(`  Counted: ${totalContext} context tokens (cache=${tokens.cache_read_tokens} in=${tokens.input_tokens} out=${tokens.output_tokens})`);
    }

    return totalContext;
  }

  createNewBlock(startTime) {
    return {
      start_time: startTime,
      end_time: new Date(startTime.getTime() + (ClaudeStatusPro.SESSION_DURATION_HOURS * 3600 * 1000)),
      first_timestamp: null,
      last_timestamp: null,
      total_tokens: 0,
      message_count: 0,
      is_active: false
    };
  }

  updateBlock(block, timestamp, tokens) {
    if (!block.first_timestamp) block.first_timestamp = timestamp;
    block.total_tokens += tokens;
    block.message_count += 1;
    block.last_timestamp = timestamp;
  }

  roundToBlockStart(timestamp) {
    // Claude's 5-hour blocks start at specific times
    // Standard blocks: 8am, 1pm, 6pm, 11pm, 4am (or offset by BLOCK_BOUNDARY_MINUTE)

    const hour = timestamp.getHours();

    // Determine which 5-hour block this falls into
    // Returns the starting hour for each block period
    let blockStartHour;
    if (hour >= 0 && hour <= 3) {
      blockStartHour = 23; // 11pm-4am block (previous day)
    } else if (hour >= 4 && hour <= 7) {
      blockStartHour = 4; // 4am-9am block
    } else if (hour >= 8 && hour <= 12) {
      blockStartHour = 8; // 8am-1pm block
    } else if (hour >= 13 && hour <= 17) {
      blockStartHour = 13; // 1pm-6pm block
    } else if (hour >= 18 && hour <= 22) {
      blockStartHour = 18; // 6pm-11pm block
    } else {
      blockStartHour = 23; // 11pm-4am block
    }

    // Create block start time using configured boundary minute
    if (blockStartHour === 23 && hour < 4) {
      // Previous day's 11pm block
      return new Date(
        timestamp.getFullYear(),
        timestamp.getMonth(),
        timestamp.getDate() - 1,
        blockStartHour,
        ClaudeStatusPro.BLOCK_BOUNDARY_MINUTE,
        0,
        0
      );
    } else {
      return new Date(
        timestamp.getFullYear(),
        timestamp.getMonth(),
        timestamp.getDate(),
        blockStartHour,
        ClaudeStatusPro.BLOCK_BOUNDARY_MINUTE,
        0,
        0
      );
    }
  }

  findActiveBlock(blocks) {
    if (blocks.length === 0) return null;
    
    const currentTime = new Date();

    // Mark active blocks
    blocks.forEach(block => {
      block.is_active = block.end_time > currentTime;
    });

    // Return first active block or most recent
    const activeBlock = blocks.find(block => block.is_active);
    if (activeBlock) return activeBlock;

    // Find most recent block by timestamp
    return blocks.reduce((best, block) => {
      const bestTime = best.last_timestamp || best.first_timestamp || best.start_time;
      const blockTime = block.last_timestamp || block.first_timestamp || block.start_time;
      return blockTime > bestTime ? block : best;
    }, blocks[0]);
  }

  parseTimestamp(timestampStr) {
    if (!timestampStr) return null;
    try {
      const date = new Date(timestampStr);
      return isNaN(date.getTime()) ? null : date;
    } catch (e) {
      return null;
    }
  }

  uniqueHash(data) {
    const messageId = data.message_id || data.message?.id;
    const requestId = data.requestId || data.request_id;
    return (messageId && requestId) ? `${messageId}:${requestId}` : null;
  }

  extractTokens(data) {
    const tokens = {
      input_tokens: 0,
      output_tokens: 0,
      cache_creation_tokens: 0,
      cache_read_tokens: 0,
      total_tokens: 0
    };

    // Token sources (from claude_monitor_statusline.rb)
    const sources = [
      data.usage,
      data.message?.usage,
      data.response?.usage
    ].filter(s => s != null);

    for (const source of sources) {
      if (typeof source !== 'object' || source === null) continue;

      const input = this.extractTokenField(source, ['input_tokens', 'inputTokens', 'prompt_tokens']);
      const output = this.extractTokenField(source, ['output_tokens', 'outputTokens', 'completion_tokens']);
      const cacheCreation = this.extractTokenField(source, ['cache_creation_tokens', 'cache_creation_input_tokens', 'cacheCreationInputTokens']);
      const cacheRead = this.extractTokenField(source, ['cache_read_input_tokens', 'cache_read_tokens', 'cacheReadInputTokens']);

      if (input > 0 || output > 0) {
        tokens.input_tokens = input;
        tokens.output_tokens = output;
        tokens.cache_creation_tokens = cacheCreation;
        tokens.cache_read_tokens = cacheRead;
        // Total for usage limits: input + output only
        // (cache_read tokens are reused, not counted toward limits)
        tokens.total_tokens = input + output;
        break;
      }
    }

    return tokens;
  }

  extractTokenField(source, fieldNames) {
    for (const field of fieldNames) {
      const value = source[field];
      if (value != null) {
        const num = Number(value);
        if (num > 0) return num;
      }
    }
    return 0;
  }

  defaultSessionData() {
    return {
      message_pct: 0.0,
      reset_time: '5h0m'
    };
  }
}

// Execute
new ClaudeStatusPro().generate();
