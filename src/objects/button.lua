
local Entity = require('src.entity')
local Rectangle = require('src.utils.Rectangle')

---@class Button
local Button = Entity:extend()

function Button:new(area, id, config)
    Entity.new(self, area, id, config)
    self.color = {0,0,0,0}
    self.selected = false
end

function Button:mousemoved(x,y)
    local boundingBox = Rectangle(self.x, self.y, love.graphics.getWidth(), self.text:getHeight() - 5)
    if boundingBox:contains(x, y) then
        if not self.selected then
            self.area:setSelectedButton(self)
            self.selected = true
        end
    else
        self.selected = false
    end
end

function Button:draw()
    love.graphics.setColor(unpack(self.color))
    love.graphics.draw(self.text, self.x + 5, self.y)
end

function Button:update(dt)

end




return Button