
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
end

function RadioButton:boundingBox()
    return Rectangle(self.x, self.y, self.width, self.height)
end

function RadioButton:onclick()
    if self.callback then self.callback(self) end
end

function RadioButton:draw()
    if self.framed then
        love.graphics.setColor(self.isChecked and Theme.secondary or Theme.background)
        love.graphics.rectangle('fill', self.x, self.y, self.image:getWidth(), self.image:getHeight())
    
        love.graphics.setColor(Theme.font)
        love.graphics.rectangle('line', self.x, self.y, self.image:getWidth(), self.image:getHeight())
    end

    love.graphics.setColor(self.color)
    love.graphics.draw(self.image, self.x, self.y)
end

function RadioButton:update(dt)
end

return RadioButton