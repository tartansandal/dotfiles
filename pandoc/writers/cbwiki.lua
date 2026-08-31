--- cbwiki.lua — pandoc custom writer for Codebeamer (cbX) wiki markup.
---
--- cbX uses a JSPWiki dialect, not Markdown. See the vault card "cbX Wiki
--- Markup" for the syntax reference this writer targets.
---
---   pandoc -f gfm -t cbwiki.lua notes.md
---
--- Anything with no cbX equivalent falls back to an [{Html ...}] plugin block,
--- which renders correctly but is not editable as markup afterwards.

local layout = pandoc.layout
local concat, cr, blankline, literal = layout.concat, layout.cr, layout.blankline, layout.literal

-- pandoc looks up the global `Writer`; scaffolding supplies the traversal
-- and Doc-building, leaving one handler per AST element type.
Writer = pandoc.scaffolding.Writer

--- Marker stack for nested lists: cbX nests by repeating the marker
--- ("**" is a second-level bullet), where Markdown nests by indentation.
local list_stack = {}

local function list_prefix()
  return table.concat(list_stack)
end

--- Set while rendering a table cell, where a bare | would start a column.
--- Escaping at this level leaves the | that Link emits as a separator alone.
local escape_pipe = false

--- `~` escapes the following character. Escape only what would otherwise
--- start markup mid-line; over-escaping makes the output unreadable.
local function escape(text)
  local out = text:gsub('[~%[%]]', '~%0')
  out = out:gsub('{{', '~{{')
  out = out:gsub('%%%%', '~%%%%')
  if escape_pipe then
    out = out:gsub('|', '~|')
  end
  return out
end

--- Render inlines onto one source line. cbX's line-oriented constructs -- a
--- table row, a definition, a list item -- end at a real newline, so forced
--- breaks keep their \\ marker and every other newline folds into one.
local function one_line(inlines)
  local s = layout.render(Writer.Inlines(inlines))
  return (s:gsub('\\\\\n', '\\\\'):gsub('\n', '\\\\'))
end

local function html_fallback(el)
  local doc
  if pandoc.utils.type(el) == 'Block' then
    doc = pandoc.Pandoc({ el })
  else
    doc = pandoc.Pandoc({ pandoc.Plain({ el }) })
  end
  local html = pandoc.write(doc, 'html'):gsub('%s+$', '')
  return concat { literal('[{Html'), blankline, literal(html), cr, literal('}]') }
end

--- The block fallback carries a blankline and would split a paragraph, so
--- inline constructs get a single-line form instead.
local function html_inline_fallback(el)
  local html = pandoc.write(pandoc.Pandoc({ pandoc.Plain({ el }) }), 'html')
  return literal('[{Html ' .. (html:gsub('%s+$', ''):gsub('\n', ' ')) .. '}]')
end

-- Inlines ------------------------------------------------------------------

Writer.Inline.Str = function(el) return escape(el.text) end
Writer.Inline.Space = function() return ' ' end
Writer.Inline.SoftBreak = function() return ' ' end
Writer.Inline.LineBreak = function() return concat { literal('\\\\'), cr } end

Writer.Inline.Emph = function(el)
  return concat { literal("''"), Writer.Inlines(el.content), literal("''") }
end

Writer.Inline.Strong = function(el)
  return concat { literal('__'), Writer.Inlines(el.content), literal('__') }
end

Writer.Inline.Code = function(el)
  -- A }} inside the span would close it early; HTML is the only safe form.
  if el.text:find('}}', 1, true) then
    return html_inline_fallback(el)
  end
  return concat { literal('{{'), literal(el.text), literal('}}') }
end

Writer.Inline.Link = function(el)
  local label = pandoc.utils.stringify(el.content)
  -- A | in the target would read as a second separator.
  local target = el.target:gsub('|', '~|')
  -- [Target] alone is the idiomatic form when the label adds nothing.
  if label == target or label == '' then
    return concat { literal('['), literal(target), literal(']') }
  end
  return concat { literal('['), Writer.Inlines(el.content), literal('|'), literal(target), literal(']') }
end

--- Alt text is dropped: the Image plugin's parameter name for it is not
--- documented, and inventing one would render worse than omitting it. A
--- Figure keeps its caption (see Writer.Block.Figure).
Writer.Inline.Image = function(el)
  return literal("[{Image src='" .. el.src:gsub("'", '%%27') .. "'}]")
end

