local latte = require("catppuccin.palettes").get_palette("latte")
local frappe = require("catppuccin.palettes").get_palette("frappe")
local macchiato = require("catppuccin.palettes").get_palette("macchiato")
local mocha = require("catppuccin.palettes").get_palette("mocha")

local C = require("catppuccin.utils.colors")

local function transform_palette_hsl(palette, amount)
  local new = {}
  for name, hex in pairs(palette) do
    new[name] = C.darken(hex, amount, "#000000")
  end
  return new
end

local latte_decaf = transform_palette_hsl(latte, 0.90)
local frappe_decaf = transform_palette_hsl(frappe, 0.84)
local macchiato_decaf = transform_palette_hsl(macchiato, 0.85)
local mocha_decaf = transform_palette_hsl(mocha, 0.87)

return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    opts = {
      flavour = "mocha",
      no_italic = false, -- Force no italic
      no_bold = true, -- Force no bold
      no_underline = false, -- Force no underline
      dim_inactive = {
        enabled = true, -- dims the background color of inactive window
        -- shade = "light",
        shade = "dark",
        percentage = 0.15, -- percentage of the shade to apply to the inactive window
      },
      integrations = {
        aerial = false, -- true,
        alpha = false, -- true,
        cmp = false, -- true,
        blink_cmp = true, -- new
        dashboard = true,
        flash = true,
        fzf = true,
        grug_far = true,
        gitsigns = true,
        headlines = true,
        illuminate = true,
        indent_blankline = { enabled = true },
        leap = false, -- true,
        lsp_trouble = true,
        mason = true,
        markdown = true,
        mini = true,
        native_lsp = {
          enabled = true,
          underlines = {
            errors = { "undercurl" },
            hints = { "undercurl" },
            warnings = { "undercurl" },
            information = { "undercurl" },
          },
        },
        navic = { enabled = true, custom_bg = "lualine" },
        neotest = true,
        neotree = false, -- true,
        noice = true,
        notify = true,
        semantic_tokens = true,
        snacks = true,
        telescope = false, -- true,
        treesitter = true,
        treesitter_context = true,
        which_key = true,
      },
      color_overrides = {
        latte = latte_decaf,
        frappe = frappe_decaf,
        macchiato = macchiato_decaf,
        mocha = mocha_decaf,
      },
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
}
