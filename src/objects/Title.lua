
local Entity = require('src.entity')

local Title = Entity:extend()


function Title:new(area, options)
    Entity.new(self, area, options)
end

function Title:draw()
    love.graphics.setColor(self.color)
    love.graphics.draw(self.text, self.x, self.y)
end

return Title