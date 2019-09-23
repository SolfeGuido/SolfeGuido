
local Entity = require('src.entity')
local Rectangle = require('src.utils.Rectangle')

---@class Button
local Button = Entity:extend()

function Button:new(area, id, config)
    Entity.new(self, area, id, config)
    self.color = {0,0,0,0}
    self.selected = false
    self.pressed = false
end

function Button:boundingBox()
    return Rectangle(self.x, self.y, love.graphics.getWidth(), self.text:getHeight() - 5)
end

function Button:mousemoved(x,y)
    if self:boundingBox():contains(x, y) then
        if not self.selected then
            self.area:setSelectedButton(self)
            self.selected = true
        end
    else
        self.selected = false
    end
end

function Button:mousepressed(x, y, button)
    if button == 1 and self:boundingBox():contains(x, y) then
        self.pressed = true
    end
end


function Button:mousereleased(x, y, button)
    if button == 1 and self.pressed and self:boundingBox():contains(x, y) then
        if self.callback then self.callback() end
    end
    self.pressed = false
end

function Button:draw()
    love.graphics.setColor(self.color)
    love.graphics.draw(self.text, self.x + 5, self.y)
end

function Button:update(dt)

end




return Button