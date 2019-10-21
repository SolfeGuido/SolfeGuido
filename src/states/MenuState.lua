
-- LIBS
local State = require('src.State')
local ScreeManager = require('lib.ScreenManager')
local EventTransmitter= require('src.utils.EventTransmitter')

---@class MenuState : State
local MenuState = State:extend()
MenuState:implement(EventTransmitter)

function MenuState:new()
    MenuState.super.new(self)
end

function MenuState:init(...)
    self:createUI({
        {},{
            {
                type = 'TextButton',
                text = 'Timed',
                state = 'PlayState'
            },
            {
                type = 'TextButton',
                text = 'Zen',
                state = 'ScoreState'
            },
            {
                type = 'TextButton',
                text = 'Interval earing',
                state = 'ScoreState'
            }
        }
    })
end


function MenuState:receive(eventName, callback)
    if eventName == "pop" then
        self:slideEntitiesOut(function()
            ScreeManager.pop()
            if callback and type(callback) == "function" then callback() end
        end)
    end
end

function MenuState:draw()
    love.graphics.setScissor(assets.config.limitLine ,assets.config.baseLine, love.graphics.getWidth(), assets.config.baseLine + assets.config.lineHeight * 5)
    State.draw(self)
    love.graphics.setScissor()
end
return MenuState