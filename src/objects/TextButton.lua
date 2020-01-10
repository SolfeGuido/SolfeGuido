-- LIBS
local Theme = require('src.utils.Theme')

-- Entities
local AbstractButton = require('src.objects.AbstractButton')

---@class TextButton : AbstractButton
local TextButton = AbstractButton:extend()

function TextButton:new(area, config)
    AbstractButton.new(self, area, config)
    self.color = config.color or Theme.font:clone()
    self.padding = config.padding or 0
    self.width = self.text:getWidth() + self.padding * 2
    self.height = self.text:getHeight() + self.padding * 2

    if self.icon then
        self.width = self.width + self.icon:getWidth() + self.padding
    end

    if self.centerText then
        self.x = self.x - (self.width / 2)
    end
end


function TextButton:dispose()
    TextButton.super.dispose(self)
end

function TextButton:pressed()
    self:animate(Vars.transition.tween, self, {color = Theme.clicked}, 'out-expo')
end

function TextButton:released()
    self:animate(Vars.transition.tween, self, {color = Theme.font}, 'out-expo')
end


function TextButton:onclick()
    assets.sounds.click:play()
    if self.callback then self.callback(self) end
end

function TextButton:draw()

    if self.framed then
        love.graphics.setColor(Theme.background)
        love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
        love.graphics.setColor(self.color)
        love.graphics.rectangle('line', self.x, self.y, self.width, self.height)
    end
    love.graphics.setColor(self.color)
    local x = self.x + self.padding
    if self.icon then
        local iconY = self.y + self.height / 2 - self.icon:getHeight() / 2
        love.graphics.draw(self.icon, x, iconY)
        x = x + self.icon:getWidth() + self.padding
    end

    love.graphics.draw(self.text, x, self.y + self.padding)
end



return TextButton