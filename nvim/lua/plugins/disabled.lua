-- Disable LazyVim default plugins that we don't use
return {
  {
    "akinsho/bufferline.nvim",
    enabled = false, -- prefer no buffer line
  },
  {
    "nvim-mini/mini.indentscope",
    enabled = false, -- using snacks.indent instead
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    enabled = false, -- using snacks.indent instead
  },
  {
    "RRethy/vim-illuminate",
    enabled = false, -- don't want word highlighting
  },
  {
    "folke/tokyonight.nvim",
    enabled = false, -- using catppuccin
  },
  {
    "nvim-pack/nvim-spectre",
    enabled = false, -- not used
  },
}
