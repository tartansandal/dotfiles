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
          mason = false, -- installed via `uv tool install "robotcode[languageserver]"`; the `languageserver` extra is required or the `language-server` subcommand won't exist
          -- Relative paths in robot.toml (python-path, paths, ...) resolve against
          -- the LSP's CWD, not the toml's location (robotcode#287) — keeping
          -- robot.toml at the project root keeps the two in sync.
          root_markers = { "robot.toml", "robotcode.toml", "pyproject.toml", ".git" },
          -- `on_new_config` is a legacy lspconfig-manager hook LazyVim's native
          -- vim.lsp.config()/vim.lsp.enable() path never calls; use a `cmd`
          -- function instead, which does receive the resolved config.root_dir.
          --
          -- Prefer a venv-local robotcode install over the global uv-tool one:
          -- the global install's own interpreter can differ in version from the
          -- project venv, and PYTHONPATH can't bridge that for libraries with
          -- compiled deps (e.g. matplotlib).
          cmd = function(dispatchers, config)
            local root_dir = config.root_dir
            -- Only guess `<root_dir>/.venv` when no venv is active — never
            -- override an explicitly activated $VIRTUAL_ENV that happens to
            -- lack robotcode, or we could silently run the wrong virtualenv.
            local candidate
            if vim.env.VIRTUAL_ENV then
              candidate = vim.env.VIRTUAL_ENV .. "/bin/robotcode"
            elseif root_dir then
              candidate = root_dir .. "/.venv/bin/robotcode"
            end
            local bin = (candidate and vim.fn.executable(candidate) == 1) and candidate or "robotcode"
            vim.notify(
              string.format(
                "[robotcode] root_dir=%s VIRTUAL_ENV=%s -> using %s",
                tostring(root_dir),
                tostring(vim.env.VIRTUAL_ENV),
                bin
              ),
              vim.log.levels.INFO,
              { title = "robotcode" }
            )
            return vim.lsp.rpc.start({ bin, "language-server" }, dispatchers, {
              cwd = config.cmd_cwd,
              env = config.cmd_env,
            })
          end,
        },
      },
    },
  },
}
