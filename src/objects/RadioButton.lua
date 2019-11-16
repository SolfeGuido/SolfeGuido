
local AbstractButton = require('src.objects.AbstractButton')
local Theme = require('src.utils.Theme')
local Rectangle = require('src.utils.Rectangle')

---@class RadioButton : Entity
local RadioButton = AbstractButton:extend()

function RadioButton:new(area, options)
    AbstractButton.new(self, area, options)
    self.isChecked = options.isChecked or false
    self.padding = options.padding or 0
    self.backgroundColor = self.isChecked and Theme.secondary:clone() or Theme.background:clone()
    self.tween = nil
    if self.image:type() == "Image" then
        self.scale = Vars.titleSize / self.image:getHeight()
    end
    self._width = self.image:getWidth() * (self.scale or 1)
    self.height = self.image:getHeight() * (self.scale or 1)
end

function RadioButton:width()
    return self._width
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
    return Rectangle(self.x - self.padding, self.y - self.padding, self._width + self.padding * 2, self.height + self.padding * 2)
end

function RadioButton:onclick()
    TEsound.play(assets.sounds.click)
    if self.callback then self.callback(self) end
end

function RadioButton:draw()
    love.graphics.setColor(self.backgroundColor)
    love.graphics.rectangle('fill', self.x - self.padding, self.y - self.padding, self._width + self.padding * 2, self.height + self.padding * 2)
    if self.framed then
        love.graphics.setColor(Theme.font)
        love.graphics.rectangle('line', self.x - self.padding, self.y - self.padding, self._width + self.padding * 2, self.height + self.padding * 2)
    end
    if self.image:type() ~= "Image" then
        love.graphics.setColor(self.color)
    end
    love.graphics.draw(self.image, self.x, self.y, 0, self.scale, self.scale)
end


return RadioButton