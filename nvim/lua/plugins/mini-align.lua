-- Configure mini.align with 'ga' mappings (lazy-loaded on keys)
return {
  {
    "nvim-mini/mini.align",
    version = "*",
    keys = {
      { "ga", mode = { "n", "v" }, desc = "Align" },
      { "gA", mode = { "n", "v" }, desc = "Align with preview" },
    },
    opts = {
      mappings = {
        start = "ga",
        start_with_preview = "gA",
      },
    },
  },
}
