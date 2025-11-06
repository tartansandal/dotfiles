-- Configure mini.align with 'ga' mappings
return {
  {
    "nvim-mini/mini.align",
    version = "*",
    opts = {
      mappings = {
        start = "ga",
        start_with_preview = "gA",
      },
    },
  },
}
