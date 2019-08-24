

local Entity = require('src.entity')


---@class Note : Object
local Note = Entity:extend()

function Note:new(area, id, x, y, image)
    Note.super.new(self, id, area, x, y)
    self.image = image
end

function Note:draw()
    print("drawing")
    love.graphics.draw(self.image, self.x, self.y)
end

function Note:update(dt)

end

return Note