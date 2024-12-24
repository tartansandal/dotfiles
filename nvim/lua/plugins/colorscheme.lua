local latte = require("catppuccin.palettes").get_palette("latte")
local frappe = require("catppuccin.palettes").get_palette("frappe")
local macchiato = require("catppuccin.palettes").get_palette("macchiato")
local mocha = require("catppuccin.palettes").get_palette("mocha")

local CC = require("libs.color-conversion")

local function transform_palette_hsl(palette, map)
  local new = {}
  for name, hex in pairs(palette) do
    local h, s, l = CC.hex_to_hsl(hex)
    local adjustment = map[name] or map["default"]
    h = h * (adjustment["h"] or 1)
    s = s * (adjustment["s"] or 1)
    l = l * (adjustment["l"] or 1)
    new[name] = CC.hsl_to_hex(h, s, l)
  end
  return new
end

local latte2 = transform_palette_hsl(latte, {
  default = { s = 0.65, l = 0.96 },
})

local frappe2 = transform_palette_hsl(frappe, {
  default = { s = 0.6, l = 0.9 },
})

local macchiato2 = transform_palette_hsl(macchiato, {
  default = { s = 0.6, l = 0.9 },
})

local mocha2 = transform_palette_hsl(mocha, {
  default = { s = 0.6, l = 0.9 },
})

return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    opts = {
      flavour = "mocha",
      dim_inactive = {
        enabled = true, -- dims the background color of inactive window
        shade = "light",
        percentage = 0.15, -- percentage of the shade to apply to the inactive window
      },
      integrations = {
        leap = false,
      },
      color_overrides = {
        latte = latte2,
        frappe = frappe2,
        macchiato = macchiato2,
        mocha = mocha2,
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
