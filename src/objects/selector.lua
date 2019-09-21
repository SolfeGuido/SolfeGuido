
local Entity = require('src.entity')


local Selector = Entity:extend()

function Selector:new(area, id, options)
    Entity.new(self, area, id, options)
    self.image = assets.images.whole
    self.alpha = 1
    self.scale = (assets.config.lineHeight / 2) / self.image:getHeight()
    self:createAlpha()
end

function Selector:createAlpha()
    self.area.timer:tween(0.5, self, {alpha = 0.1}, 'linear', function() self:resetAlpha() end)
end

function Selector:resetAlpha()
    self.area.timer:tween(0.5, self, {alpha = 1}, 'linear', function() self:createAlpha() end)
end

function Selector:draw()
    if not self.visible then return end
    love.graphics.setColor(0, 0, 0, self.alpha)
    love.graphics.draw(self.image, self.x, self.y + assets.config.lineHeight / 3, 0, self.scale, self.scale)
end


return Selector