-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Auto enter insert mode when entering terminal buffers
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "term://*",
  callback = function()
    vim.cmd("startinsert")
  end,
  desc = "Auto enter insert mode in terminal buffers",
})

-- Prevent staying in normal mode in terminal buffers
vim.api.nvim_create_autocmd("ModeChanged", {
  pattern = "*:n",
  callback = function()
    if vim.bo.buftype == "terminal" then
      vim.cmd("startinsert")
    end
  end,
  desc = "Prevent normal mode in terminal buffers",
})

-- Custom window separator color
-- Set immediately
vim.api.nvim_set_hl(0, "WinSeparator", {
  fg = "#80859B", -- Catppuccin overlay2
})

-- Also set on colorscheme change
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    vim.api.nvim_set_hl(0, "WinSeparator", {
      fg = "#80859B", -- Catppuccin overlay2
    })
  end,
  desc = "Set overlay2 window separator",
})
