local Entity = require('src.entity')
local Rectangle = require('src.utils.Rectangle')

---@class MultiSelector : Entity
local MultiSelector = Entity:extend()

local function indexOf(table, element)
    for i,v in ipairs(table) do
        if v == element then return i end
    end
    return nil
end

function MultiSelector:new(area, options)
    Entity.new(self, area, options)
    self.pressed = false
    self.currentChoice = indexOf(self.choices, self.selected) or 1
    self.selectedText = love.graphics.newText(self.text:getFont(), self.selected)
end

function MultiSelector:boundingBox()
    return Rectangle(self.x, self.y, love.graphics.getWidth(), self.text:getHeight() - 5)
end

function MultiSelector:draw()
    love.graphics.setColor(self.color)
    love.graphics.draw(self.text, self.x, self.y)

    local nwx = self.text:getWidth() + 10 + self.x
    love.graphics.draw(self.selectedText, nwx, self.y)
end

function MultiSelector:mousepressed(x, y, button)
    self.pressed = button == 1 and self:boundingBox():contains(x, y) and not self.pressed
end

function MultiSelector:mousereleased(x, y, button)
    if button == 1 and self.pressed and self:boundingBox():contains(x, y) then
        self.currentChoice = (self.currentChoice  % #self.choices) + 1
        self.selectedText:set(self.choices[self.currentChoice])
        if self.callback then self.callback(self.choices[self.currentChoice]) end
    end
    self.pressed = false
end

function MultiSelector:update(dt)
end

return MultiSelector