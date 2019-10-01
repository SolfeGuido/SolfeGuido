
local State = require('src.states.State')
local ScreenManager = require('lib.ScreenManager')

-- Entities
local Title = require('src.objects.Title')
local Button = require('src.objects.button')

---@class PauseState : State
local PauseState = State:extend()


function PauseState:new()
    State.new(self)
end

function PauseState:init(...)
    self.color = {1, 1, 1, 0}
    self.timer:tween(0.2, self, {color = {1, 1, 1, 0.8}}, 'linear', function()
        self:addButtons()
    end)
end

function PauseState:addButtons()
    self:createUI({
        {
            {
                text = 'Pause',
                fontSize = 40,
                y = 0
            },{
                type = 'Button',
                text = 'Resume',
                callback = function() self:popBack() end
            }, {
                type = 'Button',
                text = 'Exit',
                state = 'MenuState'
            }
        }
    })
end

function PauseState:draw()
    love.graphics.setColor(self.color)
    love.graphics.rectangle('fill', 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    State.draw(self)
end

function PauseState:update(dt)
    State.update(self, dt)
end

function PauseState:popBack()
    self:slideEntitiesOut()
    self.timer:tween(assets.config.transition.tween, self, {color = {1, 1, 1, 0}}, 'linear', function()
        ScreenManager.pop()
    end)
end

function PauseState:keypressed(key)
    if key == "escape" then
        self:popBack()
    end
end


return PauseState