Writer.Inline.Quoted = function(el)
  local open = el.quotetype == 'SingleQuote' and "'" or '"'
  return concat { literal(open), Writer.Inlines(el.content), literal(open) }
end

Writer.Inline.Span = function(el) return Writer.Inlines(el.content) end
Writer.Inline.SmallCaps = function(el) return Writer.Inlines(el.content) end
Writer.Inline.RawInline = function(el)
  if el.format == 'html' then return literal(el.text) end
  return ''
end

--- Terminator for %%style spans. The published JSPWiki and PTC docs give
--- "%%", but cbX's own editor emits "%!" when you apply a style by hand, so
--- that is what we match. Change this one constant if an instance differs.
local STYLE_CLOSE = '%!'

--- %%style ... spans, inherited from JSPWiki. A named style needs a space to
--- delimit the name; the %%(css) form attaches directly to its content.
--- Neither pads the closer, or the space lands inside the span.
local function style_span(opener, el)
  return concat { literal(opener), Writer.Inlines(el.content), literal(STYLE_CLOSE) }
end

Writer.Inline.Strikeout = function(el)
  return style_span('%%(text-decoration:line-through;)', el)
end

Writer.Inline.Subscript = function(el) return style_span('%%sub ', el) end
Writer.Inline.Superscript = function(el) return style_span('%%sup ', el) end

Writer.Inline.Underline = function(el)
  return style_span('%%(text-decoration:underline;)', el)
end

Writer.Inline.Cite = function(el) return Writer.Inlines(el.content) end

-- No cbX equivalent; HTML at least preserves the notation.
Writer.Inline.Math = html_inline_fallback

--- cbX has no footnote concept, and routing one through HTML drags pandoc's
--- entire footnotes section inline. Inline the note text parenthetically.
Writer.Inline.Note = function(el)
  local inlines = pandoc.utils.blocks_to_inlines(el.content, { pandoc.Space() })
  return concat { literal(' ('), Writer.Inlines(inlines), literal(')') }
end

-- Blocks -------------------------------------------------------------------

--- A paragraph opening with a block marker -- one Markdown escaped, so it
--- reaches us as a bare Str -- would otherwise start a list, heading or quote.
local function para(el)
  local doc = Writer.Inlines(el.content)
  local first = el.content[1]
  if first and first.t == 'Str' and first.text:match('^[%*#;!>]') then
    return concat { literal('~'), doc }
  end
  return doc
end

Writer.Block.Plain = para
Writer.Block.Para = para

Writer.Block.Header = function(el)
  -- cbX has !1 (largest) through !5.
  local level = math.min(el.level, 5)
  return concat { literal('!' .. level .. ' '), Writer.Inlines(el.content) }
end

Writer.Block.CodeBlock = function(el)
  -- {{{ }}} is verbatim; cbX has no language tag on it, so any info string
  -- from the fence is dropped.
  return concat { literal('{{{'), cr, literal(el.text:gsub('%s+$', '')), cr, literal('}}}') }
end

Writer.Block.HorizontalRule = function() return literal('----') end

