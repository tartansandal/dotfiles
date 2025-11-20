-- Configure blink.cmp for completion (replaces nvim-cmp)
-- Key customizations: manual selection, case-preserving buffer completion, copilot integration
return {
  {
    "saghen/blink.compat",
    version = "*",
    lazy = true,
    opts = {},
  },
  {
    -- disable the default installed by extras
    "giuxtaposition/blink-cmp-copilot",
    enabled = false,
  },
  {
    "saghen/blink.cmp",
    dependencies = {
      "moyiz/blink-emoji.nvim",
      "saghen/blink.compat",
      "hrsh7th/cmp-calc",
      -- TEMPORARY: Copilot disabled - uncomment to re-enable
      -- "fang2hou/blink-copilot",
    },
    version = "1.*",
    -- build = "cargo build --release",
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      fuzzy = {
        implementation = "prefer_rust_with_warning",
        -- implementation = "lua",

        -- ** Uncomment the following if precompiled extension fails **
        -- prebuilt_binaries = { download = false },
      },
      completion = {
        keyword = {
          -- range = "prefix", -- match text before cursor
          range = "full", -- match text before and after cursor
        },
        documentation = {
          window = {
            border = "rounded",
            winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:BlinkCmpDocCursorLine,Search:None",
          },
        },
        menu = {
          border = "rounded",
          draw = { gap = 2 },
          winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:BlinkCmpMenuSelection,Search:None",
        },
        accept = {
          auto_brackets = {
            enabled = false, -- disable experimental auto-brackets
          },
        },
        list = {
          selection = { preselect = false, auto_insert = false }, -- manual selection only
        },
      },
      signature = {
        enabled = false, -- disabled: interferes with default LSP signature help
        window = {
          border = "rounded",
          winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:BlinkCmpMenuSelection,Search:None",
        },
      },
      sources = {
        compat = { "calc" }, -- enable nvim-cmp calc source via blink.compat
        default = function()
          if vim.bo.filetype == "markdown" then
            return { "lsp", "path", "calc", "snippets", "buffer", "emoji" }
          else
            -- TEMPORARY: Copilot disabled - add "copilot" back to re-enable
            return { "lsp", "path", "snippets", "buffer" }
          end
        end,
        providers = {
          -- TEMPORARY: Copilot provider disabled
          -- copilot = {
          --   name = "copilot",
          --   module = "blink-copilot",
          --   score_offset = 100,
          --   async = true,
          --   opts = {
          --     max_completions = 3,
          --     max_attempts = 2,
          --   },
          -- },
          emoji = {
            module = "blink-emoji",
            name = "emoji",
            score_offset = 15, -- Tune by preference
          },
          buffer = {
            -- Transform buffer completions to match case of first typed character
            transform_items = function(a, items)
              local keyword = a.get_keyword()

              local correct, case
              if keyword:match("^%l") then
                correct = "^%u%l+$"
                case = string.lower
              elseif keyword:match("^%u") then
                correct = "^%l+$"
                case = string.upper
              else
                return items
              end

              -- avoid duplicates from the corrections
              local seen = {}
              local out = {}
              for _, item in ipairs(items) do
                local raw = item.insertText
                if raw and raw:match(correct) then
                  local text = case(raw:sub(1, 1)) .. raw:sub(2)
                  item.insertText = text
                  item.label = text
                end
                if not seen[item.insertText] then
                  seen[item.insertText] = true
                  table.insert(out, item)
                end
              end
              return out
            end,
          },
        },
      },
      keymap = {
        -- preset = "default",
        preset = "enter",
        -- preset = "super-tab",
        ["<C-y>"] = { "select_and_accept" },
        ["<Esc>"] = { "cancel", "fallback" },
        -- ["<Space>"] = { "accept", "fallback" },
        ["<Tab>"] = { "snippet_forward", "select_next", "fallback" },
        ["<S-Tab>"] = { "snippet_backward", "select_prev", "fallback" },
      },
    },
  },
}
