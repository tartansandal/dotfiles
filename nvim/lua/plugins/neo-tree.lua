return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    window = {
      -- position = "right",
      mappings = {
        ["<tab>"] = function(state)
          state.commands["open"](state)
          vim.cmd("Neotree reveal")
        end,
        ["b"] = "none",
      },
    },
  },
}
