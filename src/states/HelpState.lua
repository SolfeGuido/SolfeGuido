
-- LIBS
local State = require('src.State')
local ScreeManager = require('lib.ScreenManager')
local EventTransmitter = require('src.utils.EventTransmitter')

---@class HelpState : State
local HelpState = State:extend()
HelpState:implement(EventTransmitter)


function HelpState:new()
    State.new(self)
end

function HelpState:init()
    self:createUI({
        {},{
            { text = 'help_1' },
            { text = 'help_2' },
            { text = 'help_3' },
            { text = 'help_4' }
        }
    })
end

function HelpState:receive(eventName, callback)
    if eventName == "pop" then
        self:slideEntitiesOut(function()
            ScreeManager.pop()
            if callback and type(callback) == "function" then callback() end
        end)    end
end

function HelpState:draw()
    -- Use scrollbar or somthing for mobile
    love.graphics.setScissor(assets.config.limitLine ,assets.config.baseLine, love.graphics.getWidth(), assets.config.baseLine + assets.config.lineHeight * 5)
    State.draw(self)
    love.graphics.setScissor()
end

return HelpState