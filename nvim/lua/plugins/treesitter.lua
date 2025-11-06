-- Ensure additional treesitter parsers are installed
return {
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = { ensure_installed = { "sql", "latex", "html" } },
  },
}
