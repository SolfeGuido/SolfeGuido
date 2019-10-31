

-- LIBS
local Theme = require('src.utils.Theme')
local Rectangle = require('src.utils.Rectangle')

-- Entities
local AbstractButton = require('src.objects.AbstractButton')

---@class IconButton : AbstractButton
local IconButton = AbstractButton:extend()

function IconButton:new(area, config)
    AbstractButton.new(self, area, config)
    local defaultFont = assets.IconsFont(config.size or assets.config.titleSize)
    self.image = love.graphics.newText(defaultFont,  config.icon)
    self.color = config.color or Theme.font:clone()
    self._width = self.image:getWidth()
    self.height = self.image:getHeight()
    self.rotation = 0
    self.xOrigin = self._width / 2
    self.yOrigin = self.height / 2
end

function IconButton:setIcon(icon)
    self.image:set(icon)
end

function IconButton:width()
    return self._width
end

function IconButton:dispose()
    self.image:release()
    self.image = nil
    IconButton.super.dispose(self)
end

function IconButton:boundingBox()
    return Rectangle(self.x, self.y, self._width, self.height)
end

function IconButton:hovered()
    self:animate(assets.config.transition.tween, self, {color =  Theme.hovered}, 'out-expo')
end

function IconButton:pressed()
    self:animate(assets.config.transition.tween, self, {color = Theme.clicked}, 'out-expo')
end

function IconButton:released()
    self:animate(assets.config.transition.tween, self, {color = Theme.font}, 'out-expo')
end

function IconButton:leave()
    self:animate(assets.config.transition.tween, self, {color = Theme.font}, 'out-expo')
end

function IconButton:onclick()
    TEsound.play(assets.sounds.click)
    if self.callback then self.callback(self) end
end

function IconButton:draw()
    love.graphics.setColor(self.color)
    love.graphics.draw(self.image, self.x + self.xOrigin, self.y + self.yOrigin, self.rotation, nil, nil, self.xOrigin, self.yOrigin)
end

return IconButton