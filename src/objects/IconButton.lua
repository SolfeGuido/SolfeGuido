

-- LIBS
local Color = require('src.utils.Color')
local Rectangle = require('src.utils.Rectangle')

-- Entities
local AbstractButton = require('src.objects.AbstractButton')

---@class IconButton : AbstractButton
local IconButton = AbstractButton:extend()

function IconButton:new(area, config)
    AbstractButton.new(self, area, config)
    self.color = config.color or Color.black:clone()
    local scale = 1
    if config.height then
        scale = config.height / self.image:getHeight()
    elseif config.width then
        scale = config.width / self.image:getWidth()
    end
    self._width = self.image:getWidth() * scale
    self.height = self.image:getHeight() * scale
    self.scale = scale
end

function IconButton:width()
    return self._width
end

function IconButton:dispose()
    IconButton.super.dispose(self)
end

function IconButton:boundingBox()
    return Rectangle(self.x, self.y, self._width, self.height)
end

function IconButton:hovered()
    self:animate(assets.config.transition.tween, self, {color = Color.gray(0.7)}, 'out-expo')
end

function IconButton:pressed()
    self:animate(assets.config.transition.tween, self, {color = Color.gray(0.5)}, 'out-expo')
end

function IconButton:released()
    self:animate(assets.config.transition.tween, self, {color = Color.black}, 'out-expo')
end

function IconButton:leave()
    self:animate(assets.config.transition.tween, self, {color = Color.black}, 'out-expo')
end

function IconButton:onclick()
    TEsound.play(assets.sounds.click)
    if self.callback then self.callback() end
end

function IconButton:draw()
    love.graphics.setColor(self.color)
    love.graphics.draw(self.image, self.x, self.y, 0, self.scale, self.scale)
end

return IconButton