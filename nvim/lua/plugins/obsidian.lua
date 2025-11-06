-- Obsidian.nvim configuration for ~/Notes vault
-- Sections: workspaces, daily notes, completion, templates, callbacks, UI, attachments
-- Also disables markdown linting to avoid conflicts
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
    version = "*",
    lazy = true,
    -- Only load for markdown files in ~/Notes vault
    event = {
      "BufReadPre " .. vim.fn.expand("~") .. "/Notes/**.md",
      "BufNewFile " .. vim.fn.expand("~") .. "/Notes/**.md",
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
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

      daily_notes = {
        folder = "Daily",
        date_format = "%Y/%V/%Y-%m-%d",
        alias_format = "%a %-d %B %Y",
        template = "daily_unwell.md",
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
      wiki_link_func = "use_alias_only",
      markdown_link_func = function(opts)
        return require("obsidian.util").markdown_link(opts)
      end,
      preferred_link_style = "wiki",
      disable_frontmatter = false,
      note_frontmatter_func = function(note)
        if note.title then
          note:add_alias(note.title)
        end
        local out = { id = note.id, aliases = note.aliases, tags = note.tags }
        if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
          for k, v in pairs(note.metadata) do
            out[k] = v
          end
        end
        return out
      end,
      templates = {
        folder = "Templates",
        date_format = "%Y-%m-%d",
        time_format = "%H:%M",
        substitutions = {
          week = function()
            return tostring(os.date("%V"))
          end,
        },
      },
      follow_url_func = function(url)
        vim.ui.open(url, { cmd = { "xdg-open" } })
      end,
      follow_img_func = function(img)
        vim.ui.open(img, { cmd = { "xdg-open" } })
      end,
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
      sort_by = "modified",
      sort_reversed = true,
      search_max_lines = 1000,
      open_notes_in = "current",
      callbacks = {
        post_setup = function(client) end,
        -- Set up buffer-local keymaps for obsidian notes
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
        leave_note = function(note) end,
        pre_write_note = function(note) end,
        post_set_workspace = function(workspace) end,
      },
      ui = {
        enable = false, -- disabled to allow render-markdown to work
      },
      attachments = {
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
      checkbox = {
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
