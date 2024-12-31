local P = require("catppuccin.palettes")

local latte = P.get_palette("latte")
local frappe = P.get_palette("frappe")
local macchiato = P.get_palette("macchiato")
local mocha = P.get_palette("mocha")

local C = require("catppuccin.utils.colors")

local function decaffeinate(palette, weight)
  local new = {}
  for name, hex in pairs(palette) do
    new[name] = C.darken(hex, weight, "#000000")
  end
  return new
end

local latte_decaf = decaffeinate(latte, 0.90)
local frappe_decaf = decaffeinate(frappe, 0.84)
local macchiato_decaf = decaffeinate(macchiato, 0.85)
local mocha_decaf = decaffeinate(mocha, 0.87)

-- Make a buffer with Ptyxis pallete definition suitable to add to
-- ~/.local/share/org.gnome.Ptyxis/palettes/
local function make_term_palette(pallete, name)
  local termcolors = {
    Background = pallete["base"],
    Foreground = pallete["text"],
    Cursor = pallete["text"],
    Color0 = pallete["surface1"],
    Color1 = pallete["red"],
    Color2 = pallete["green"],
    Color3 = pallete["yellow"],
    Color4 = pallete["blue"],
    Color5 = pallete["pink"],
    Color6 = pallete["teal"],
    Color7 = pallete["subtext1"],
    Color8 = pallete["surface2"],
    Color9 = pallete["red"],
    Color10 = pallete["green"],
    Color11 = pallete["yellow"],
    Color12 = pallete["blue"],
    Color13 = pallete["pink"],
    Color14 = pallete["teal"],
    Color15 = pallete["subtext"],
  }
  local result = { "[Palette]", "Name=" .. name }
  for key, value in pairs(termcolors) do
    table.insert(result, key .. "=" .. value)
  end
  -- Create a new buffer and insert the result
  vim.cmd("new") -- Open a new empty buffer
  vim.api.nvim_buf_set_lines(0, 0, -1, false, result) -- Insert the result into the new buffer
end

C.make_term_palette = make_term_palette

-- local P = require("catppuccin.palettes")
-- local C = require("catppuccin.utils.colors")
--
-- local latte = P.get_palette("latte")
-- local frappe = P.get_palette("frappe")
-- local macchiato = P.get_palette("macchiato")
-- local mocha = P.get_palette("mocha")
--
-- C.make_term_palette(latte, "Catppuccin Latte Decaf")
-- C.make_term_palette(frappe, "Catppuccin Frappe Decaf")
-- C.make_term_palette(macchiato, "Catppuccin Macchiato Decaf")
-- C.make_term_palette(mocha, "Catppuccin Moca Decaf")

-- mocha_decaf = {
--   base = "#1A1A28",
--   blue = "#779DDA",
--   crust = "#0F0F17",
--   flamingo = "#D3B2B2",
--   green = "#90C58C",
--   lavender = "#9DA5DD",
--   mantle = "#151520",
--   maroon = "#CC8B96",
--   mauve = "#B190D7",
--   overlay0 = "#5E6175",
--   overlay1 = "#6E7388",
--   overlay2 = "#80859B",
--   peach = "#DA9C75",
--   pink = "#D5A9C9",
--   red = "#D37992",
--   rosewater = "#D5C3BF",
--   sapphire = "#65ADCD",
--   sky = "#77BFCC",
--   subtext0 = "#9097AE",
--   subtext1 = "#A2A9C1",
--   surface0 = "#2B2C3B",
--   surface1 = "#3C3E4E",
--   surface2 = "#4D4F61",
--   teal = "#81C5B9",
--   text = "#B2BAD4",
--   yellow = "#D9C598"
-- }

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
