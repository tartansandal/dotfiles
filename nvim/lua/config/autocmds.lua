-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

local function augroup(name)
  return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
end

-- local keymaps and options for markdown files
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("markdown"),
  pattern = { "markdown" },
  callback = function()
    local map = vim.keymap.set

    -- These are not working for some reason
    -- local opt = vim.opt_local
    --
    -- opt.tabstop = 2
    -- opt.shiftwidth = 2
    -- opt.softtabstop = 2
    --
    -- -- Emulate soft-wrapping common in other editors
    -- opt.linebreak = true -- wrap long lines at word boundaries
    -- opt.iskeyword["t"] = nil -- dont auto-wrap text using textwidth
    --
    -- -- Add '-' to keywords so we can search for references quickly
    -- table.insert(opt.iskeyword, "-")

    map(
      "n",
      "<localleader>`",
      "gsaiW`",
      { remap = true, buffer = true, desc = "Suround WORD with `" }
    )
    map(
      "n",
      '<localleader>"',
      'gsaiW"',
      { remap = true, buffer = true, desc = 'Suround WORD with "' }
    )
    map(
      "n",
      "<localleader>'",
      "gsaiW'",
      { remap = true, buffer = true, desc = "Suround WORD with '" }
    )
    map(
      "n",
      "<localleader>*",
      "gsaiW*",
      { remap = true, buffer = true, desc = "Suround WORD with *" }
    )
    map(
      "n",
      "<localleader>>",
      "gsaiW>",
      { remap = true, buffer = true, desc = "Suround WORD with >" }
    )
  end,
})
