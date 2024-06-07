return {
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters_by_ft = {
        -- turn off markdown linting?
        markdown = {},
      },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters = {
        injected = {
          options = {
            -- Silence errors in formating code blocks
            -- ignore_errors = false,
          },
        },
      },
    },
  },
}
