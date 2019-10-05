
-- LIBS
local State = require('src.State')
local Graphics = require('src.utils.Graphics')

---@class MenuState : State
local MenuState = State:extend()

function MenuState:new()
    MenuState.super.new(self)
end

function MenuState:init(...)
    self:createUI({
        {
            {
                type = 'Title',
                text = 'Menu',
                fontSize = 40,
                y = 0
            },
            {
                type = 'Button',
                text = 'Play',
                state = 'PlayState'
            },{
                type = 'Button',
                text = 'Score',
                state = 'ScoreState'
            }, {
                type = 'Button',
                text = 'Options',
                state = 'OptionsState'
            }, {
                type = 'Button',
                text = 'Help',
                state = 'HelpState'
            }, {
                type = 'Button',
                text = 'Credits',
                state = 'CreditsState'
            }, {
                type = 'Button',
                text = 'Quit',
                callback = function() love.event.quit() end
            }
        }, {
            {
                type = 'MultiSelector',
                text = 'Key',
                config = 'keySelect'
            }, {
                type = 'MultiSelector',
                text = 'Difficulty',
                config = 'difficulty'
            }
        }
    })
end


function MenuState:draw()
    love.graphics.setBackgroundColor(1,1,1)
    MenuState.super.draw(self)
    Graphics.drawMusicBars()
    love.graphics.setLineWidth(1)
    love.graphics.setColor(assets.config.color.black())
    love.graphics.line(assets.config.limitLine, 0, assets.config.limitLine, love.graphics.getHeight())
end

return MenuState