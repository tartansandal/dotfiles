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

--- `~` escapes the following character. Escape only what would otherwise
--- start markup mid-line; over-escaping makes the output unreadable.
local function escape(text)
  return (text:gsub('[~%[%]]', '~%0'))
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
  return concat { literal('{{'), literal(el.text), literal('}}') }
end

Writer.Inline.Link = function(el)
  local label = pandoc.utils.stringify(el.content)
  local target = el.target
  -- [Target] alone is the idiomatic form when the label adds nothing.
  if label == target or label == '' then
    return concat { literal('['), literal(target), literal(']') }
  end
  return concat { literal('['), Writer.Inlines(el.content), literal('|'), literal(target), literal(']') }
end

Writer.Inline.Image = function(el)
  return literal("[{Image src='" .. el.src .. "'}]")
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
Writer.Inline.Math = html_fallback

--- cbX has no footnote concept, and routing one through HTML drags pandoc's
--- entire footnotes section inline. Inline the note text parenthetically.
Writer.Inline.Note = function(el)
  local inlines = pandoc.utils.blocks_to_inlines(el.content, { pandoc.Space() })
  return concat { literal(' ('), Writer.Inlines(inlines), literal(')') }
end

-- Blocks -------------------------------------------------------------------

Writer.Block.Plain = function(el) return Writer.Inlines(el.content) end
Writer.Block.Para = function(el) return Writer.Inlines(el.content) end

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

--- cbX quotes with a leading '>' per line. A blank line would close the
--- quote, so paragraphs inside one are separated by a forced break instead.
--- Nesting composes: an inner quote prefixes its own lines, and the outer
--- pass prefixes those again to give '>>'.
Writer.Block.BlockQuote = function(el)
  local parts = {}
  for _, b in ipairs(el.content) do
    parts[#parts + 1] = Writer.Block[b.t](b)
  end
  local sep = concat { cr, literal('\\\\'), cr }
  local body = layout.render(concat(parts, sep))
  local lines = {}
  for line in (body .. '\n'):gmatch('([^\n]*)\n') do
    if line == '' then
      lines[#lines + 1] = literal('>')
    elseif line:sub(1, 1) == '>' then
      lines[#lines + 1] = literal('>' .. line)
    else
      lines[#lines + 1] = literal('> ' .. line)
    end
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
  return ''
end

--- Render one list item. Leading Plain/Para content shares the marker line;
--- nested lists emit their own prefixed lines via the marker stack.
local function render_item(prefix, blocks)
  local lines = {}
  local lead = nil
  local tail = {}
  for _, b in ipairs(blocks) do
    if lead == nil and (b.t == 'Plain' or b.t == 'Para') then
      lead = Writer.Inlines(b.content)
    else
      tail[#tail + 1] = b
    end
  end
  lines[#lines + 1] = concat { literal(prefix .. ' '), lead or literal('') }
  for _, b in ipairs(tail) do
    lines[#lines + 1] = Writer.Block[b.t](b)
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
      rendered[#rendered + 1] = Writer.Inlines(pandoc.utils.blocks_to_inlines(blocks))
    end
    lines[#lines + 1] = concat {
      literal(';'), Writer.Inlines(term), literal(':'), concat(rendered, literal(' ')),
    }
  end
  return concat(lines, cr)
end

-- Tables -------------------------------------------------------------------

--- cbX cells are single-line: || starts a header row, | a body row. Block
--- structure inside a cell is flattened, with \\ standing in for breaks.
local function render_cell(cell)
  local inlines = pandoc.utils.blocks_to_inlines(cell.contents, { pandoc.LineBreak() })
  local doc = Writer.Inlines(inlines)
  -- A bare | inside a cell would start a new column.
  return literal((layout.render(doc):gsub('|', '~|')))
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
    for _, row in ipairs(body.body) do
      lines[#lines + 1] = render_row(row, '|')
    end
  end
  for _, row in ipairs(el.foot.rows) do
    lines[#lines + 1] = render_row(row, '|')
  end
  return concat(lines, cr)
end
