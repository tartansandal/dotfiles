return {
  -- surround
  -- comment
  -- ai

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyright = {
          settings = {
            python = {
              analysis = {
                -- Does not work and may be an anti-pattern
                -- End up having to set this in config file
                -- typeCheckingMode = "off",
                typeCheckingMode = "on",
              },
            },
          },
        },
      },
    },
  },

  {
    "tpope/vim-rhubarb",
    lazy = true,
    dependencies = { "tpope/vim-fugitive" },
    keys = {
      { "<leader>gB", "<cmd>GBrowse<cr>", desc = "Browse in GitHub" },
    },
  },

  { "echasnovski/mini.pairs" },

  {
    "lukas-reineke/indent-blankline.nvim",
    -- Need neovim 0.10 for newer versions
    -- version = "3.5.4",
  },

  { "Olical/vim-enmasse", lazy = true },

  {
    "KabbAmine/zeavim.vim",
    version = "*", -- recommended, use latest release instead of latest commit
    event = "LazyFile",
    keys = {
      { "<leader>cz", "<cmd>Zeavim<cr>", desc = "Zeal lookup" },
    },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = { ensure_installed = { "sql" } },
  },

  {
    "SmiteshP/nvim-navic",
    lazy = true,
    init = function()
      vim.g.navic_silence = true
      LazyVim.lsp.on_attach(function(client, buffer)
        if client.supports_method("textDocument/documentSymbol") then
          require("nvim-navic").attach(client, buffer)
        end
      end)
    end,
    opts = function()
      return {
        separator = " ",
        highlight = true,
        depth_limit = 5,
        icons = require("lazyvim.config").icons.kinds,
        lazy_update_context = true,
      }
    end,
  },

  {
    "nvim-lualine/lualine.nvim",
    optional = true,
    opts = function(_, opts)
      if not vim.g.trouble_lualine then
        table.insert(opts.sections.lualine_c, {
          function()
            return require("nvim-navic").get_location()
          end,
          cond = function()
            return package.loaded["nvim-navic"] and require("nvim-navic").is_available()
          end,
        })
      end
    end,
  },
  {
    "folke/flash.nvim",
    keys = {
      { "s", mode = { "n", "o", "x" }, false },
      { "S", mode = { "n", "o", "x" }, false },
      { "r", mode = "o", false },
      { "R", mode = { "o", "x" }, false },
      { "<c-s>", mode = { "c" }, false },
      {
        "f",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump()
        end,
        desc = "Flash",
      },
      {
        "F",
        mode = { "n", "x", "o" },
        function()
          require("flash").treesitter()
        end,
        desc = "Flash Treesitter",
      },
    },
    opts = {
      modes = {
        char = {
          search = { wrap = true },
          jump_labels = true,
        },
      },
    },
  },
  {
    "echasnovski/mini.surround",
    recommended = true,
    opts = {
      mappings = {
        add = "sa", -- Add surrounding in Normal and Visual modes
        delete = "sd", -- Delete surrounding
        find = "sf", -- Find surrounding (to the right)
        find_left = "sF", -- Find surrounding (to the left)
        highlight = "sh", -- Highlight surrounding
        replace = "sr", -- Replace surrounding
        update_n_lines = "sn", -- Update `n_lines`
      },
    },
  },
}
