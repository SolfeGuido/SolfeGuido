
-- LIBS
local State = require('src.states.State')
local Graphics = require('src.Graphics')
local Config = require('src.Config')

-- ENTITES
local Button = require('src.objects.button')
local Title = require('src.objects.Title')
local MultiSelector = require('src.objects.MultiSelector')

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

function MenuState:createButton(middle, btnFont, butonText, callback)
    local cb = callback
    if type(cb) == 'string' then
        cb = function() self:switchState(callback) end
    end
    assert(type(cb) == 'function', 'Call back must be function or string')


    local text = love.graphics.newText(btnFont, butonText)
    local btn = self:addentity(Button, {x = -text:getWidth(), y = middle, text = text, callback = cb})
    return btn, assets.config.lineHeight + middle
end


function MenuState:draw()
    love.graphics.setBackgroundColor(1,1,1)
    MenuState.super.draw(self)
    Graphics.drawMusicBars()
    love.graphics.setLineWidth(1)
    love.graphics.setColor(assets.config.color.black())
    love.graphics.line(assets.config.limitLine, 0, assets.config.limitLine, love.graphics.getHeight())
end

function MenuState:update(dt)
    MenuState.super.update(self, dt)
end

return MenuState