return {
  {
    "saghen/blink.compat",
    -- use the latest release, via version = '*', if you also use the latest release for blink.cmp
    version = "*",
    -- lazy.nvim will automatically load the plugin when it's required by blink.cmp
    lazy = true,
    -- make sure to set opts so that lazy.nvim calls blink.compat's setup
    opts = {},
  },
  {
    "saghen/blink.cmp",
    dependencies = {
      "moyiz/blink-emoji.nvim",
      "saghen/blink.compat",
      "hrsh7th/cmp-calc",
    },

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      -- experimental signature help support
      -- signature = { enabled = true },

      sources = {
        -- adding any nvim-cmp sources here will enable them
        -- with blink.compat
        compat = { "calc" },
        default = { "lsp", "path", "calc", "snippets", "buffer", "emoji" },
        cmdline = {},
        providers = {
          emoji = {
            module = "blink-emoji",
            name = "emoji",
            score_offset = 15, -- Tune by preference
          },
        },
      },
      keymap = {
        preset = "default",
      },
    },
  },
}
