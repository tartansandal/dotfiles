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

  { "tpope/vim-rhubarb", dependencies = { "tpope/vim-fugitive" } },

  { "echasnovski/mini.pairs" },

  {
    -- Need neovim 0.10 for newer versions
    "lukas-reineke/indent-blankline.nvim",
    version = "3.5.4",
  },

  { "Olical/vim-enmasse" },
  {
    "KabbAmine/zeavim.vim",
    version = "*", -- recommended, use latest release instead of latest commit
    lazy = true,
    ft = { "python" },
    keys = {
      { "<leader>z", "<cmd>Zeavim<cr>", desc = "Zeal lookup" },
    },
  },
}
