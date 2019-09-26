local State = require('src.states.State')

---@class EndGameState : State
local EndGameState = State:extend()


function EndGameState:new()
    State.new(self)
end

function EndGameState:init(score)
    print("Score is", score)
    self.color = {1, 1, 1, 0}
    self.timer:tween(0.2, self, {color = {1, 1, 1, 0.8}}, 'linear', function() self:addButtons() end)
end

function EndGameState:addButtons()

end

function EndGameState:draw()
    love.graphics.setColor(self.color)
    love.graphics.rectangle('fill', 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

    State.draw(self)
end

function EndGameState:update(dt)
    State.update(self, dt)
end

function EndGameState:popBack()
    --Smooth transition to menu ?
end

function EndGameState:restart()

end

return EndGameState