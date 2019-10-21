local State = require('src.State')
local EventTransmitter = require('src.utils.EventTransmitter')
local ScreeManager = require('lib.ScreenManager')

---@class CreditsState : State
local CreditsState = State:extend()
CreditsState:implement(EventTransmitter)

function CreditsState:new()
    State.new(self)
end

function CreditsState:init()
    self:createUI({
        {}, {
            {text = 'created_by_azarias'},
            {text = 'with_love2d'},
            {text = 'and_many_libs'}
        }
    })
end

function CreditsState:receive(eventName, callback)
    if eventName == "pop" then
        self:slideEntitiesOut(function()
            ScreeManager.pop()
            if callback and type(callback) == "function" then callback() end
        end)
    end
end

function CreditsState:draw()
    love.graphics.setScissor(assets.config.limitLine ,assets.config.baseLine, love.graphics.getWidth(), assets.config.baseLine + assets.config.lineHeight * 5)
    State.draw(self)
    love.graphics.setScissor()
end

return CreditsState