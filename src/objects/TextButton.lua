

-- LIBS
local Color = require('src.utils.Color')
local Rectangle = require('src.utils.Rectangle')

-- Entities
local AbstractButton = require('src.objects.AbstractButton')
local Selector = require('src.objects.Selector')

---@class TextButton : AbstractButton
local TextButton = AbstractButton:extend()

function TextButton:new(area, config)
    AbstractButton.new(self, area, config)
    self.selector = self.area:addentity(Selector, {
        x = self.x - 20,
        y = self.y + 5,
        visible = false
    })
    self.selector:createAlpha()
    self.color = config.color or Color.black:clone()
end

function TextButton:dispose()
    self.selector.isDead = true
    TextButton.super.dispose(self)
end

function TextButton:boundingBox()
    return Rectangle(self.x, self.y, assets.config.limitLine - 10, self.text:getHeight() - 7)
end

function TextButton:hovered()
    self.selector.visible = true
end

function TextButton:pressed()
    self.selector.visible = true
    self:animate(assets.config.transition.tween, self, {color = Color.gray(0.7)}, 'out-expo')
end

function TextButton:released()
    self:animate(assets.config.transition.tween, self, {color = Color.black}, 'out-expo')
end

function TextButton:leave()
    self.selector.visible = false
end

function TextButton:onclick()
    TEsound.play(assets.sounds.click)
    if self.callback then self.callback(self) end
end

function TextButton:draw()
    love.graphics.setColor(self.color)
    love.graphics.draw(self.text, self.x + 5, self.y)
end

function TextButton:update(_)
    self.selector.x = self.x - 20
    self.selector.y = self.y
end




return TextButton