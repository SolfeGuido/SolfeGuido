local State = require('src.states.State')

---@class OptionsState : State
local OptionsState = State:extend()


function OptionsState:new()
    State.new(self)
end

function OptionsState:draw()
    State.draw(self)
end

function OptionsState:update(dt)
    State.update(self, dt)
end

return OptionsState