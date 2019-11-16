
local AbstractButton = require('src.objects.AbstractButton')
local Theme = require('src.utils.Theme')
local Rectangle = require('src.utils.Rectangle')

---@class RadioButton : Entity
local RadioButton = AbstractButton:extend()

function RadioButton:new(area, options)
    AbstractButton.new(self, area, options)
    self.isChecked = options.isChecked or false
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
    self.value = options.value
    self.padding = options.padding or 0
    self.backgroundColor = self.isChecked and Theme.secondary:clone() or Theme.background:clone()
    self.tween = nil
end

function RadioButton:uncheck()
    if not self.isChecked then return end
    self:toggle()
end

function RadioButton:check()
    if self.isChecked then return end
    self:toggle()
end

function RadioButton:toggle()
    if self.tween then self.timer:cancel(self.tween) end
    self.timer:tween(Vars.transition.tween, self, {backgroundColor = self.isChecked and Theme.background or Theme.secondary}, 'linear')
    self.isChecked = not self.isChecked
end

function RadioButton:boundingBox()
    return Rectangle(self.x - self.padding, self.y - self.padding, self.width + self.padding * 2, self.height + self.padding * 2)
end

function RadioButton:onclick()
    TEsound.play(assets.sounds.click)
    if self.callback then self.callback(self) end
end

function RadioButton:draw()
    love.graphics.setColor(self.backgroundColor)
    love.graphics.rectangle('fill', self.x - self.padding, self.y - self.padding, self.width + self.padding * 2, self.height + self.padding * 2)
    if self.framed then
        love.graphics.setColor(Theme.font)
        love.graphics.rectangle('line', self.x - self.padding, self.y - self.padding, self.width + self.padding * 2, self.height + self.padding * 2)
    end

    love.graphics.setColor(self.color)
    love.graphics.draw(self.image, self.x, self.y)
end


return RadioButton