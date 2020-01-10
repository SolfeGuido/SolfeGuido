

local AbstractButton = require('src.objects.AbstractButton')
local Theme = require('src.utils.Theme')

---@class MobileButton : AbstractButton
local MobileButton = AbstractButton:extend()

function MobileButton:new(area, options)
    AbstractButton.new(self, area, options)
    self.color = options.color or Theme.font:clone()
end

function MobileButton:contains(x, y)
    local padding = Vars.mobileButton.padding
    return self.x <= x and (self.x + (self.width or (self.text:getWidth() + padding * 2))) >= x and
            self.y <= y and (self.y + (self.text:getHeight() + padding * 2)) >= y
end

function MobileButton:hovered()
    self:animate(Vars.transition.tween, self, {color = Theme.hovered}, 'out-expo')
end

function MobileButton:leave()
    self:animate(Vars.transition.tween, self, {color = Theme.font}, 'out-expo')
end

function MobileButton:pressed()
    self:animate(Vars.transition.tween, self, {color = Theme.clicked}, 'out-expo')
end

function MobileButton:released()
    self:animate(Vars.transition.tween, self, {color = Theme.font}, 'out-expo')
end

function MobileButton:onclick()
    if self.callback then self.callback() end
    self.consumed = false
end

function MobileButton:draw()
    love.graphics.push()
    love.graphics.translate(self.x, self.y)
    local box = self:boundingBox()
    love.graphics.setColor(Theme.background)
    love.graphics.rectangle('fill', 0, 0, box.width, box.height)
    love.graphics.setColor(self.color)
    love.graphics.rectangle('line', 0, 0, box.width, box.height)
    local txtX = (box.width - self.text:getWidth()) / 2
    love.graphics.draw(self.text, txtX, Vars.mobileButton.padding)

    love.graphics.pop()
end

return MobileButton