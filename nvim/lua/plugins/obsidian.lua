-- Obsidian.nvim configuration for ~/Notes vault
-- Updated for v3.14+ API: frontmatter table structure, no plenary dependency
-- Sections: workspaces, daily notes, completion, frontmatter, templates, callbacks, UI, attachments
return {
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters_by_ft = {
        markdown = {}, -- disable markdown linting in obsidian vault
      },
    },
  },
  {
    "obsidian-nvim/obsidian.nvim",
    branch = "main",
    lazy = true,
    -- Only load for markdown files in ~/Notes vault
    event = {
      "BufReadPre " .. vim.fn.expand("~") .. "/Notes/**.md",
      "BufNewFile " .. vim.fn.expand("~") .. "/Notes/**.md",
    },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      workspaces = {
        {
          name = "Notes",
          path = "~/Notes",
        },
      },
      notes_subdir = "Cards",
      log_level = vim.log.levels.INFO,

      -- Default template applied by `:Obsidian new` when creating a card.
      -- Keeps new notes from starting as blank files — they arrive with the
      -- frontmatter scaffold (aliases, tags, created) so Zettelkasten discipline
      -- is enforced at creation time rather than retrofitted.
      note = {
        template = "card.md",
      },

      daily_notes = {
        folder = "Daily",
        date_format = "%Y/%V/%Y-%m-%d",
        alias_format = "%a %-d %B %Y",
        template = "daily.md",
        workdays_only = false,
      },
      completion = {
        nvim_cmp = false,
        blink = true,
        min_chars = 2,
        create_new = true,
      },
      new_notes_location = "notes_subdir",

      -- Generate note IDs: timestamp-slugified-title
      note_id_func = function(title)
        local suffix = ""
        if title ~= nil then
          suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
        else
          for _ = 1, 4 do
            suffix = suffix .. string.char(math.random(65, 90))
          end
        end
        return tostring(os.date("%Y%m%d%H%M%S")) .. "-" .. suffix
      end,

      note_path_func = function(spec)
        return (spec.dir / tostring(spec.id)):with_suffix(".md")
      end,
      -- Link creation: always emit the pipe-aliased form `[[id|Label]]` when a
      -- label is available. Neither obsidian.nvim's UI nor render-markdown.nvim
      -- resolves frontmatter aliases at display time — whatever text is in the
      -- link is what renders. The pipe form keeps bare timestamp IDs out of the
      -- visible display. Vault convention is documented in ~/Notes/CLAUDE.md.
      link = {
        style = "wiki",
        wiki = function(opts)
          if opts.label ~= opts.path then
            return string.format("[[%s|%s]]", opts.path, opts.label)
          else
            return string.format("[[%s]]", opts.path)
          end
        end,
      },
      frontmatter = {
        enabled = true,
        -- Strip `id` from frontmatter. The builtin func injects it by default,
        -- but it's redundant: obsidian.nvim falls back to the filename stem
        -- when no frontmatter id exists, and wikilinks already target the stem.
        -- Path prefixes (e.g. [[Dragon/Learnings]]) handle filename collisions.
        func = function(note)
          local fm = require("obsidian.builtin").frontmatter(note)
          fm.id = nil
          return fm
        end,
        sort = { "aliases", "tags", "created" },
      },
      templates = {
        folder = "Templates",
        date_format = "%Y-%m-%d",
        time_format = "%H:%M",
        substitutions = {
          week = function()
            return tostring(os.date("%V"))
          end,
          day = function()
            return tostring(os.date("%A"))
          end,
        },
      },
      open = {
        use_advanced_uri = false,
        func = vim.ui.open,
      },

      picker = {
        name = "snacks.pick",
        notemappings = {
          new = "<C-x>",
          insert_link = "<C-l>",
        },
        tag_mappings = {
          tag_note = "<C-x>",
          insert_tag = "<C-l>",
        },
      },
      backlinks = {
        parse_headers = true,
      },
      search = {
        sort_by = "modified",
        sort_reversed = true,
        max_lines = 1000,
      },
      open_notes_in = "current",
      callbacks = {
        post_setup = function(client) end,
        -- Set up buffer-local keymaps for obsidian notes
        enter_note = function(note)
          vim.keymap.set("n", "<localleader>d", "<cmd>Obsidian dailies 1<cr>", {
            buffer = note.bufnr,
            desc = "Show dailies",
          })

          vim.keymap.set("n", "<localleader>x", function()
            local saved = Obsidian.opts.checkbox.create_new
            Obsidian.opts.checkbox.create_new = true
            pcall(function()
              vim.cmd("Obsidian toggle_checkbox")
            end)
            Obsidian.opts.checkbox.create_new = saved
          end, {
            buffer = note.bufnr,
            desc = "Toggle / create checkbox",
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

          vim.keymap.set("v", "<localleader>e", ":<C-u>Obsidian extract_note<cr>", {
            buffer = note.bufnr,
            desc = "Extract selection to new note",
          })
        end,
        leave_note = function(note) end,
        pre_write_note = function(note) end,
        post_set_workspace = function(workspace) end,
      },
      ui = {
        enable = false, -- disabled to allow render-markdown to work
      },
      attachments = {
        folder = "Files",
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
      checkbox = {
        -- Keep smart_action's <CR> from inserting checkboxes on plain lines.
        -- <localleader>x below flips this on temporarily to force creation.
        create_new = false,
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
