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
    -- Toggle Claude in floating window
    {
      "<leader>ac",
      function()
        local layout = "float"
        require("sidekick.config").cli.win.layout = layout
        local State = require("sidekick.cli.state")
        State.with(function(state, attached)
          if not state.terminal then
            return
          end
          if attached then
            -- Freshly created: already opened with correct layout via config
            if state.terminal:is_open() then
              state.terminal:focus()
            end
            return
          end
          -- Existing terminal
          local current = state.terminal.opts.layout
          state.terminal.opts.layout = layout
          if state.terminal:is_open() then
            if current == layout then
              state.terminal:toggle()
            else
              state.terminal:hide()
              state.terminal:show()
              state.terminal:focus()
            end
          else
            state.terminal:show()
            state.terminal:focus()
          end
        end, {
          attach = true,
          filter = { name = "claude" },
        })
      end,
      desc = "Sidekick Toggle Claude (float)",
    },
    -- Toggle Claude in side-by-side split
    {
      "<leader>as",
      function()
        local layout = "right"
        require("sidekick.config").cli.win.layout = layout
        local State = require("sidekick.cli.state")
        State.with(function(state, attached)
          if not state.terminal then
            return
          end
          if attached then
            -- Freshly created: already opened with correct layout via config
            if state.terminal:is_open() then
              state.terminal:focus()
            end
            return
          end
          -- Existing terminal
          local current = state.terminal.opts.layout
          state.terminal.opts.layout = layout
          if state.terminal:is_open() then
            if current == layout then
              state.terminal:toggle()
            else
              state.terminal:hide()
              state.terminal:show()
              state.terminal:focus()
            end
          else
            state.terminal:show()
            state.terminal:focus()
          end
        end, {
          attach = true,
          filter = { name = "claude" },
        })
      end,
      desc = "Sidekick Toggle Claude (split)",
    },
  },
}
