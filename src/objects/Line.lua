local Entity = require('src.entity')

---@class Line : Entity
local Line = Entity:extend()

function Line:new(area,id, options)
    Entity.new(self, area, id, options)
end

function Line:draw()
    love.graphics.setColor(self.color)
    love.graphics.setLineWidth(self.lineWidth)
    love.graphics.line(self.x, self.y, self.x + (self.width or 0), self.y + (self.height or 0))
end

return Line