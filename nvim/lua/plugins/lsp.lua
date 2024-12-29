return {
  {
    "neovim/nvim-lspconfig",
    opts = {
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
}
