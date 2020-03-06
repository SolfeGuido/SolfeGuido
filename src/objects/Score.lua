local Entity = require('src.Entity')

--- Used to keep track of a game's score,
--- and add some animations when the user wins/looses
--- points
---@class Score : Entity
---@field text any
local Score = Entity:extend()

--- Constructor
---@param container EntityContainer
---@param options table
function Score:new(container, options)
    Entity.new(self, container, options)
end

--- Inherited method
function Score:dispose()
    self.text:release()
    Score.super.dispose(self)
end

--- Inherited method
function Score:draw()
    love.graphics.setColor(self.color)
    love.graphics.draw(self.text, self.x, self.y)
end

--- Whenever the users gains a point
--- Could use some animations
function Score:gainPoint()
    self.points = self.points + 1
    self.text:set(tostring(self.points))
    --maybe some animation ?
end

return Score