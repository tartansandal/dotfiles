return {
  "folke/sidekick.nvim",
  opts = {
    cli = {
      -- Enable session persistence with tmux
      mux = {
        enabled = true,
        backend = "tmux",
        create = "terminal", -- Keep Claude in Nvim terminal (minimal keybinding conflicts)
      },
      -- Window layout configuration
      win = {
        layout = "right", -- Open Claude on the right side
        split = {
          width = 80, -- Terminal width for split layouts
        },
      },
      -- Custom prompts for common tasks
      prompts = {
        refactor = "Please refactor {this} to be more maintainable",
        security = "Review {file} for security vulnerabilities",
        commit = "Generate a commit message for {changes}",
        -- Smart help: Different behavior based on file type
        smart_help = function(ctx)
          local filetype = vim.bo.filetype
          if filetype == "python" then
            return "Review this Python code for PEP8 compliance: " .. ctx.file
          elseif filetype == "lua" then
            return "Review this Lua code for best practices: " .. ctx.file
          else
            return "Help me understand: " .. ctx.file
          end
        end,
      },
    },
  },
  keys = {
    -- Directly open Claude with <leader>ac
    {
      "<leader>ac",
      function()
        require("sidekick.cli").toggle({ name = "claude", focus = true })
      end,
      desc = "Sidekick Toggle Claude",
    },
  },
}
