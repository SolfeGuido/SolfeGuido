local Entity = require('src.Entity')

---@class Image : Entity
local Image = Entity:extend()

function Image:new(area, options)
    Entity.new(self, area, options)
    if not self.scale and self.size then
        local max = math.max(self.image:getWidth(), self.image:getHeight())
        self.scale = self.size / max
    end
    self.rotation = options.rotation or 0
    self.xOrigin = self.image:getWidth()  / 2
    self.yOrigin = self.image:getHeight() / 2
end

function Image:draw()
    love.graphics.setColor(self.color)
    love.graphics.draw(self.image, self.x, self.y, self.rotation, self.scale, self.scale, self.xOrigin, self.yOrigin)
end

return Image