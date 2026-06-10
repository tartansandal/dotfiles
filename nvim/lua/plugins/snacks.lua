-- Configure Snacks: picker, lazygit, indent (scope disabled)
-- Explorer disabled in favor of neo-tree
return {
  {
    "snacks.nvim",
    opts = {
      lazygit = { enabled = true },
      indent = { enabled = true, scope = { enabled = false } },
      image = { enabled = true },
      styles = {
        -- terminal = { keys = { term_normal = false } },
        lazygit = { keys = { term_normal = false } },
      },
      explorer = { enabled = false },
      bigfile = { enabled = true },
      picker = {
        enabled = true,
        matcher = {
          frequency = true, -- frecency bonus
          history_bonus = true, -- give more weight to chronological order
        },
        actions = {
          copy_notification = function(_, item)
            -- grab the message text, with fallbacks for field naming
            local text = item.msg or item.text or (item.notif and item.notif.msg) or ""
            vim.fn.setreg("+", text)
            vim.notify("Copied notification to clipboard")
          end,
        },
        sources = {
          -- <c-y> copies the highlighted notification (no default copy action)
          notifications = {
            win = {
              input = {
                keys = {
                  ["<c-y>"] = { "copy_notification", mode = { "n", "i" } },
                },
              },
            },
          },
        },
      },
    },
  },
}
