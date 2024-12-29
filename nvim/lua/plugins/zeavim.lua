return {
  {
    "KabbAmine/zeavim.vim",
    version = "*", -- recommended, use latest release instead of latest commit
    event = "LazyFile",
    keys = {
      { "<leader>cz", "<cmd>Zeavim<cr>", desc = "Zeal lookup" },
    },
  },
}
