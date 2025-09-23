return {

  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "zbirenbaum/copilot.lua",
      "franco-ruggeri/codecompanion-spinner.nvim",
    },
    opts = {
      extensions = {
        spinner = {},
        vectorcode = {
          opts = { add_tool = true, add_slash_command = true, tool_opts = {} },
        },
      },
      strategies = {
        -- Change the default chat adapter
        chat = {
          adapter = "copilot",
        },
      },
      display = {
        action_palette = {
          provider = "default",
        },
        chat = {
          -- show_references = true,
          -- show_header_separator = false,
          -- show_settings = false,
          icons = {
            tool_success = "󰸞 ",
          },
          fold_context = true,
        },
        diff = {
          provider = "mini_diff",
        },
      },
      -- Set debug logging
      log_level = "DEBUG",
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
        desc = "Code Companion Chat",
        mode = { "n", "v" },
      },
    },
    init = function()
      -- Create a command line abbreviation (cc) for CodeCompanion
      vim.cmd([[cab cc CodeCompanion]])
    end,
  },

  {
    "Davidyz/VectorCode",
    version = "*", -- optional, depending on whether you're on nightly or release
    build = "uv tool upgrade vectorcode", -- optional but recommended if you set `version = "*"`
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "codecompanion" },
  },
  {
    "nvim-mini/mini.diff",
    config = function()
      local diff = require("mini.diff")
      diff.setup({
        -- Disabled by default
        source = diff.gen_source.none(),
      })
    end,
  },
}
