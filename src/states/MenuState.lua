
-- LIBS
local State = require('src.State')
local Graphics = require('src.utils.Graphics')
local Color = require('src.utils.Color')

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
                fontSize = assets.config.titleSize,
                y = 0,
                main = true,
                from = "top"
            },
            {
                type = 'TextButton',
                text = 'Play',
                state = 'PlayState'
            }, {
                type = 'TextButton',
                text = 'Score',
                state = 'ScoreState'
            },{
                type = 'TextButton',
                text = 'Help',
                state = 'HelpState'
            }, {
                type = 'TextButton',
                text = 'Credits',
                state = 'CreditsState'
            }, {
                type = 'IconButton',
                image = 'gear',
                y = 0,
                x = love.graphics.getWidth() - assets.config.titleSize,
                statePush = 'OptionsState',
                from = "right"
            }, {
                type = 'IconButton',
                image = 'exit',
                x = 0,
                y = love.graphics.getHeight() - assets.config.titleSize,
                callback = function() love.event.quit() end
            }
        }
    })
end


function MenuState:draw()
    love.graphics.setBackgroundColor(1,1,1)
    MenuState.super.draw(self)
    Graphics.drawMusicBars()
    love.graphics.setLineWidth(1)
    love.graphics.setColor(Color.black)
end

return MenuState