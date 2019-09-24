local Entity = require('src.entity')
local Rectangle = require('src.utils.Rectangle')

---@class MultiSelector : Entity
local MultiSelector = Entity:extend()

function MultiSelector:new(area, options)
    Entity.new(self, area, options)
    self.pressed = false
    self.currentChoice = 1
    self.selected:set(self.choices[self.currentChoice])
end

function MultiSelector:boundingBox()
    return Rectangle(self.x, self.y, love.graphics.getWidth(), self.text:getHeight() - 5)
end

function MultiSelector:draw()
    love.graphics.setColor(self.color)
    love.graphics.draw(self.text, self.x, self.y)

    local nwx = self.text:getWidth() + 10 + self.x
    love.graphics.draw(self.selected, nwx, self.y)
end

function MultiSelector:mousepressed(x, y, button)
    self.pressed = button == 1 and self:boundingBox():contains(x, y) and not self.pressed
end

function MultiSelector:mousereleased(x, y, button)
    if button == 1 and self.pressed and self:boundingBox():contains(x, y) then
        self.currentChoice = (self.currentChoice  % #self.choices) + 1
        self.selected:set(self.choices[self.currentChoice])
        --do an animation
    end
    self.pressed = false
end

function MultiSelector:update(dt)
end

return MultiSelector