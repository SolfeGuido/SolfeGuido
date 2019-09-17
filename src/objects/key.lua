
local Entity = require('src.entity')

local Key = Entity:extend()


function Key:new(area, id, config)
    Entity.new(self, area, id)
    self.config = config
    self.image = assets.images[self.config.image]
end

function Key:draw()
    local imgHeigh = self.image:getHeight()
    local scale = self.config.height / imgHeigh
    local base = self.area:getBaseLine()
    love.graphics.draw(self.image, self.xPosition, base - self.yPosition, 0 , scale , scale, self.xOrigin, self.yOrigin)
end

return Key