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
          -- Anchor the workspace on the nearest robot.toml so the LSP picks the
          -- right root_dir when nvim is launched from inside the project tree.
          --
          -- Note: relative paths in robot.toml (python-path, paths, variable-files)
          -- are resolved against the LSP subprocess's CWD, not the toml's location
          -- (robotcode#287). Auto-setting cmd_cwd doesn't work — on_new_config is
          -- bypassed by nvim 0.11+'s vim.lsp.config spawn path. Workaround: launch
          -- nvim from the directory containing robot.toml.
          root_markers = { "robot.toml", "robotcode.toml", "pyproject.toml", ".git" },
        },
      },
    },
  },
}
