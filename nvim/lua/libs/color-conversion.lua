-- Module variable
local M = {}

-- Function to convert RGB to HEX
function M.rgb_to_hex(r, g, b)
  local hex =
    string.format("#%02X%02X%02X", math.floor(r), math.floor(g), math.floor(b))
  return string.lower(hex)
end

-- Function to convert HEX to RGB
function M.hex_to_rgb(hex)
  hex = hex:gsub("#", "")
  local r = tonumber(hex:sub(1, 2), 16) / 255
  local g = tonumber(hex:sub(3, 4), 16) / 255
  local b = tonumber(hex:sub(5, 6), 16) / 255
  return r, g, b
end

-- Function to convert RGB to HSV
function M.rgb_to_hsv(r, g, b)
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

-- Function to convert HSV to RGB
function M.hsv_to_rgb(h, s, v)
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

-- Function to convert RGB to HSL
function M.rgb_to_hsl(r, g, b)
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

-- Function to convert HSL to RGB
function M.hsl_to_rgb(h, s, l)
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

-- Function to convert HSV to HEX
function M.hsv_to_hex(h, s, v)
  local r, g, b = M.hsv_to_rgb(h, s, v)
  return M.rgb_to_hex(r, g, b)
end
--
-- Function to convert HEX to HSV
function M.hex_to_hsv(hex)
  local r, g, b = M.hex_to_rgb(hex)
  return M.rgb_to_hsv(r, g, b)
end

-- Function to convert HEX to HSL
function M.hex_to_hsl(hex)
  local r, g, b = M.hex_to_rgb(hex)
  return M.rgb_to_hsl(r, g, b)
end

-- Function to convert HSL to HEX
function M.hsl_to_hex(h, s, l)
  local r, g, b = M.hsl_to_rgb(h, s, l)
  return M.rgb_to_hex(r, g, b)
end

return M
