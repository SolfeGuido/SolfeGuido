local State = require('src.states.State')

---@class ScoreState : State
local ScoreState = State:extend()


function ScoreState:new()
    State.new(self)
end

function ScoreState:draw()
    State.draw(self)
end

function ScoreState:update(dt)
    State.update(self, dt)
end

return ScoreState