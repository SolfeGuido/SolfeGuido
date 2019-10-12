

-- LIBS
local Color = require('src.utils.Color')
local Rectangle = require('src.utils.Rectangle')

-- Entities
local AbstractButton = require('src.objects.AbstractButton')
local Selector = require('src.objects.Selector')

---@class Button : AbstractButton
local Button = AbstractButton:extend()

function Button:new(area, config)
    AbstractButton.new(self, area, config)
    self.selector = self.area:addentity(Selector, {
        x = self.x - 10,
        y = self.y + 5,
        visible = false
    })
    self.selector:createAlpha()
    self.color = config.color or Color.black:clone()
end

function Button:dispose()
    self.selector.isDead = true
    Button.super.dispose(self)
end

function Button:boundingBox()
    return Rectangle(self.x, self.y, assets.config.limitLine - 10, self.text:getHeight() - 7)
end

function Button:hovered()
    self.selector.visible = true
end

function Button:pressed()
    self.selector.visible = true
    self:animate(assets.config.transition.tween, self, {color = {0.7, 0.7, 0.7, 1}}, 'out-expo')
end

function Button:released()
    self:animate(assets.config.transition.tween, self, {color = Color.black}, 'out-expo')
end

function Button:leave()
    self.selector.visible = false
end

function Button:onclick()
    if self.callback then self.callback() end
end

function Button:draw()
    love.graphics.setColor(self.color)
    love.graphics.draw(self.text, self.x + 5, self.y)
end

function Button:update(_)
    self.selector.x = self.x - 15
    self.selector.y = self.y
end




return Button