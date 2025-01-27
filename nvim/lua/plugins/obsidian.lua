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
    "epwalsh/obsidian.nvim",

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
      -- Optional, set the log level for obsidian.nvim. This is an integer corresponding
      -- to one of the log levels defined by "vim.log.levels.*".
      log_level = vim.log.levels.INFO,

      workspaces = {
        {
          name = "Notes",
          path = "~/Notes",
        },
      },
      -- This is where *new* notes go
      notes_subdir = "Cards",

      templates = {
        folder = "~/Notes/Templates",
        date_format = "%Y-%m-%d",
        time_format = "%H:%M",
        -- A map for custom variables, the key should be the variable and the value
        -- a function
        substitutions = {
          week = function()
            return tostring(os.date("%W"))
          end,
        },
      },

      daily_notes = {
        -- Optional, if you keep daily notes in a separate directory.
        folder = "Daily",
        -- Optional, if you want to change the date format for the ID of daily notes.
        date_format = "%Y/%W/%Y-%m-%d",
        -- Optional, if you want to change the date format of the default alias of daily notes.
        alias_format = "%B %-d, %Y",
        -- Optional, if you want to automatically insert a template from your template directory like 'daily.md'
        template = "daily.md",
      },

      -- Where to put new notes created from completion. Valid options are
      --  * "current_dir" - put new notes in same directory as the current buffer.
      --  * "notes_subdir" - put new notes in the default notes subdirectory.
      new_notes_location = "notes_subdir",

      -- Optional, completion of wiki links, local markdown links, and tags using nvim-cmp.
      completion = {
        -- Set to false to disable completion.
        nvim_cmp = false,

        -- Trigger completion at 2 chars.
        min_chars = 2,
      },

      -- Optional, configure key mappings. These are the defaults. If you don't want to set any keymappings this
      -- way then set 'mappings = {}'.
      mappings = {
        ["<localleader>l"] = {
          action = "<cmd>ObsidianLinks<cr>",
          opts = {
            noremap = false,
            buffer = true,
            desc = "Search links",
          },
        },
        ["<localleader>b"] = {
          action = "<cmd>ObsidianBacklinks<cr>",
          opts = {
            noremap = false,
            buffer = true,
            desc = "Search backlinks",
          },
        },
        ["<localleader>i"] = {
          action = "<cmd>ObsidianTemplate<cr>",
          opts = {
            noremap = false,
            buffer = true,
            desc = "Insert Template",
          },
        },
        ["<localleader>o"] = {
          action = "<cmd>ObsidianOpen<cr>",
          opts = {
            noremap = false,
            buffer = true,
            desc = "Open in Obsidian",
          },
        },
        ["<localleader>p"] = {
          action = "<cmd>ObsidianPasteImg<cr>",
          opts = {
            noremap = false,
            buffer = true,
            desc = "Paste clipboard image",
          },
        },
        -- Toggle check-boxes.
        ["<localleader>x"] = {
          action = function()
            return require("obsidian").util.toggle_checkbox()
          end,
          desc = "Toggle checkbox",
          opts = { noremap = false, buffer = true },
        },

        -- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
        ["gf"] = {
          desc = "Open file or markdown/wiki link",
          action = function()
            return require("obsidian").util.gf_passthrough()
          end,
          opts = { noremap = false, expr = true, buffer = true },
        },
      },

      -- Optional, customize how names/IDs for new notes are created.
      note_id_func = function(title)
        -- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
        -- In this case a note with the title 'My new note' will be given an ID that looks
        -- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
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
      --  * "use_alias_only", e.g. '[[Foo Bar]]'
      --  * "prepend_note_id", e.g. '[[foo-bar|Foo Bar]]'
      --  * "prepend_note_path", e.g. '[[foo-bar.md|Foo Bar]]'
      --  * "use_path_only", e.g. '[[foo-bar.md]]'
      -- Or you can set it to a function that takes a table of options and returns a string, like this:
      -- wiki_link_func = function(opts)
      --   return require("obsidian.util").wiki_link_id_prefix(opts)
      -- end,
      wiki_link_func = "use_alias_only",

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

      -- Optional, by default when you use `:ObsidianFollowLink` on a link to an external
      -- URL it will be ignored but you can customize this behavior here.
      follow_url_func = function(url)
        -- Open the URL in the default web browser.
        vim.fn.jobstart({ "xdg-open", url }) -- linux
      end,

      -- Optional, by default when you use `:ObsidianFollowLink` on a link to an image
      -- file it will be ignored but you can customize this behavior here.
      ---@param img string
      follow_img_func = function(img)
        vim.fn.jobstart({ "xdg-open", img })
      end,

      -- Optional, set to true if you use the Obsidian Advanced URI plugin.
      -- https://github.com/Vinzent03/obsidian-advanced-uri
      use_advanced_uri = true,

      -- Optional, set to true to force ':ObsidianOpen' to bring the app to the foreground.
      open_app_foreground = true,

      picker = {
        -- Set your preferred picker. Can be one of 'telescope.nvim', 'fzf-lua', or 'mini.pick'.
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

      -- Optional, sort search results by "path", "modified", "accessed", or "created".
      -- The recommend value is "modified" and `true` for `sort_reversed`, which means, for example,
      -- that `:ObsidianQuickSwitch` will show the notes sorted by latest modified time
      sort_by = "modified",
      sort_reversed = true,

      -- Optional, determines how certain commands open notes. The valid options are:
      -- 1. "current" (the default) - to always open in the current window
      -- 2. "vsplit" - to open in a vertical split if there's not already a vertical split
      -- 3. "hsplit" - to open in a horizontal split if there's not already a horizontal split
      open_notes_in = "current",

      -- Optional, configure additional syntax highlighting / extmarks.
      ui = {
        -- Need to turn the ui off so that render-markdown can work
        enable = false, -- set to false to disable all additional syntax features
      },

      -- Specify how to handle attachments.
      attachments = {
        -- The default folder to place images in via `:ObsidianPasteImg`.
        -- If this is a relative path it will be interpreted as relative to the vault root.
        -- You can always override this per image by passing a full path to the command instead of just a filename.
        img_folder = "Files/Images", -- This is the default

        -- Optional, customize the default name or prefix when pasting images via `:ObsidianPasteImg`.
        ---@return string
        img_name_func = function()
          -- Prefix image names with timestamp.
          return string.format("%s-", os.time())
        end,

        -- A function that determines the text to insert in the note when pasting an image.
        -- It takes two arguments, the `obsidian.Client` and an `obsidian.Path` to the image file.
        -- This is the default implementation.
        ---@param client obsidian.Client
        ---@param path obsidian.Path the absolute path to the image file
        ---@return string
        img_text_func = function(client, path)
          path = client:vault_relative_path(path) or path
          return string.format("![%s](%s)", path.name, path)
        end,
      },
    },
    keys = {
      { "<leader>od", "<cmd>ObsidianToday<cr>", desc = "Todays Note " },
      { "<leader>on", "<cmd>ObsidianNew<cr>", desc = "New Note" },
      { "<leader>oo", "<cmd>ObsidianQuickSwitch<cr>", desc = "Open Quick Switcher" },
      { "<leader>os", "<cmd>ObsidianSearch<cr>", desc = "Search Notes" },
      { "<leader>ot", "<cmd>ObsidianTags<cr>", desc = "Search Tags" },
    },
  },
}
