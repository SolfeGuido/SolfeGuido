
local Entity = require('src.entity')

local Title = Entity:extend()


function Title:new(area, id, options)
    Entity.new(self, area, id, options)
end

function Title:draw()
    love.graphics.setColor(unpack(self.color))
    love.graphics.draw(self.text, self.x, self.y)
end

return Title