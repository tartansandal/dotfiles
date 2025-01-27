return {
  {
    "saghen/blink.compat",
    -- use the latest release, via version = '*', if you also use the latest release for blink.cmp
    version = "*",
    -- lazy.nvim will automatically load the plugin when it's required by blink.cmp
    lazy = true,
    -- make sure to set opts so that lazy.nvim calls blink.compat's setup
    opts = {},
  },
  {
    "saghen/blink.cmp",
    dependencies = {
      "moyiz/blink-emoji.nvim",
      "saghen/blink.compat",
      "hrsh7th/cmp-calc",
    },

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      -- experimental signature help support
      -- signature = { enabled = true },
      completion = {
        keyword = {
          -- range = "prefix", -- match text before cursor
          range = "full", -- match text before and after cursor
        },
      },
      sources = {
        -- adding any nvim-cmp sources here will enable them
        -- with blink.compat
        compat = { "calc" },
        default = { "lsp", "path", "calc", "snippets", "buffer", "emoji" },
        cmdline = {},
        providers = {
          emoji = {
            module = "blink-emoji",
            name = "emoji",
            score_offset = 15, -- Tune by preference
          },
          buffer = {
            -- keep case of first char
            transform_items = function(a, items)
              -- Have to do the following since a.get_keyword() does not work
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
        preset = "enter",
        ["<C-y>"] = { "select_and_accept" },
        -- ["<Space>"] = { "accept", "fallback" },
        -- ["<Esc>"] = { "cancel", "fallback" },
        -- ["<Tab>"] = { "snippet_forward", "select_next", "fallback" },
        -- ["<S-Tab>"] = { "snippet_backward", "select_prev", "fallback" },
      },
    },
  },
}
