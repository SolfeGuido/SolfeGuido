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

function CreditsState:draw()
    love.graphics.setScissor(assets.config.limitLine ,assets.config.baseLine, love.graphics.getWidth(), assets.config.baseLine + assets.config.lineHeight * 5)
    State.draw(self)

    love.graphics.setScissor()
end

function CreditsState:back()
    ScreeManager.pop()
end

return CreditsState