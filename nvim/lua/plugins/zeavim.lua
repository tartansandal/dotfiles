-- Zeavim integration for offline documentation lookup
return {
  {
    "KabbAmine/zeavim.vim",
    version = "*",
    event = "LazyFile",
    keys = {
      { "<leader>cz", "<cmd>Zeavim<cr>", desc = "Zeal lookup" },
    },
  },
}
