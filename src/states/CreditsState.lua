local State = require('src.states.State')
local Graphics = require('src.Graphics')

---@class CreditsState : State
local CreditsState = State:extend()


function CreditsState:new()
    State.new(self)
end

function CreditsState:init()
    self:createUI({
        {
            {
                text = 'Credits',
                fontSize = 40,
                y = 0
            }, {
                type = 'Button',
                text = 'Back',
                state = 'MenuState'
            }
        }, {
            {text = 'Created by Azarias'},
            {text = 'With Löve2D'},
            {text = 'And many libs'}
        }
    })
end

function CreditsState:draw()
    State.draw(self)
    Graphics.drawMusicBars()
end

function CreditsState:update(dt)
    State.update(self, dt)
end

return CreditsState