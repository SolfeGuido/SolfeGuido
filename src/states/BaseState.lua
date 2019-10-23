local State = require('src.State')
local ScreeManager = require('lib.ScreenManager')
local EventTransmitter = require('src.utils.EventTransmitter')


---@class BaseState : State
local BaseState = State:extend()
BaseState:implement(EventTransmitter)

function BaseState:new()
    State.new(self)
end

function BaseState:draw()
    love.graphics.setScissor(assets.config.limitLine ,assets.config.baseLine, love.graphics.getWidth(), assets.config.baseLine + assets.config.lineHeight * 5)
    State.draw(self)
    love.graphics.setScissor()
end

function BaseState:receive(eventName, callback)
    if eventName == "pop" then
        self:slideEntitiesOut(function()
            ScreeManager.pop()
            if callback and type(callback) == "function" then callback() end
        end)
    end
end

return BaseState