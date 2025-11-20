-- Disable copilot in markdown (prefer manual writing)
-- TEMPORARY: Copilot disabled - set enabled = true to re-enable
return {
  "zbirenbaum/copilot.lua",
  enabled = false,
  opts = {
    filetypes = {
      markdown = false,
    },
  },
}
