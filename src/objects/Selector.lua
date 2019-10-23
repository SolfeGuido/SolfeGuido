
local Entity = require('src.Entity')


local Selector = Entity:extend()

function Selector:new(area, options)
    Entity.new(self, area, options)
    self.image = assets.images.whole
    self.color = {0, 0, 0, 1}
    self.scale = (assets.config.lineHeight / 2) / self.image:getHeight()
end


function Selector:draw()
    if self.visible then
        love.graphics.setColor(self.color)
    else
        love.graphics.setColor(0, 0, 0, 0.3)
    end
    love.graphics.draw(self.image, self.x, self.y + assets.config.lineHeight / 3, 0, self.scale, self.scale)
end


return Selector