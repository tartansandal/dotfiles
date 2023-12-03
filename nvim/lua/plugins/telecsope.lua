return {
  "nvim-telescope/telescope-file-browser.nvim",
  dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
  keys = {
    { "<leader>F", "<cmd>Telescope file_browser<cr>", desc = "Browse Files" },
  },
}
