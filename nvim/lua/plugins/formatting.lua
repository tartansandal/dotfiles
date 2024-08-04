return {
  "stevearc/conform.nvim",
  opts = {
    formatters = {
      injected = {
        options = {
          ignore_errors = false,
          lang_to_ext = {
            bash = "sh",
            javascript = "js",
            markdown = "md",
            python = "py",
            typescript = "ts",
            sql = "sql",
          },
        },
        lang_to_formatters = {
          python = "rust",
        },
      },
    },
  },
}
