
local State = require('src.states.State')
local Button = require('src.objects.button')
local Selector = require('src.objects.selector')

---@class MenuState : State
local MenuState = State:extend()

function MenuState:new()
    MenuState.super.new(self)
    self.title = love.graphics.newText(assets.MarckScript(40), "Menu")
    self.xTitle = -self.title:getWidth()
    self.titleColor = {0,0,0,0}
    self.buttons = {}
    self.selectedButton = nil
    self.selector = self:addentity(Selector, {x = 15, y = 0, visible = false})
end

function MenuState:setSelectedButton(btn)
    self.selectedButton = btn
    self.selector.y = btn.y
end

function MenuState:init(...)
    local buttons = {
        {'Play', 'PlayState'},
        {'Score', 'ScoreState'},
        {'Credits', 'CreditsState'},
        {'Options','OptionsState'},
        {'Quit', function() love.event.quit() end}
    }

    local btnFont = assets.MarckScript(assets.config.lineHeight)
    local middle = love.graphics.getHeight() / 3

    self.timer:after(1, function()
        self.timer:tween(1, self, {xTitle = 30, titleColor = {0,0,0, 1}}, 'out-expo')
        local size = #buttons
        self.timer:every(0.1, function()
            local data = buttons[1]
            table.remove(buttons, 1)
            local text = love.graphics.newText(btnFont, data[1])
            local btn = self:addentity(Button, {x = -text:getWidth(), y = middle, text = text})
            self.buttons[#self.buttons+1] = btn
            if not self.selectedButton then self:setSelectedButton(btn) end

            middle = middle + assets.config.lineHeight
            self.timer:tween(1, btn, {x = 30, color = {0, 0, 0, 1}}, 'out-expo', function() self.selector.visible = true end)
        end, size)
    end)
end

function MenuState:mousemoved(x,y)
    for k,v in pairs(self.buttons) do
        v:mousemoved(x,y)
    end
end

function MenuState:draw()
    MenuState.super.draw(self)
    love.graphics.setBackgroundColor(1,1,1)

    local middle = love.graphics.getHeight() / 3

    love.graphics.setLineWidth(1)
    love.graphics.setColor(0, 0, 0, 1)
    for i = 1,5 do
        local ypos = middle + assets.config.lineHeight * i
        love.graphics.line(0, ypos, love.graphics.getWidth(), ypos)
    end

    love.graphics.setColor(unpack(self.titleColor))
    love.graphics.draw(self.title, self.xTitle, 0)
end

function MenuState:update(dt)
    MenuState.super.update(self, dt)
end

return MenuState