-- Disable copilot in markdown (prefer manual writing)
return {
  "zbirenbaum/copilot.lua",
  opts = {
    filetypes = {
      markdown = false,
    },
  },
}
