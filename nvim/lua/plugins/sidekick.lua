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
          width = 88, -- Terminal width for split layouts
        },
      },
      -- Custom prompts for common tasks
      prompts = {
        refactor = "Please refactor {this} to be more maintainable",
        security = "Review {file} for security vulnerabilities",
        commit = "Generate a commit message for the current changes",
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
