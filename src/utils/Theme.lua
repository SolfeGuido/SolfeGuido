
local Color = require('src.utils.Color')

---@class Theme
---@field font Color public
---@field background Color public
---@field primary Color public
---@field secondary Color public
---@field transparent Color public
---@field hovered Color public
---@field clicked Color public
---@field wrong Color public
local Theme = {}

local ThemeColors = {
    light = {
        font = {68,68,68},
        background = {245,245,245},
        hovered = {225,225,225},
        clicked = {205,205,205},
        primary = {0,115,229},
        secondary = {125,220,31},
        transparent = {68,68,68,0},
        wrong = {179,40,77},
        correct = {125,220,31},
        stripe = {151,155,194, 74}
    },
    dark = {
        font = {238,238,238},
        background = {34,40,49},
        hovered = {44,50,59},
        clicked = {54,60,69},
        primary = {0,173,181},
        secondary = {57,62,70},
        transparent = {238,238,238, 0},
        wrong = {168,17,0},
        correct = {72, 158, 115},
        stripe = {57,62,70}
    }
}

local currentTheme = nil


function Theme.init(theme)
    Theme.updateTheme(theme or 'dark')
end


function Theme.updateTheme(nwTheme)
    if nwTheme == currentTheme or not ThemeColors[nwTheme] then return end
    for k,v in pairs(ThemeColors[nwTheme]) do
        Theme[k] = Color.fromBytes(unpack(v))
    end
    currentTheme = nwTheme
end

Theme.updateTheme('light')

return Theme