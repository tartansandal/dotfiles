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
          mason = false, -- installed via `uv tool install "robotcode[languageserver]"`; system Python is 3.9 so Mason can't install it
          -- Note: the `languageserver` extra is required or the `language-server`
          -- CLI subcommand won't exist (base package is just the CLI core).
          -- Anchor the workspace on the nearest robot.toml so the LSP picks the
          -- right root_dir.
          --
          -- Note: relative paths in robot.toml (python-path, paths, variable-files)
          -- resolve against the LSP subprocess's CWD, not the toml's location
          -- (robotcode#287). The clean way to live with this is to keep robot.toml
          -- at the *project root* (alongside .git) and write its paths relative to
          -- there — that way the LSP's CWD (= nvim's launch dir = project root)
          -- naturally matches the config's anchor. Putting robot.toml in a subdir
          -- only works if you remember to cd into it before launching nvim.
          root_markers = { "robot.toml", "robotcode.toml", "pyproject.toml", ".git" },
          -- The global tool install runs under its own uv-managed Python, which
          -- can be a different version than a project's venv. RobotCode has no
          -- config option to point library analysis at another interpreter, and
          -- since libraries can depend on compiled packages (e.g. matplotlib),
          -- injecting the venv's site-packages via PYTHONPATH isn't reliable
          -- across differing Python versions/ABIs. Prefer a venv-local install
          -- (`uv pip install "robotcode[languageserver]"` inside the project's
          -- venv) so the LSP runs under the exact same interpreter as the tests.
          on_new_config = function(config, root_dir)
            local venv_robotcode = root_dir .. "/.venv/bin/robotcode"
            if vim.fn.executable(venv_robotcode) == 1 then
              config.cmd = { venv_robotcode, "language-server" }
            end
          end,
        },
      },
    },
  },
}
