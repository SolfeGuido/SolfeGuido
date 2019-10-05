
local Entity = require('src.Entity')


local Selector = Entity:extend()

function Selector:new(area, options)
    Entity.new(self, area, options)
    self.image = assets.images.whole
    self.color = {0, 0, 0, 0}
    self.scale = (assets.config.lineHeight / 2) / self.image:getHeight()
end

function Selector:createAlpha()
    -- avoid memory leak with the timer
    if not self.isDisposed then
        self.area.timer:tween(0.5, self, {color = {0, 0, 0, 0.1}}, 'linear', function() self:resetAlpha() end)
    end
end

function Selector:resetAlpha()
    if not self.isDisposed then
        self.area.timer:tween(0.5, self, {color = {0, 0, 0, 1}}, 'linear', function() self:createAlpha() end)
    end
end

function Selector:draw()
    if self.visible then
        love.graphics.setColor(self.color)
        love.graphics.draw(self.image, self.x, self.y + assets.config.lineHeight / 3, 0, self.scale, self.scale)
    end
end


return Selector