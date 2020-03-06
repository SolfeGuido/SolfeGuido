
local Config = require('src.data.Config')

--- All the mobile related stuff
---@class Mobile
---@field configure function
---@field load function
---@field isMobile boolean
local Mobile = {}

--- No operation function
local noop = function() end

--- Mobile specific methods
--- If on mobile, theses methods will be called, otherwise, the "noop" method is called
local methods = {
    load = function() love.window.setFullscreen(true, 'exclusive') end,
    vibrate = function(...) if Config.vibrations == 'on' then love.system.vibrate(...) end end
}

--- Called on start, to setup all the function for mobile
local os = love.system.getOS()
Mobile.isMobile = os == "Android" or os == "iOS"
for name, method in pairs(methods) do Mobile[name] = (Mobile.isMobile and method or noop) end


return Mobile