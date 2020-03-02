local Entity = require('src.Entity')
local Theme = require('src.utils.Theme')

---@class Line : Entity
--- Really simple class to be able to
--- animate the different lines of the game
--- used do draw the measures
local Line = Entity:extend()

--- Constructor
---@param container EntityContainer
---@param options table
function Line:new(container, options)
    Entity.new(self, container, options)
    self.color = options.color or Theme.font:clone()
end

--- Inherited method
function Line:draw()
    love.graphics.setColor(self.color)
    love.graphics.setLineWidth(self.lineWidth or 1)
    love.graphics.line(self.x, self.y, self.x + (self.width or 0), self.y + (self.height or 0))
end

return Line