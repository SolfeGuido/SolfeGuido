
-- LIBS
local State = require('src.states.State')
local Graphics = require('src.Graphics')


---@class HelpState : State
local HelpState = State:extend()


function HelpState:new()
    State.new(self)
end

function HelpState:init()
    self:createUI({
        {
            {
                text = 'Help',
                fontSize = 40,
                y = 0
            },
            {
                type = 'Button',
                text = 'Back',
                state = 'MenuState'
            }
        },{
            { text = 'help_1' },
            { text = 'help_2' },
            { text = 'help_3' },
            { text = 'help_4' }
        }
    })
end

function HelpState:draw()
    State.draw(self)
    Graphics.drawMusicBars()
end

function HelpState:back()
    self:switchState('MenuState')
end

return HelpState