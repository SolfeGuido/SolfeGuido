local AbstractButton = require('src.objects.AbstractButton')
local Theme = require('src.utils.Theme')
local Rectangle = require('src.utils.Rectangle')

---@class PianoKey : Entity
local PianoKey = AbstractButton:extend()

function PianoKey:new(area, options)
    AbstractButton.new(self, area, options)
    self.backgroundColor = options.backgroundColor or Theme.background:clone()
    self._bgColor = self.backgroundColor:clone()
    self.color = options.color or Theme.font:clone()
    if self.text then
        self.textX = self.x + self.width / 2 - self.text:getWidth() / 2
        self.textY = self.y + self.height - self.text:getHeight() - 10
    end
end

function PianoKey:boundingBox()
    return Rectangle(self.x, self.y, self.width, self.height)
end

function PianoKey:pressed()
    self:animate(Vars.transition.tween, self, {backgroundColor = Theme.hovered}, 'out-expo')
end

function PianoKey:onclick()
    if self.callback then self.callback(self) end
end

function PianoKey:released()
    self:animate(Vars.transition.tween, self, {backgroundColor = self._bgColor}, 'out-expo')
end

function PianoKey:draw()
    love.graphics.setColor(self.backgroundColor)
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)

    love.graphics.setColor(self.color)
    love.graphics.rectangle('line', self.x, self.y, self.width, self.height)

    if self.text then
        love.graphics.draw(self.text, self.textX, self.textY)
    end

end

function PianoKey:update(dt)
end

return PianoKey