
local Config = require('src.utils.Config')

---@class Mobile
---@field configure function
---@field load function
---@field isMobile boolean
local Mobile = {}

local noop = function() end

local methods = {
    configure = function() Config.update('answerType', 'buttons') end,
    load = function() love.window.setFullscreen(true, 'exclusive') end
}

local os = love.system.getOS()
Mobile.isMobile = os == "Android" or os == "iOS"
for name, method in pairs(methods) do Mobile[name] = (Mobile.isMobile and method or noop) end


return Mobile