--- cbX quotes with a leading '>' per line, and a bare '>' is itself a quoted
--- blank line, so that is what separates paragraphs inside a quote.
--- Nesting composes: an inner quote prefixes its own lines, and the outer
--- pass prefixes those again to give '>>'.
Writer.Block.BlockQuote = function(el)
  local parts = {}
  for _, b in ipairs(el.content) do
    parts[#parts + 1] = Writer.Block[b.t](b)
  end
  -- blankline, not cr..cr: the layout engine collapses consecutive breaks.
  local body = layout.render(concat(parts, blankline))
  -- cbX's own editor emits '>text' with no separating space, and a bare '>'
  -- for a quoted blank line; both fall out of prefixing every line.
  local lines = {}
  for line in (body .. '\n'):gmatch('([^\n]*)\n') do
    lines[#lines + 1] = literal('>' .. line)
  end
  return concat(lines, cr)
end

Writer.Block.LineBlock = function(el)
  local lines = {}
  for _, line in ipairs(el.content) do
    lines[#lines + 1] = concat { Writer.Inlines(line), literal('\\\\') }
  end
  return concat(lines, cr)
end

Writer.Block.Div = function(el) return Writer.Blocks(el.content) end
--- cbX has no figure construct; emit the image with its caption beneath,
--- italicised, rather than dropping the caption on the floor.
Writer.Block.Figure = function(el)
  local body = Writer.Blocks(el.content)
  local caption = pandoc.utils.stringify(el.caption)
  if caption == '' then
    return body
  end
  return concat { body, cr, literal("''" .. caption .. "''") }
end

Writer.Block.RawBlock = function(el)
  if el.format == 'html' then
    return concat { literal('[{Html'), blankline, literal(el.text), cr, literal('}]') }
  end
  -- Any other raw format is meaningless to cbX, but dropping it silently
  -- loses content; verbatim at least keeps it visible.
  return concat { literal('{{{'), cr, literal(el.text), cr, literal('}}}') }
end

--- Render one list item. Leading Plain/Para content shares the marker line
--- and nested lists emit their own prefixed lines, but any other continuation
--- block has to fold into the item: an unprefixed line at column 0 ends the
--- list, and cbX then restarts the numbering of whatever follows.
local function render_item(prefix, blocks)
  local lead, folded, sublists = nil, {}, {}
  for _, b in ipairs(blocks) do
    if lead == nil and (b.t == 'Plain' or b.t == 'Para') then
      lead = one_line(b.content)
    elseif b.t == 'BulletList' or b.t == 'OrderedList' then
      sublists[#sublists + 1] = Writer.Block[b.t](b)
    else
      folded[#folded + 1] =
        one_line(pandoc.utils.blocks_to_inlines({ b }, { pandoc.LineBreak() }))
    end
  end
  local text = lead or ''
  for _, extra in ipairs(folded) do
    text = text .. '\\\\' .. extra
  end
  local lines = { literal(prefix .. ' ' .. text) }
  for _, sub_list in ipairs(sublists) do
    lines[#lines + 1] = sub_list
  end
  return concat(lines, cr)
end

local function render_list(el, marker)
  table.insert(list_stack, marker)
  local prefix = list_prefix()
  local items = {}
  for _, item in ipairs(el.content) do
    items[#items + 1] = render_item(prefix, item)
  end
  table.remove(list_stack)
  return concat(items, cr)
end

Writer.Block.BulletList = function(el) return render_list(el, '*') end

Writer.Block.OrderedList = function(el)
  -- cbX numbers automatically; start/style/delimiter from Markdown are lost.
  return render_list(el, '#')
end

Writer.Block.DefinitionList = function(el)
  local lines = {}
  for _, entry in ipairs(el.content) do
    local term, defs = entry[1], entry[2]
    local rendered = {}
    for _, blocks in ipairs(defs) do
      rendered[#rendered + 1] =
        one_line(pandoc.utils.blocks_to_inlines(blocks, { pandoc.LineBreak() }))
    end
    lines[#lines + 1] = concat {
      literal(';'),
      Writer.Inlines(term),
      literal(':' .. table.concat(rendered, ' ')),
    }
  end
  return concat(lines, cr)
end

-- Tables -------------------------------------------------------------------

--- cbX cells are single-line: || starts a header row, | a body row. Block
--- structure inside a cell is flattened, with \\ standing in for breaks.
local function render_cell(cell)
  local inlines = pandoc.utils.blocks_to_inlines(cell.contents, { pandoc.LineBreak() })
  -- Escape | while rendering, not after: a post-hoc gsub would also hit the
  -- separator inside [label|target] and break the link.
  escape_pipe = true
  local ok, rendered = pcall(one_line, inlines)
  escape_pipe = false
  if not ok then
    error(rendered)
  end
  return literal(rendered)
end

local function render_row(row, sep)
  local cells = {}
  for _, cell in ipairs(row.cells) do
    cells[#cells + 1] = render_cell(cell)
  end
  return concat { literal(sep), concat(cells, literal(sep)) }
end

Writer.Block.Table = function(el)
  local lines = {}
  local caption = pandoc.utils.stringify(el.caption)
  if caption ~= '' then
    lines[#lines + 1] = literal("''" .. caption .. "''")
  end
  for _, row in ipairs(el.head.rows) do
    lines[#lines + 1] = render_row(row, '||')
  end
  for _, body in ipairs(el.bodies) do
    for _, row in ipairs(body.head) do
      lines[#lines + 1] = render_row(row, '||')
    end
    for _, row in ipairs(body.body) do
      lines[#lines + 1] = render_row(row, '|')
    end
  end
  for _, row in ipairs(el.foot.rows) do
    lines[#lines + 1] = render_row(row, '|')
  end
  return concat(lines, cr)
end
