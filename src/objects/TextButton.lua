

-- LIBS
local Theme = require('src.utils.Theme')
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
        visible = false,
        icon = config.icon or assets.IconName.WholeNote
    })
    self.color = config.color or Theme.font:clone()
    if self.centered then
        self.timer:tween(Vars.transition.tween, self, {x = self:getCenterX()}, 'out-expo')
    end
end

function TextButton:getCenterX()
    return (love.graphics.getWidth() - self.text:getWidth()) / 2
end

function TextButton:dispose()
    self.selector.isDead = true
    TextButton.super.dispose(self)
end

function TextButton:boundingBox()
    if self.framed then
        return Rectangle(self.x - 30, self.y - 5, self.text:getWidth() + 50, self.text:getHeight() + 10)

    end
    return Rectangle(self.x, self.y, Vars.limitLine - 30, Vars.lineHeight - 1)
end


function TextButton:hovered()
    self.selector.visible = true
end

function TextButton:pressed()
    self.selector.visible = true
    self:animate(Vars.transition.tween, self, {color = Theme.clicked}, 'out-expo')
end

function TextButton:released()
    self:animate(Vars.transition.tween, self, {color = Theme.font}, 'out-expo')
end

function TextButton:setConsumed(consumed)
    self.consumed = consumed
    if not consumed and self.state == "neutral" then
        self.selector.visible = false
    end
end

function TextButton:leave()
    if not self.consumed then
        self.selector.visible = false
    end
end

function TextButton:onclick()
    TEsound.play(assets.sounds.click)
    if self.callback then self.callback(self) end
end

function TextButton:draw()
    love.graphics.setColor(self.color)
    if self.framed then
        local width = self.text:getWidth()
        local height = self.text:getHeight()
        love.graphics.rectangle('line', self.x - 30, self.y - 5, width + 50, height + 10)
    end

    love.graphics.draw(self.text, self.x + 5, self.y)
end

function TextButton:update(_)
    self.selector.x = self.x - 20
    self.selector.y = self.y
end




return TextButton