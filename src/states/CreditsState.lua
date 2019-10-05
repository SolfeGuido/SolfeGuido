local State = require('src.State')
local Graphics = require('src.utils.Graphics')

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
            {text = 'created_by_azarias'},
            {text = 'with_love2d'},
            {text = 'and_many_libs'}
        }
    })
end

function CreditsState:draw()
    State.draw(self)
    Graphics.drawMusicBars()
end

function CreditsState:back()
    self:switchState('MenuState')
end

return CreditsState