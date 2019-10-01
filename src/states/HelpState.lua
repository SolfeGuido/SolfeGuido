
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
            {
                text = 'Press the key corresponding to the hilighted note'
            }, {
                text = 'Each correct guess gives you a point'
            }, {
                text = 'Each wrong guess makes you loose' .. tostring(assets.config.timeLoss) .. ' seconds'
            }, {
                text = 'You can change the key to train on and the difficulty'
            }
        }
    })
end

function HelpState:draw()
    State.draw(self)
    Graphics.drawMusicBars()
end

function HelpState:update(dt)
    State.update(self, dt)
end

return HelpState