local opt = vim.opt_local
--
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2

-- Emulate soft-wrapping common in other editors
opt.linebreak = true -- wrap long lines at word boundaries
opt.iskeyword["t"] = nil -- dont auto-wrap text using textwidth

-- Add '-' to keywords so we can search for references quickly
table.insert(opt.iskeyword, "-")

local map = vim.keymap.set
map(
  "n",
  "<localleader>`",
  "saiW`",
  { remap = true, buffer = true, desc = "Suround WORD with `" }
)
map(
  "n",
  '<localleader>"',
  'saiW"',
  { remap = true, buffer = true, desc = 'Suround WORD with "' }
)
map(
  "n",
  "<localleader>'",
  "saiW'",
  { remap = true, buffer = true, desc = "Suround WORD with '" }
)
map(
  "n",
  "<localleader>*",
  "saiW*saiW*",
  { remap = true, buffer = true, desc = "Suround WORD with **" }
)
map(
  "n",
  "<localleader>_",
  "saiW_",
  { remap = true, buffer = true, desc = "Suround WORD with _" }
)
map(
  "n",
  "<localleader>>",
  "saiW>",
  { remap = true, buffer = true, desc = "Suround WORD with >" }
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
