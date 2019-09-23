local State = require('src.states.State')

---@class EndGameState : State
local EndGameState = State:extend()


function EndGameState:new()
    State.new(self)
end

function EndGameState:draw()
    State.draw(self)
end

function EndGameState:update(dt)
    State.update(self, dt)
end

return EndGameState