return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    enabled = false,
  },
  {
    "echasnovski/mini.files",
    version = "*",
    opts = {
      windows = {
        preview = true,
        width_focus = 20,
        width_nofocus = 15,
        width_preview = 60,
      },
      options = {
        -- Whether to use for editing directories
        use_as_default_explorer = true,
      },
      content = {
        -- filter = nil,
        -- hide __pycache__ directories
        filter = function(fs_entry)
          return not (fs_entry.name == "__pycache__")
        end,
      },
    },
    keys = {
      {
        "<leader>e",
        function()
          require("mini.files").open(vim.api.nvim_buf_get_name(0), true)
        end,
        desc = "Explore (Directory of Current File)",
      },
      {
        "<leader>E",
        function()
          require("mini.files").open(vim.uv.cwd(), true)
        end,
        desc = "Explore (cwd)",
      },
      -- override the defaults from extras
      {
        "<leader>fe",
        function()
          require("mini.files").open(vim.api.nvim_buf_get_name(0), true)
        end,
        desc = "Explore (Directory of Current File)",
      },
      {
        "<leader>fE",
        function()
          require("mini.files").open(vim.uv.cwd(), true)
        end,
        desc = "Explore (cwd)",
      },
    },
    config = function(_, opts)
      -- hide dotfiles by default
      local hide_dotfiles = true

      -- track the original configured filter
      local orig_filter = opts.content.filter

      local filter_hidden = function(fs_entry)
        if hide_dotfiles and vim.startswith(fs_entry.name, ".") then
          return false
        end
        if type(orig_filter) == "function" then
          return orig_filter(fs_entry)
        end
        return true
      end
      opts.content.filter = filter_hidden

      -- don't like the I have to do this to inject the option change
      require("mini.files").setup(opts)

      local toggle_dotfiles = function()
        hide_dotfiles = not hide_dotfiles
        require("mini.files").refresh({ content = { filter = filter_hidden } })
      end

      vim.api.nvim_create_autocmd("User", {
        pattern = "MiniFilesBufferCreate",
        callback = function(args)
          local buf_id = args.data.buf_id
          -- Tweak left-hand side of mapping to your liking
          vim.keymap.set(
            "n",
            "g.",
            toggle_dotfiles,
            { buffer = buf_id, desc = "Toggle Hidden Files" }
          )
        end,
      })

      vim.api.nvim_create_autocmd("User", {
        pattern = "MiniFilesActionRename",
        callback = function(event)
          Snacks.rename.on_rename_file(event.data.from, event.data.to)
        end,
      })

      -- Set focused directory as current working directory
      local set_cwd = function()
        local path = (MiniFiles.get_fs_entry() or {}).path
        if path == nil then
          return vim.notify("Cursor is not on valid entry")
        end
        vim.fn.chdir(vim.fs.dirname(path))
      end

      -- Yank in register full path of entry under cursor
      local yank_path = function()
        local path = (MiniFiles.get_fs_entry() or {}).path
        if path == nil then
          return vim.notify("Cursor is not on valid entry")
        end
        vim.fn.setreg(vim.v.register, path)
      end

      vim.api.nvim_create_autocmd("User", {
        pattern = "MiniFilesBufferCreate",
        callback = function(args)
          local b = args.data.buf_id
          vim.keymap.set("n", "g~", set_cwd, { buffer = b, desc = "Set cwd" })
          vim.keymap.set("n", "gy", yank_path, { buffer = b, desc = "Yank path" })
        end,
      })
      return opts
    end,
  },
}
