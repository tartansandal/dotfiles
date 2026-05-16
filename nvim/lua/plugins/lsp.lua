-- LSP configuration: rounded borders, pyright type checking
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
        marksman = {
          -- Disable for Obsidian vault — obsidian.nvim handles links, completion,
          -- and navigation. Marksman's missing-doc warnings create noise.
          root_dir = function(bufnr, on_dir)
            local fname = vim.api.nvim_buf_get_name(bufnr)
            if fname:find(vim.fn.expand("~/Notes"), 1, true) then
              return -- don't attach for Obsidian vault
            end
            local root = require("lspconfig.util").root_pattern(".marksman.toml")(fname)
            on_dir(root or vim.fs.dirname(fname))
          end,
        },
        pyright = {},
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
