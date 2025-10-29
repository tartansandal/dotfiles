return {
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters_by_ft = {
        -- turn off markdown linting?
        markdown = {},
      },
    },
  },
  {
    -- "epwalsh/obsidian.nvim",
    "obsidian-nvim/obsidian.nvim",

    version = "*", -- recommended, use latest release instead of latest commit
    lazy = true,
    -- ft = "markdown",
    -- Replace the above line with this if you only want to load obsidian.nvim for
    -- markdown files in your vault:
    event = {
      "BufReadPre " .. vim.fn.expand("~") .. "/Notes/**.md",
      "BufNewFile " .. vim.fn.expand("~") .. "/Notes/**.md",
    },
    dependencies = {
      -- Required.
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      -- A list of workspace names, paths, and configuration overrides.
      -- If you use the Obsidian app, the 'path' of a workspace should generally be
      -- your vault root (where the `.obsidian` folder is located).
      -- When obsidian.nvim is loaded by your plugin manager, it will automatically set
      -- the workspace to the first workspace in the list whose `path` is a parent of the
      -- current markdown file being edited.
      workspaces = {
        {
          name = "Notes",
          path = "~/Notes",
        },
      },

      -- Optional, if you keep notes in a specific subdirectory of your vault.
      notes_subdir = "Cards",

      -- Optional, set the log level for obsidian.nvim. This is an integer corresponding
      -- to one of the log levels defined by "vim.log.levels.*".
      log_level = vim.log.levels.INFO,

      daily_notes = {
        -- Optional, if you keep daily notes in a separate directory.
        folder = "Daily",
        -- Optional, if you want to change the date format for the ID of daily notes.
        date_format = "%Y/%V/%Y-%m-%d",
        -- Optional, if you want to change the date format of the default alias of daily
        -- notes.
        alias_format = "%a %-d %B %Y",
        -- Optional, if you want to automatically insert a template from your template
        -- directory like 'daily.md'
        template = "daily_unwell.md",
        -- Optional, if you want `Obsidian yesterday` to return the last work day or
        -- `Obsidian tomorrow` to return the next work day.
        workdays_only = false,
      },

      -- Optional, completion of wiki links, local markdown links, and tags using
      -- nvim-cmp.
      completion = {
        -- Enables completion using nvim_cmp.
        nvim_cmp = false,
        -- Enables completion using blink.cmp
        blink = true,
        -- Trigger completion at 2 chars
        min_chars = 2,
        -- Set to false to disable new note creation in the picker
        create_new = true,
      },

      -- Where to put new notes created from completion. Valid options are
      --  * "current_dir" - put new notes in same directory as the current buffer.
      --  * "notes_subdir" - put new notes in the default notes subdirectory.
      new_notes_location = "notes_subdir",

      -- Optional, customize how names/IDs for new notes are created.
      note_id_func = function(title)
        -- Create note IDs in a Zettelkasten format with a timestamp and a suffix. In
        -- this case a note with the title 'My new note' will be given an ID that looks
        -- like '1657296016-my-new-note', and therefore the file name
        -- '1657296016-my-new-note.md'. You may have as many periods in the note ID as
        -- you'd like—the ".md" will be added automatically
        local suffix = ""
        if title ~= nil then
          -- If title is given, transform it into valid file name.
          suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
        else
          -- If title is nil, just add 4 random uppercase letters to the suffix.
          for _ = 1, 4 do
            suffix = suffix .. string.char(math.random(65, 90))
          end
        end
        return tostring(os.date("%Y%m%d%H%M%S")) .. "-" .. suffix
      end,

      -- Optional, customize how note file names are generated given the ID, target directory, and title.
      ---@param spec { id: string, dir: obsidian.Path, title: string|? }
      ---@return string|obsidian.Path The full path to the new note.
      note_path_func = function(spec)
        -- This is equivalent to the default behavior.
        local path = spec.dir / tostring(spec.id)
        return path:with_suffix(".md")
      end,

      -- Optional, customize how wiki links are formatted. You can set this to one of:
      -- _ "use_alias_only", e.g. '[[Foo Bar]]'
      -- _ "prepend*note_id", e.g. '[[foo-bar|Foo Bar]]'
      -- * "prepend*note_path", e.g. '[[foo-bar.md|Foo Bar]]'
      -- * "use_path_only", e.g. '[[foo-bar.md]]'
      -- Or you can set it to a function that takes a table of options and returns a string, like this:
      -- wiki_link_func = function(opts)
      --   return require("obsidian.util").wiki_link_id_prefix(opts)
      -- end,
      wiki_link_func = "use_alias_only",

      -- Optional, customize how markdown links are formatted.
      markdown_link_func = function(opts)
        return require("obsidian.util").markdown_link(opts)
      end,

      -- Either 'wiki' or 'markdown'.
      preferred_link_style = "wiki",

      -- Optional, set to true if you don't want obsidian.nvim to manage frontmatter.
      disable_frontmatter = false,

      -- Optional, alternatively you can customize the frontmatter data.
      ---@return table
      note_frontmatter_func = function(note)
        -- Add the title of the note as an alias.
        if note.title then
          note:add_alias(note.title)
        end

        local out = { id = note.id, aliases = note.aliases, tags = note.tags }

        -- `note.metadata` contains any manually added fields in the frontmatter.
        -- So here we just make sure those fields are kept in the frontmatter.
        if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
          for k, v in pairs(note.metadata) do
            out[k] = v
          end
        end

        return out
      end,

      -- Optional, for templates (see
      -- https://github.com/obsidian-nvim/obsidian.nvim/wiki/Using-templates)
      templates = {
        folder = "Templates",
        date_format = "%Y-%m-%d",
        time_format = "%H:%M",
        -- A map for custom variables, the key should be the variable and the value
        -- a function
        substitutions = {
          week = function()
            return tostring(os.date("%V"))
          end,
        },
      },

      -- Sets how you follow URLs
      ---@param url string
      follow_url_func = function(url)
        -- vim.ui.open(url)
        vim.ui.open(url, { cmd = { "xdg-open" } })
      end,

      -- Sets how you follow images
      ---@param img string
      follow_img_func = function(img)
        -- vim.ui.open(img)
        vim.ui.open(img, { cmd = { "xdg-open" } })
      end,

      open = {
        use_advanced_uri = false,
        func = vim.ui.open,
      },

      picker = {
        -- Set your preferred picker. Can be one of 'telescope.nvim', 'fzf-lua', 'mini.pick', or 'snacks.pick'.
        -- name = "telescope.nvim",
        name = "fzf-lua",
        -- Optional, configure key mappings for the picker. These are the defaults.
        -- Not all pickers support all mappings.
        notemappings = {
          -- Create a new note from your query.
          new = "<C-x>",
          -- Insert a link to the selected note.
          insert_link = "<C-l>",
        },
        tag_mappings = {
          -- Add tag(s) to current note.
          tag_note = "<C-x>",
          -- Insert a tag at the current location.
          insert_tag = "<C-l>",
        },
      },

      -- Optional, by default, `:ObsidianBacklinks` parses the header under
      -- the cursor. Setting to `false` will get the backlinks for the current
      -- note instead. Doesn't affect other link behaviour.
      backlinks = {
        parse_headers = true,
      },

      -- Optional, sort search results by "path", "modified", "accessed", or "created".
      -- The recommend value is "modified" and `true` for `sort_reversed`, which means, for example,
      -- that `:ObsidianQuickSwitch` will show the notes sorted by latest modified time
      sort_by = "modified",
      sort_reversed = true,

      -- Set the maximum number of lines to read from notes on disk when performing certain searches.
      search_max_lines = 1000,

      -- Optional, determines how certain commands open notes. The valid options are:
      -- 1. "current" (the default) - to always open in the current window
      -- 2. "vsplit" - only open in a vertical split if a vsplit does not exist.
      -- 3. "hsplit" - only open in a horizontal split if a hsplit does not exist.
      -- 4. "vsplit_force" - always open a new vertical split if the file is not in the adjacent vsplit.
      -- 5. "hsplit_force" - always open a new horizontal split if the file is not in the adjacent hsplit.
      open_notes_in = "current",

      -- Optional, define your own callbacks to further customize behavior.
      callbacks = {
        -- Runs at the end of `require("obsidian").setup()`.
        post_setup = function(client) end,

        -- Runs anytime you enter the buffer for a note.
        -- enter_note = function(note) end,
        enter_note = function(note)
          vim.keymap.set("n", "<localleader>d", "<cmd>Obsidian dailies 1<cr>", {
            buffer = note.bufnr,
            desc = "Show dailies",
          })

          vim.keymap.set("n", "<localleader>x", "<cmd>Obsidian toggle_checkbox<cr>", {
            buffer = note.bufnr,
            desc = "Toggle checkbox",
          })

          vim.keymap.set("n", "<localleader>l", "<cmd>Obsidian links<cr>", {
            buffer = note.bufnr,
            desc = "Search links",
          })

          vim.keymap.set("n", "<localleader>b", "<cmd>Obsidian backlinks<cr>", {
            buffer = note.bufnr,
            desc = "Search backlinks",
          })

          vim.keymap.set("n", "<localleader>i", "<cmd>Obsidian template<cr>", {
            buffer = note.bufnr,
            desc = "Insert Template",
          })

          vim.keymap.set("n", "<localleader>p", "<cmd>Obsidian paste_img<cr>", {
            buffer = note.bufnr,
            desc = "Paste clipboard image",
          })
        end,

        -- Runs anytime you leave the buffer for a note.
        leave_note = function(note) end,

        -- Runs right before writing the buffer for a note.
        pre_write_note = function(note) end,

        -- Runs anytime the workspace is set/changed.
        post_set_workspace = function(workspace) end,
      },

      -- Optional, configure additional syntax highlighting / extmarks.
      -- This requires you have `conceallevel` set to 1 or 2. See `:help conceallevel` for more details.
      ui = {
        -- Need to turn the ui off so that render-markdown can work
        enable = false, -- set to false to disable all additional syntax features
        -- ...
      },

      -- Specify how to handle attachments.
      attachments = {
        -- The default folder to place images in via `:ObsidianPasteImg`.
        img_folder = "Files/Images",

        img_name_func = function()
          return string.format("Pasted image %s", os.date("%Y%m%d%H%M%S"))
        end,
        confirm_img_paste = true,
      },

      footer = {
        enabled = true,
        format = "{{backlinks}} backlinks  {{properties}} properties  {{words}} words  {{chars}} chars",
        hl_group = "Comment",
        separator = string.rep("-", 80),
      },

      ---Order of checkbox state chars, e.g. { " ", "x" }
      checkbox = {
        -- order = { " ", "~", "!", ">", "x" },
        order = { " ", "x" },
      },

      legacy_commands = false,
    },
    keys = {
      { "<leader>od", "<cmd>Obsidian today<cr>", desc = "Todays Note " },
      { "<leader>on", "<cmd>Obsidian new<cr>", desc = "New Note" },
      { "<leader>oo", "<cmd>Obsidian quick_switch<cr>", desc = "Open Quick Switcher" },
      { "<leader>os", "<cmd>Obsidian search<cr>", desc = "Search Notes" },
      { "<leader>ot", "<cmd>Obsidian tags<cr>", desc = "Search Tags" },
    },
  },
}
