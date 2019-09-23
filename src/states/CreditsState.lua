local State = require('src.states.State')

---@class CreditsState : State
local CreditsState = State:extend()


function CreditsState:new()
    State.new(self)
end

function CreditsState:draw()
    State.draw(self)
end

function CreditsState:update(dt)
    State.update(self, dt)
end

return CreditsState