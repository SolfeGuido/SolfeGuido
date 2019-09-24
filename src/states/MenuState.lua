
local State = require('src.states.State')
local Button = require('src.objects.button')
local Title = require('src.objects.Title')
local Selector = require('src.objects.selector')
local ScreenManager = require('lib.ScreenManager')
local Graphics = require('src.Graphics')

---@class MenuState : State
local MenuState = State:extend()

function MenuState:new()
    MenuState.super.new(self)
    self.buttons = {}
    self.selectedButton = nil
    self.selector = self:addentity(Selector, {x = 15, y = 0})
end

function MenuState:setSelectedButton(btn)
    self.selectedButton = btn
    self.selector.y = btn.y
end

function MenuState:gotoState(statename)
    local ents = {}
    for _,v in pairs(self.entities) do
        ents[#ents+1] = v
    end
    table.sort(ents, function(a,b)
        return a.y > b.y
    end)

    local elements = {}
    for _,v in pairs(ents) do
        elements[#elements+1] = {element = v, target = {x = v.text and -v.text:getWidth() or -20, color = {0, 0, 0, 0}}}
    end
    self:transition(elements, function()
        ScreenManager.switch(statename)
    end)
end

function MenuState:init(...)
    local buttons = {
        {'Play', 'PlayState'},
        {'Score', 'ScoreState'},
        {'Credits', 'CreditsState'},
        {'Options','OptionsState'},
        {'Quit', function() love.event.quit() end}
    }

    local titleText = love.graphics.newText(assets.MarckScript(40), "Menu")

    local elements = {
        {
            element = self:addentity(Title, {
                text = titleText,
                color = {0, 0, 0, 0},
                y = 0,
                x = -titleText:getWidth()
            }),
            target = {x = 30, color = {0,0,0,1}}
        }
    }

    local btnFont = assets.MarckScript(assets.config.lineHeight)
    local middle = love.graphics.getHeight() / 3
    local btn = nil
    for _,v in pairs(buttons) do
        btn, middle = self:createButton(middle, btnFont, unpack(v))
        elements[#elements+1] = {element = btn, target = {x = 30, color = {0,0,0,1}}}
    end

    self:transition(elements, function()
        self.selector:resetAlpha()
    end)
end

function MenuState:createButton(middle, btnFont, butonText, callback)
    local cb = callback
    if type(cb) == 'string' then
        cb = function() self:gotoState(callback) end
    end
    assert(type(cb) == 'function', 'Call back must be function or string')


    local text = love.graphics.newText(btnFont, butonText)
    local btn = self:addentity(Button, {x = -text:getWidth(), y = middle, text = text, callback = cb})
    self.buttons[#self.buttons+1] = btn
    if not self.selectedButton then self:setSelectedButton(btn) end

    return btn, assets.config.lineHeight + middle
end

function MenuState:mousemoved(x,y)
    for k,v in pairs(self.buttons) do
        v:mousemoved(x,y)
    end
end

function MenuState:mousepressed(x, y, button)
    for k,v in pairs(self.buttons) do
        v:mousepressed(x, y, button)
    end
end

function MenuState:mousereleased(x, y, button)
    for k,v in pairs(self.buttons) do
        v:mousereleased(x, y, button)
    end
end

function MenuState:draw()
    MenuState.super.draw(self)
    love.graphics.setBackgroundColor(1,1,1)
    Graphics.drawMusicBars()
end

function MenuState:update(dt)
    MenuState.super.update(self, dt)
end

return MenuState