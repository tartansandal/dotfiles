-- Robot Framework: treesitter highlighting + robotcode LSP
return {
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = { ensure_installed = { "robot" } },
  },
  {
    "neovim/nvim-lspconfig",
    optional = true,
    opts = {
      servers = {
        robotcode = {
          mason = false, -- installed via `uv tool install robotcode`; system Python is 3.9 so Mason can't install it
          -- Anchor the workspace on the nearest robot.toml so nvim can be launched
          -- from anywhere in the tree and still find the project's robotcode config.
          root_markers = { "robot.toml", "robotcode.toml", "pyproject.toml", ".git" },
        },
      },
    },
  },
}
