return {
  {
    "L3MON4D3/LuaSnip",
    keys = function()
      return {}
    end,
  },

  -- {
  --   "octaltree/cmp-look",
  --   keyword_length = 3,
  --   lazy = true,
  --   option = {
  --     convert_case = true,
  --     loud = true,
  --     dict = "/home/kal/dotfiles/10k-sorted.txt",
  --   },
  -- },

  -- {
  --   "hrsh7th/cmp-buffer",
  --   enabled = false,
  -- },

  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-emoji",
      "hrsh7th/cmp-calc",
      -- "octaltree/cmp-look",
      "nvim-tree/nvim-web-devicons",
      --      "onsails/lspkind.nvim",
    },

    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      -- load up cmp plugins
      table.insert(opts.sources, { name = "emoji" })
      table.insert(opts.sources, { name = "calc" })
      -- table.insert(opts.sources, { name = "look" })

      -- remove the buffer source
      -- local index = nil
      -- for i, v in ipairs(opts.sources) do
      --   if v.name == "buffer" then
      --     index = i
      --   end
      -- end
      -- if index ~= nil then
      --   table.remove(opts.sources, index)
      -- end

      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0
          and vim.api
              .nvim_buf_get_lines(0, line - 1, line, true)[1]
              :sub(col, col)
              :match("%s")
            == nil
      end

      local luasnip = require("luasnip")
      local cmp = require("cmp")

      -- opts.window = {
      --   completion = cmp.config.window.bordered(),
      --   documentation = cmp.config.window.bordered(),
      -- }

      -- turn off ghost_text
      opts.experimental.ghost_text = false

      -- this seems to slow things down too much
      -- opts.formatting.format = function(entry, vim_item)
      --   if vim.tbl_contains({ "path" }, entry.source.name) then
      --     local icon, hl_group =
      --       require("nvim-web-devicons").get_icon(entry:get_completion_item().label)
      --     if icon then
      --       vim_item.kind = icon
      --       vim_item.kind_hl_group = hl_group
      --       return vim_item
      --     end
      --   end
      --   return require("lspkind").cmp_format({ with_text = false })(entry, vim_item)
      -- end

      -- need force disabling PreselectMode
      opts.completion.completeopt = "menu,menuone,noinsert,noselect"
      opts.preselect = cmp.PreselectMode.None

      -- Suppertab-like mapping
      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            -- You could replace select_next_item() with confirm({ select = true }) to get VS Code autocompletion behavior
            cmp.select_next_item()
          -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
          -- this way you will only jump inside the snippet region
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<CR>"] = cmp.mapping({
          -- In INSERT mode only use a completion if explicitly selected
          i = function(fallback)
            if cmp.visible() and cmp.get_active_entry() then
              cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
            else
              fallback()
            end
          end,
          s = cmp.mapping.confirm({ select = true }),
          c = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          }),
        }),
      })
    end,
  },
}
