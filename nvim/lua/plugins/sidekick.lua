return {
  "folke/sidekick.nvim",
  opts = function()
    -- Set up yellow border highlight using Catppuccin yellow
    local palette = require("catppuccin.palettes").get_palette("mocha")
    vim.api.nvim_set_hl(0, "SidekickBorder", { fg = palette.yellow })

    return {
      cli = {
        -- Enable session persistence with tmux
        mux = {
          enabled = true,
          backend = "tmux",
          create = "terminal", -- Keep Claude in Nvim terminal (minimal keybinding conflicts)
        },
        -- Window layout configuration
        win = {
          layout = "float", -- Open Claude in floating window
          wo = {
            winhighlight = "Normal:SidekickChat,NormalNC:SidekickChat,EndOfBuffer:SidekickChat,SignColumn:SidekickChat,FloatBorder:SidekickBorder",
          },
          float = {
            border = "rounded",
            width = 0.8, -- 80% of screen width
            height = 0.8, -- 80% of screen height
          },
        },
        -- Custom prompts for common tasks
        prompts = {
          refactor = "Please refactor {this} to be more maintainable",
          security = "Review {file} for security vulnerabilities",
          commit = "Generate a commit message for the current changes",
        },
      },
    }
  end,
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
