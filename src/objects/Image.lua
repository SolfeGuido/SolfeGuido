local Entity = require('src.Entity')

--- Used to draw images instead of icons,
--- this is a simple object representation
--- to simplify the handling of love images
--- used for non-interactive images
---@class Image : Entity
---@field xOrigin number
---@field yOrigin number
---@field rotation number
local Image = Entity:extend()

---@param container EntityContainer
---@param options table
function Image:new(container, options)
    Entity.new(self, container, options)
    if not self.scale and self.size then
        local max = math.max(self.image:getWidth(), self.image:getHeight())
        self.scale = self.size / max
    end
    self.rotation = options.rotation or 0
    self.xOrigin = self.image:getWidth()  / 2
    self.yOrigin = self.image:getHeight() / 2
end

--- Inherited method
function Image:draw()
    love.graphics.setColor(self.color)
    love.graphics.draw(self.image, self.x, self.y, self.rotation, self.scale, self.scale, self.xOrigin, self.yOrigin)
end

return Image