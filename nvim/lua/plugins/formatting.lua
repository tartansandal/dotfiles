return {
  "stevearc/conform.nvim",
  opts = {
    formatters = {
      injected = {
        options = {
          ignore_errors = false,
        },
      },
    },
    formatters_by_ft = {
      lua = { "stylua" },
      sh = { "shfmt" },
      python = { "ruff_format" },
      sql = { "sqlfmt" },
    },
  },
}
