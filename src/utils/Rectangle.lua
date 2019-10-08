
local Class = require('lib.class')

local Rectangle = Class:extend()


function Rectangle:new(x,y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
end

function Rectangle:contains(x, y)
    return self.x <= x and (self.x + self.width) >= x and
            self.y <= y and (self.y + self.height) >= y
end


--- BEGIN DEBUG
function Rectangle:debugDraw()
    love.graphics.setColor(0.8, 0, 0, 0.3)
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end
--- END DEBUG

return Rectangle