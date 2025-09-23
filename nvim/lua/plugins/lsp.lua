return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      diagnostics = {
        float = {
          border = "rounded",
        },
      },
      servers = {
        pyright = {
          settings = {
            python = {
              analysis = {
                -- FIXME: do we need this anymore?
                typeCheckingMode = "on",
              },
            },
          },
        },
      },
    },
  },
  {
    "folke/noice.nvim",
    opts = function(_, opts)
      opts.lsp.signature = {
        auto_open = { enabled = false },
      }
      opts.presets = {
        lsp_doc_border = true,
      }
    end,
  },
  {
    "mason-org/mason.nvim",
    opts = {
      ui = {
        border = "rounded",
      },
    },
  },
}
