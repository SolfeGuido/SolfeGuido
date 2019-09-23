
local State = require('src.states.State')
local ScreenManager = require('lib.ScreenManager')

---@class PauseState : State
local PauseState = State:extend()


function PauseState:new()
    State.new(self)
end

function PauseState:draw()
    State.draw(self)
    love.graphics.setColor(1, 1, 1, 0.8)
    love.graphics.rectangle('fill', 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

    -- transition the 'resume', and 'exit buttons'
end

function PauseState:update(dt)
    State.update(self, dt)
end

function PauseState:keypressed(key)
    if key == "escape" then
        ScreenManager.pop()
    end
end


return PauseState