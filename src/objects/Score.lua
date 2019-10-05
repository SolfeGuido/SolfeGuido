local Entity = require('src.Entity')

---@class Score : Entity
local Score = Entity:extend()

function Score:new(area, options)
    Entity.new(self, area, options)
end

function Score:draw()
    love.graphics.setColor(self.color)
    love.graphics.draw(self.text, self.x, self.y)
end

function Score:gainPoint()
    self.points = self.points + 1
    self.text:set(tostring(self.points))
    --maybe some animation ?
end

return Score