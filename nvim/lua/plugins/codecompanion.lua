return {

  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "zbirenbaum/copilot.lua",
    },
    opts = {
      extensions = {
        vectorcode = {
          opts = { add_tool = true, add_slash_command = true, tool_opts = {} },
        },
      },
    },
    keys = {
      { "<leader>a", "", desc = "+ai", mode = { "n", "v" } },
      {
        "<leader>aa",
        "<cmd>CodeCompanionActions<cr>",
        desc = "Code Companion Actions",
        mode = { "n", "v" },
      },
      {
        "<leader>ac",
        "<cmd>CodeCompanionChat Toggle<cr>",
        desc = "Code Companion Actions",
        mode = { "n", "v" },
      },
    },
  },

  {
    "Davidyz/VectorCode",
    version = "*", -- optional, depending on whether you're on nightly or release
    build = "uv tool upgrade vectorcode", -- optional but recommended if you set `version = "*"`
    dependencies = { "nvim-lua/plenary.nvim" },
  },
}
