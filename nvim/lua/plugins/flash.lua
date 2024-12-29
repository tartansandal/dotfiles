return {
  {
    "folke/flash.nvim",
    keys = {
      { "s", mode = { "n", "o", "x" }, false },
      { "S", mode = { "n", "o", "x" }, false },
      { "r", mode = "o", false },
      { "R", mode = { "o", "x" }, false },
      { "<c-s>", mode = { "c" }, false },
      {
        "f",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump()
        end,
        desc = "Flash",
      },
      {
        "F",
        mode = { "n", "x", "o" },
        function()
          require("flash").treesitter()
        end,
        desc = "Flash Treesitter",
      },
    },
    opts = {
      modes = {
        char = {
          search = { wrap = true },
          jump_labels = true,
        },
      },
    },
  },
}
