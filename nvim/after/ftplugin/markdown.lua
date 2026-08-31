local opt = vim.opt_local
--
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.wrap = true

-- Emulate soft-wrapping common in other editors
opt.linebreak = true -- wrap long lines at word boundaries
opt.breakindent = true -- visually indent wrapped lines to preserve block indentation
opt.iskeyword["-"] = true -- Include '-' in keywords for quick reference searches

opt.formatoptions:remove("t") -- dont auto-wrap text using textwidth

local map = vim.keymap.set

-- These need `remap = true`: the RHS starts with `sa`, which is mini.surround's
-- "add surrounding" mapping (see lua/plugins/surround.lua), not a builtin. Without
-- recursion `s` would run the builtin substitute-char instead.
map(
  "n",
  "<localleader>`",
  "saiW`",
  { remap = true, buffer = true, desc = "Surround WORD with `" }
)
map(
  "n",
  '<localleader>"',
  'saiW"',
  { remap = true, buffer = true, desc = 'Surround WORD with "' }
)
map(
  "n",
  "<localleader>'",
  "saiW'",
  { remap = true, buffer = true, desc = "Surround WORD with '" }
)
map(
  "n",
  "<localleader>*",
  "saiW*saiW*",
  { remap = true, buffer = true, desc = "Surround WORD with **" }
)
map(
  "n",
  "<localleader>_",
  "saiW_",
  { remap = true, buffer = true, desc = "Surround WORD with _" }
)
map(
  "n",
  "<localleader>>",
  "saiW>",
  { remap = true, buffer = true, desc = "Surround WORD with >" }
)
-- Builtins only, so these stay non-recursive (the default).
map(
  "n",
  "<localleader>s",
  "[s1z=``",
  { buffer = true, desc = "Fix last spelling mistake" }
)
map(
  "i",
  "<localleader>s",
  "<Esc>[s1z=A",
  { buffer = true, desc = "Fix last spelling mistake" }
)

-- cbX conversion (see ~/dotfiles/bin/cbwiki). Drafts live in this buffer and
-- the markup is destined for a browser, so the converted text goes to the
-- system clipboard rather than replacing the draft in place.
local function cbwiki(input, args)
  local cmd = vim.list_extend({ "cbwiki" }, args or {})
  -- vim.fn.system(cmd, nil) passes v:null, which reaches the child as the
  -- literal text "v:null" on stdin; omit the argument entirely instead.
  local out = input and vim.fn.system(cmd, input) or vim.fn.system(cmd)
  if vim.v.shell_error ~= 0 then
    vim.notify("cbwiki: " .. vim.trim(out), vim.log.levels.ERROR)
    return nil
  end
  return out
end

--- Line range of the fenced code block under the cursor, if any. Fences are
--- counted from the top of the buffer so an odd ``` inside prose cannot
--- flip the pairing for the rest of the file.
local function fenced_range()
  local cursor = vim.fn.line(".")
  local open = nil
  for lnum, line in ipairs(vim.api.nvim_buf_get_lines(0, 0, -1, false)) do
    if line:match("^%s*```") then
      if open then
        if cursor > open and cursor < lnum then
          return open + 1, lnum - 1
        end
        open = nil
      else
        open = lnum
      end
    end
  end
  return nil
end

vim.api.nvim_buf_create_user_command(0, "CbWiki", function(opts)
  local first, last = opts.line1, opts.line2
  -- No explicit range: prefer the enclosing code block over the whole buffer.
  if opts.range == 0 then
    first, last = fenced_range()
    if not first then
      first, last = 1, vim.fn.line("$")
    end
  end
  local lines = vim.api.nvim_buf_get_lines(0, first - 1, last, false)
  local out = cbwiki(table.concat(lines, "\n") .. "\n")
  if out then
    vim.fn.setreg("+", out)
    vim.notify(("cbwiki: %d lines copied as cbX markup"):format(last - first + 1))
  end
end, { range = true, desc = "Convert Markdown to cbX markup on the clipboard" })

vim.api.nvim_buf_create_user_command(0, "CbWikiBack", function()
  local out = cbwiki(nil, { "-c" })
  if out then
    local lines = vim.split(vim.trim(out), "\n", { plain = true })
    -- Nested ``` fences would close the wrapper early. ~~~ is the equivalent
    -- CommonMark form, so :CbWiki still reads the block back unchanged.
    for i, line in ipairs(lines) do
      lines[i] = line:gsub("^(%s*)```", "%1~~~")
    end
    table.insert(lines, 1, "```markdown")
    table.insert(lines, "```")
    local at = vim.fn.line(".")
    vim.api.nvim_buf_set_lines(0, at, at, false, lines)
    -- Land inside the block, not on the line above its opening fence, or
    -- fenced_range() will not recognise it as the enclosing block.
    vim.api.nvim_win_set_cursor(0, { at + 2, 0 })
    vim.notify(("cbwiki: inserted %d lines from the clipboard"):format(#lines - 2))
  end
end, { desc = "Insert the copied cbX block as a Markdown block" })

map("n", "<localleader>c", "<Cmd>CbWiki<CR>", {
  buffer = true,
  desc = "Copy block as cbX markup",
})
map("x", "<localleader>c", ":CbWiki<CR>", {
  buffer = true,
  desc = "Copy selection as cbX markup",
})
map("n", "<localleader>C", "<Cmd>CbWikiBack<CR>", {
  buffer = true,
  desc = "Insert copied cbX block as Markdown",
})
