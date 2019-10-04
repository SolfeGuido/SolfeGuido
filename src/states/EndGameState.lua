
-- LIBS
local State = require('src.states.State')


---@class EndGameState : State
local EndGameState = State:extend()


function EndGameState:new()
    State.new(self)
end

function EndGameState:init(score)
    self.color = {1, 1, 1, 0}
    self.timer:tween(0.2, self, {color = {1, 1, 1, 0.8}}, 'linear', function() self:addButtons(score) end)
end

function EndGameState:addButtons(score)
    self:createUI({
        {
            {
                text = 'Finished',
                fontSize = 40,
                y = 0
            }, {
                text = 'Score : ' .. tostring(score)
            }, {
                type = 'Button',
                text = 'Restart',
                state = 'PlayState'
            }, {
                type = 'Button',
                text = 'Score',
                state = 'ScoreState'
            }, {
                type = 'Button',
                text = 'Menu',
                state = 'MenuState'
            }
        }
    })
end

function EndGameState:draw()
    love.graphics.setColor(self.color)
    love.graphics.rectangle('fill', 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

    State.draw(self)
end

return EndGameState