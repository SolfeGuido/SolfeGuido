
local State = require('src.states.State')
local Button = require('src.objects.button')
local Title = require('src.objects.Title')
local Graphics = require('src.Graphics')

---@class MenuState : State
local MenuState = State:extend()

function MenuState:new()
    MenuState.super.new(self)
end

function MenuState:init(...)
    local buttons = {
        {'Play', 'PlayState'},
        {'Score', 'ScoreState'},
        {'Options','OptionsState'},
        {'Help', 'HelpState'},
        {'Credits', 'CreditsState'},
        {'Quit', function() love.event.quit() end}
    }

    local titleText = love.graphics.newText(assets.MarckScript(40), "Menu")

    local elements = {
        {
            element = self:addentity(Title, {
                text = titleText,
                color = assets.config.color.transparent(),
                y = 0,
                x = -titleText:getWidth()
            }),
            target = {x = 30, color = assets.config.color.black()}
        }
    }

    local btnFont = assets.MarckScript(assets.config.lineHeight)
    local middle = love.graphics.getHeight() / 3
    local btn = nil
    for _,v in pairs(buttons) do
        btn, middle = self:createButton(middle, btnFont, unpack(v))
        elements[#elements+1] = {element = btn, target = {x = 30, color = assets.config.color.black()}}
    end

    self:transition(elements)
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
end

function MenuState:update(dt)
    MenuState.super.update(self, dt)
end

return MenuState