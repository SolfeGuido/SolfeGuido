

local AbstractButton = require('src.objects.AbstractButton')
local Rectangle = require('src.utils.Rectangle')

---@class MobileButton : AbstractButton
local MobileButton = AbstractButton:extend()

function MobileButton:new(area, options)
    AbstractButton.new(self, area, options)
    self.color = options.color or assets.config.color.white()
end

function MobileButton:boundingBox()
    local padding = assets.config.mobileButton.padding
    return Rectangle(self.x, self.y, self.text:getWidth() + padding * 2, self.text:getHeight() + padding * 2)
end

function MobileButton:hovered()
    self:animate(assets.config.transition.tween, self, {color = assets.config.color.lightgray()}, 'out-expo')
end

function MobileButton:leave()
    self:animate(assets.config.transition.tween, self, {color = assets.config.color.white()}, 'out-expo')
end

function MobileButton:pressed()
    self:animate(assets.config.transition.tween, self, {color = assets.config.color.darkgray()}, 'out-expo')
end

function MobileButton:released()
    self:animate(assets.config.transition.tween, self, {color = assets.config.color.white()}, 'out-expo')
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
    love.graphics.setColor(assets.config.color.black())
    love.graphics.rectangle('line', 0, 0, box.width, box.height)
    love.graphics.draw(self.text, assets.config.mobileButton.padding, assets.config.mobileButton.padding)

    love.graphics.pop()
end

return MobileButton