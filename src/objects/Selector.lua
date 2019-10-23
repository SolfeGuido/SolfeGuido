
local Entity = require('src.Entity')


local Selector = Entity:extend()

function Selector:new(area, options)
    Entity.new(self, area, options)
    self.color = {0, 0, 0, 1}
    if options.image then
        self.image = options.image
        self.scale = assets.config.lineHeight / self.image:getHeight()
        self.addY = 2
    else
        self.image = assets.images.whole
        self.scale = (assets.config.lineHeight / 2) / self.image:getHeight()
        self.addY = assets.config.lineHeight / 3
    end
end


function Selector:draw()
    if self.visible then
        love.graphics.setColor(self.color)
    else
        love.graphics.setColor(0, 0, 0, 0.3)
    end
    love.graphics.draw(self.image, self.x, self.y + self.addY, 0, self.scale, self.scale)
end


return Selector