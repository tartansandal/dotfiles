-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

--
-- blank line insertion
--

local blank_up = function()
  -- start with 1 empty line
  local lines = { "" }
  -- add empty lines for each value of count greater than 1
  for _ = 2, vim.v.count do
    table.insert(lines, "")
  end
  vim.api.nvim_put(lines, "l", false, false)
  -- return to previous position
  vim.cmd("']+")
end

local blank_down = function()
  local lines = { "" }
  -- add empty lines for each value of count greater than 1
  for _ = 2, vim.v.count do
    table.insert(lines, "")
  end
  vim.api.nvim_put(lines, "l", true, false)
  -- return to previous position
  vim.cmd("'[-")
end

map("n", "[<space>", blank_up, { desc = "Add line above" })
map("n", "]<space>", blank_down, { desc = "Add line below" })

--
-- window mappings
--

map("n", "<leader>wo", "<c-w>o", { desc = "Close other windows" })

--
-- Copy buffer filenames
--
map(
  "n",
  "<leader>bfr",
  '<cmd>let @+=expand("%")<CR>',
  { remap = false, silent = true, desc = "Copy relative path of buffer file" }
)
map(
  "n",
  "<leader>bfa",
  '<cmd>let @+=expand("%:p")<CR>',
  { remap = false, silent = true, desc = "Copy absolute path of buffer file" }
)
vim.keymap.set(
  "n",
  "<leader>b/",
  ":exec 'cd' . expand('%:p:h')<CR>",
  { remap = false, silent = true, desc = "CD to the current buffers directory" }
)
