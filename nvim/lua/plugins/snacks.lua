return {
  {
    "snacks.nvim",
    opts = {
      lazygit = { enabled = true },
      indent = { enabled = true, scope = { enabled = false } },
      styles = {
        -- terminal = { keys = { term_normal = false } },
        lazygit = { keys = { term_normal = false } },
      },
      explorer = { enabled = true },
      bigfile = { enabled = true },
      picker = {
        enabled = true,
        matcher = {
          frequency = true, -- frecency bonus
          history_bonus = true, -- give more weight to chronological order
        },
      },
    },
  },
}
