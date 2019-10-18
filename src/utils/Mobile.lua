
local Config = require('src.utils.Config')

---@class Mobile
---@field configure function
---@field load function
---@field isMobile boolean
local Mobile = {}

local noop = function() end

--- Mobile specific methods
--- If on mobile, theses methods will be called, otherwise, the "noop" method is called
local methods = {
    configure = function() Config.update('answerType', 'buttons') end,
    load = function() love.window.setFullscreen(true, 'exclusive') end,
    vibrate = function(...) if Config.vibrations == 'on' then love.system.vibrate(...) end end
}

local os = love.system.getOS()
Mobile.isMobile = os == "Android" or os == "iOS"
for name, method in pairs(methods) do Mobile[name] = (Mobile.isMobile and method or noop) end


function Mobile.canBeAdded(option)
    return option == "all" or
            (option == "mobile" and Mobile.isMobile) or
            (option == "desktop" and not Mobile.isMobile)
end

return Mobile