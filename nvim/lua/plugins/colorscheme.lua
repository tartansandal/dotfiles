-- Catppuccin colorscheme with custom "decaf" darkened color overrides

local function decaffeinate(palette, weight)
  local C = require("catppuccin.utils.colors")
  local new = {}
  for name, hex in pairs(palette) do
    new[name] = C.darken(hex, weight, "#000000")
  end
  return new
end

-- Make a buffer with Ptyxis palette definition suitable to add to
-- ~/.local/share/org.gnome.Ptyxis/palettes/
local function make_term_palette(palette, name)
  local termcolors = {
    Background = palette["base"],
    Foreground = palette["text"],
    Cursor = palette["text"],
    Color0 = palette["surface1"],
    Color1 = palette["red"],
    Color2 = palette["green"],
    Color3 = palette["yellow"],
    Color4 = palette["blue"],
    Color5 = palette["pink"],
    Color6 = palette["teal"],
    Color7 = palette["subtext1"],
    Color8 = palette["surface2"],
    Color9 = palette["red"],
    Color10 = palette["green"],
    Color11 = palette["yellow"],
    Color12 = palette["blue"],
    Color13 = palette["pink"],
    Color14 = palette["teal"],
    Color15 = palette["subtext"],
  }
  local result = { "[Palette]", "Name=" .. name }
  for key, value in pairs(termcolors) do
    table.insert(result, key .. "=" .. value)
  end
  vim.cmd("new")
  vim.api.nvim_buf_set_lines(0, 0, -1, false, result)
end

-- Usage:
--   local P = require("catppuccin.palettes")
--   local C = require("catppuccin.utils.colors")
--   C.make_term_palette(P.get_palette("latte"), "Catppuccin Latte Decaf")
--   C.make_term_palette(P.get_palette("frappe"), "Catppuccin Frappe Decaf")
--   C.make_term_palette(P.get_palette("macchiato"), "Catppuccin Macchiato Decaf")
--   C.make_term_palette(P.get_palette("mocha"), "Catppuccin Mocha Decaf")

-- mocha_decaf reference values:
-- {
--   base = "#1A1A28",   blue = "#779DDA",    crust = "#0F0F17",
--   flamingo = "#D3B2B2", green = "#90C58C",  lavender = "#9DA5DD",
--   mantle = "#151520",  maroon = "#CC8B96",  mauve = "#B190D7",
--   overlay0 = "#5E6175", overlay1 = "#6E7388", overlay2 = "#80859B",
--   peach = "#DA9C75",   pink = "#D5A9C9",    red = "#D37992",
--   rosewater = "#D5C3BF", sapphire = "#65ADCD", sky = "#77BFCC",
--   subtext0 = "#9097AE", subtext1 = "#A2A9C1",
--   surface0 = "#2B2C3B", surface1 = "#3C3E4E", surface2 = "#4D4F61",
--   teal = "#81C5B9",    text = "#B2BAD4",    yellow = "#D9C598",
-- }

return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = function()
      local P = require("catppuccin.palettes")
      local C = require("catppuccin.utils.colors")

      C.make_term_palette = make_term_palette

      return {
        flavour = "mocha",
        dim_inactive = {
          enabled = true,
          shade = "dark",
          percentage = 0.25,
        },
        integrations = {
          aerial = false,
          alpha = false,
          cmp = false,
          blink_cmp = true,
          dashboard = true,
          flash = true,
          fzf = true,
          grug_far = true,
          gitsigns = true,
          headlines = true,
          illuminate = true,
          indent_blankline = { enabled = true },
          leap = false,
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
          neotree = true,
          noice = true,
          notify = true,
          semantic_tokens = true,
          snacks = true,
          telescope = false,
          treesitter = true,
          treesitter_context = true,
          which_key = true,
          window_picker = true,
        },
        color_overrides = {
          latte = decaffeinate(P.get_palette("latte"), 0.87),
          frappe = decaffeinate(P.get_palette("frappe"), 0.84),
          macchiato = decaffeinate(P.get_palette("macchiato"), 0.85),
          mocha = decaffeinate(P.get_palette("mocha"), 0.87),
        },
      }
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin-nvim",
    },
  },
}
