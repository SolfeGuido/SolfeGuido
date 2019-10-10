

local AbstractButton = require('src.objects.AbstractButton')
local Rectangle = require('src.utils.Rectangle')
local Color = require('src.utils.Color')

---@class MobileButton : AbstractButton
local MobileButton = AbstractButton:extend()

function MobileButton:new(area, options)
    AbstractButton.new(self, area, options)
    self.color = options.color or Color.white:clone()
end

function MobileButton:boundingBox()
    local padding = assets.config.mobileButton.padding
    return Rectangle(self.x, self.y, self.text:getWidth() + padding * 2, self.text:getHeight() + padding * 2)
end

function MobileButton:hovered()
    self:animate(assets.config.transition.tween, self, {color = Color.gray(0.7)}, 'out-expo')
end

function MobileButton:leave()
    self:animate(assets.config.transition.tween, self, {color = Color.white}, 'out-expo')
end

function MobileButton:pressed()
    self:animate(assets.config.transition.tween, self, {color = Color.gray(0.3)}, 'out-expo')
end

function MobileButton:released()
    self:animate(assets.config.transition.tween, self, {color = Color.white}, 'out-expo')
end

function MobileButton:onclick()
    if self.callback then self.callback() end
    self.consumed = false
end

function MobileButton:draw()
    love.graphics.push()
    love.graphics.translate(self.x, self.y)
    local box = self:boundingBox()
    love.graphics.setColor(self.color)
    love.graphics.rectangle('fill', 0, 0, box.width, box.height)
    love.graphics.setColor(Color.black)
    love.graphics.rectangle('line', 0, 0, box.width, box.height)
    love.graphics.draw(self.text, assets.config.mobileButton.padding, assets.config.mobileButton.padding)

    love.graphics.pop()
end

return MobileButton