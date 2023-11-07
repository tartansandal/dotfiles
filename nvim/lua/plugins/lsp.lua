return {
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
                typeCheckingMode = "off",
              },
            },
          },
        },
      },
    },
  },
}
