
local Entity = require('src.Entity')
local Rectangle = require('src.utils.Rectangle')

---@class AbstractButton : Entity
local AbstractButton = Entity:extend()

function AbstractButton:new(area, options)
    Entity.new(self, area, options)
    self.state = "neutral"
    self.consumed = false
end

function AbstractButton:dispose()
    self.text:release()
    self.text = nil
    AbstractButton.super.dispose(self)
end

function AbstractButton:boundingBox()
    return Rectangle(self.x, self.y, self.text:getWidth(), self.text:getHeight())
end

function AbstractButton:contains(x, y)
    return self:boundingBox():contains(x, y)
end

function AbstractButton:mousemoved(x, y)
    if self:contains(x, y) and self.state == "neutral" then
        self.state = "hovered"
        if self.hovered then self:hovered() end
    elseif self.state == "hovered" and not self:contains(x, y) then
        self.state = "neutral"
        if self.leave then self:leave() end
    end
end

function AbstractButton:mousepressed(x, y, button)
    if button == 1 and (self.state == "neutral" or self.state == "hovered") then
        if self:contains(x, y) then
            self.state = "pressed"
            if self.pressed then self:pressed() end
        end
    end
end

function AbstractButton:mousereleased(x, y, button)
    if button == 1 and self.state == "pressed" then
        if self:contains(x, y) then
            self.state = "neutral"
            if not self.consumed then
                self.consumed = true
                if self.onclick then self:onclick() end
            end
        end
    end
end

return AbstractButton