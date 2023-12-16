return {
  -- neo-tree
  -- spectre
  -- telescpope
  -- flash
  -- which-key
  -- gitsigns
  -- buffremove
  -- trouble
  -- todo-comments

  {
    "tyru/open-browser.vim",
    keys = {
      { "gx", "<Plug>(openbrowser-open)", mode = { "n", "v" }, desc = "Open URL under cursor" },
    },
  },

  {
    "folke/which-key.nvim",
    opts = {
      defaults = {
        ["<leader>bf"] = { name = "+filename" },
      },
    },
  },
}
