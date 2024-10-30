local latte = {
  rosewater = "#dc8a78",
  flamingo = "#dd7878",
  pink = "#ea76cb",
  mauve = "#8839ef",
  red = "#d20f39",
  maroon = "#e64553",
  peach = "#fe640b",
  yellow = "#df8e1d",
  green = "#40a02b",
  teal = "#179299",
  sky = "#04a5e5",
  sapphire = "#209fb5",
  blue = "#1e66f5",
  lavender = "#7287fd",
  text = "#4c4f69",
  subtext1 = "#5c5f77",
  subtext0 = "#6c6f85",
  overlay2 = "#7c7f93",
  overlay1 = "#8c8fa1",
  overlay0 = "#9ca0b0",
  surface2 = "#acb0be",
  surface1 = "#bcc0cc",
  surface0 = "#ccd0da",
  base = "#eff1f5",
  mantle = "#e6e9ef",
  crust = "#dce0e8",
}

-- Function to convert hex to RGB (from previous example)
local function hex_to_rgb(hex)
  hex = hex:gsub("#", "")
  local r = tonumber(hex:sub(1, 2), 16) / 255
  local g = tonumber(hex:sub(3, 4), 16) / 255
  local b = tonumber(hex:sub(5, 6), 16) / 255
  return r, g, b
end

-- Function to convert RGB to HEX
local function rgb_to_hex(r, g, b)
  return string.format("#%02X%02X%02X", math.floor(r), math.floor(g), math.floor(b))
end

-- Function to convert RGB to HSV
local function rgb_to_hsv(r, g, b)
  local max = math.max(r, g, b)
  local min = math.min(r, g, b)
  local delta = max - min

  local h, s, v

  v = max

  if max == 0 then
    s = 0
  else
    s = delta / max
  end

  if delta == 0 then
    h = 0
  elseif max == r then
    h = 60 * ((g - b) / delta % 6)
  elseif max == g then
    h = 60 * ((b - r) / delta + 2)
  else
    h = 60 * ((r - g) / delta + 4)
  end

  if h < 0 then
    h = h + 360
  end

  return h, s * 100, v * 100
end

-- Function to convert HEX to HSV
local function hex_to_hsv(hex)
  local r, g, b = hex_to_rgb(hex)
  return rgb_to_hsv(r, g, b)
end

-- Function to convert HSV to RGB
local function hsv_to_rgb(h, s, v)
  s = s / 100
  v = v / 100
  local c = v * s
  local x = c * (1 - math.abs((h / 60) % 2 - 1))
  local m = v - c
  local r, g, b

  if h < 60 then
    r, g, b = c, x, 0
  elseif h < 120 then
    r, g, b = x, c, 0
  elseif h < 180 then
    r, g, b = 0, c, x
  elseif h < 240 then
    r, g, b = 0, x, c
  elseif h < 300 then
    r, g, b = x, 0, c
  else
    r, g, b = c, 0, x
  end

  return (r + m) * 255, (g + m) * 255, (b + m) * 255
end

-- Function to convert HSV to HEX
local function hsv_to_hex(h, s, v)
  local r, g, b = hsv_to_rgb(h, s, v)
  return rgb_to_hex(r, g, b)
end

-- Function to convert HSL to RGB
local function hsl_to_rgb(h, s, l)
  s = s / 100
  l = l / 100

  local function hue_to_rgb(p, q, t)
    if t < 0 then
      t = t + 1
    end
    if t > 1 then
      t = t - 1
    end
    if t < 1 / 6 then
      return p + (q - p) * 6 * t
    end
    if t < 1 / 2 then
      return q
    end
    if t < 2 / 3 then
      return p + (q - p) * (2 / 3 - t) * 6
    end
    return p
  end

  local r, g, b

  if s == 0 then
    r, g, b = l, l, l
  else
    local q = l < 0.5 and l * (1 + s) or l + s - l * s
    local p = 2 * l - q
    r = hue_to_rgb(p, q, h / 360 + 1 / 3)
    g = hue_to_rgb(p, q, h / 360)
    b = hue_to_rgb(p, q, h / 360 - 1 / 3)
  end

  return math.floor(r * 255 + 0.5), math.floor(g * 255 + 0.5), math.floor(b * 255 + 0.5)
end

-- Function to convert Hex to HSL (from previous example)
local function hex_to_hsl(hex)
  local r, g, b = hex_to_rgb(hex)

  local max = math.max(r, g, b)
  local min = math.min(r, g, b)
  local delta = max - min

  local h, s, l

  l = (max + min) / 2

  if delta == 0 then
    s = 0
    h = 0
  else
    s = delta / (1 - math.abs(2 * l - 1))
    if max == r then
      h = 60 * ((g - b) / delta % 6)
    elseif max == g then
      h = 60 * ((b - r) / delta + 2)
    else
      h = 60 * ((r - g) / delta + 4)
    end
  end

  if h < 0 then
    h = h + 360
  end

  return math.floor(h + 0.5), math.floor(s * 100 + 0.5), math.floor(l * 100 + 0.5)
end

-- Function to convert HSL to Hex
local function hsl_to_hex(h, s, l)
  local r, g, b = hsl_to_rgb(h, s, l)
  return rgb_to_hex(r, g, b)
end

local dirtysea = {}
for name, hex in pairs(latte) do
  local h, s, l = hex_to_hsl(hex)
  s = s * 0.7
  l = l * 0.9
  dirtysea[name] = hsl_to_hex(h, s, l)
end
dirtysea["base"] = latte["base"]
dirtysea["mantle"] = latte["mantle"]
dirtysea["crust"] = latte["crust"]

local dirtysea2 = {}
local adjustment_map = {
  default = { s = 1, l = 0.65 },
  base = { s = 1, l = 0.97 },
  crust = { s = 0.5, l = 1 },
  mantle = { s = 0.5, l = 1 },
}
for name, hex in pairs(latte) do
  local h, s, l = hex_to_hsv(hex)
  local adjustment = adjustment_map[name] or adjustment_map["default"]
  s = s * adjustment["s"]
  l = l * adjustment["l"]
  dirtysea2[name] = hsv_to_hex(h, s, l)
end

return {
  {
    "rebelot/kanagawa.nvim",
    opts = {
      dimInactive = true,
      commentStyle = { italic = true },
    },
  },
  -- Configure LazyVim to load gruvbox
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
        cmp = true,
        gitsigns = true,
        nvimtree = false,
        flash = true,
        treesitter = true,
        noice = true,
        notify = false,
        nvim_surround = false,
        lsp_trouble = true,
        which_key = true,
        mini = {
          enabled = true,
          indentscope_color = "",
        },
      },
      color_overrides = {
        latte = dirtysea,
        mocha = dirtysea2,
      },
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      -- colorscheme = "kanagawa-dragon",
      colorscheme = "kanagawa-wave",
      -- colorscheme = "kanagawa-lotus",
      -- colorscheme = "catppuccin",
    },
  },
}
