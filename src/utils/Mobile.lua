
local Config = require('src.utils.Config')

local Mobile = {}

function Mobile.load()
    local os = love.system.getOS()
    Mobile.isMobile = os == "Android" or os == "iOS"
    if Mobile.isMobile then love.window.setFullscreen(true, "exclusive") end
end

function Mobile.configure()
    if Mobile.isMobile then Config.update('answerType', 'buttons') end
end

return Mobile