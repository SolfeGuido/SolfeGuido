

local Entity = require('src.Entity')
local Rectangle = require('src.utils.Rectangle')

---@class MobileButton : Entity
local MobileButton = Entity:extend()

function MobileButton:new(area, options)
    Entity.new(self, area, options)
end

function MobileButton:dispose()
    self.text:release()
    self.text = nil
    Entity.dispose(self)
    self.pressed = false
end

function MobileButton:boundingBox()
    return Rectangle(self.x, self.y, self.text:getWidth(), self.text:getHeight())
end

function MobileButton:draw()
    love.graphics.push()
    love.graphics.translate(self.x, self.y)
    local box = self:boundingBox()
    love.graphics.setColor(assets.config.color.black())
    love.graphics.rectangle('line', 0, 0, box.width, box.height)
    love.graphics.draw(self.text, 0, 0)

    love.graphics.pop()
end

return MobileButton