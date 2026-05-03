-- NeoTree file explorer configuration
return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    event_handlers = {
      {
        event = "file_open_requested",
        handler = function()
          require("neo-tree.command").execute({ action = "close" })
        end,
      },
      {
        event = "after_render",
        handler = function(state)
          if not require("neo-tree.sources.common.preview").is_active() then
            state.config = { use_float = false }
            state.commands.toggle_preview(state)
          end
        end,
      },
    },
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
