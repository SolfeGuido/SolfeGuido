
local State = require('src.states.State')

---@class PauseState : State
local PauseState = State:extend()


function PauseState:new()
    State.new(self)
end

function PauseState:draw()
end

function PauseState:update(dt)
end

return PauseState