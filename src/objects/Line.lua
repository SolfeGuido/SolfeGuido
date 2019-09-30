local Entity = require('src.entity')

---@class Line : Entity
local Line = Entity:extend()

function Line:new(area, options)
    Entity.new(self, area, options)
end

function Line:draw()
    love.graphics.setColor(self.color)
    love.graphics.setLineWidth(self.lineWidth or 1)
    love.graphics.line(self.x, self.y, self.x + (self.width or 0), self.y + (self.height or 0))
end

return Line