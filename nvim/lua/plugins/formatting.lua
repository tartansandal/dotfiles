-- Configure formatters: stylua, shfmt, ruff_format, sqlfmt
return {
  "stevearc/conform.nvim",
  opts = {
    formatters = {
      injected = {
        options = {
          ignore_errors = false,
          -- Map of treesitter language to file extension
          -- A temporary file name with this extension will be generated during formatting
          -- because some formatters care about the filename.
          lang_to_ext = {
            bash = "sh",
            javascript = "js",
            latex = "tex",
            markdown = "md",
            python = "py",
            typescript = "ts",
            lua = "lua",
            sql = "sql",
          },
          -- Map of treesitter language to formatters to use
          -- (defaults to the value from formatters_by_ft)
          lang_to_formatters = {},
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
