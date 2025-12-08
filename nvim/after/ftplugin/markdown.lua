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
map(
  "n",
  "<localleader>s",
  "[s1z=``",
  { noremap = false, buffer = true, desc = "Fix last spelling mistake" }
)
map(
  "i",
  "<localleader>s",
  "<Esc>[s1z=A",
  { noremap = false, buffer = true, desc = "Fix last spelling mistake" }
)
