-- Add custom which-key groups for buffer filenames and obsidian
return {
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { "<leader>bf", group = "filename" },
        { "<leader>o", group = "obsidian" },
      },
    },
  },
}
