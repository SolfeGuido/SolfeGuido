local Entity = require('src.Entity')

---@class Score : Entity
local Score = Entity:extend()

function Score:new(container, options)
    Entity.new(self, container, options)
end

function Score:dispose()
    self.text:release()
    Score.super.dispose(self)
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