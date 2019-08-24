

local Entity = require('src.entity')

---@param note integer
---@return number
local function noteToPosition(note)
    return 20 + note * 10
end

---@class Note : Object
local Note = Entity:extend()


function Note:new(area, id, note, image)
    local y = noteToPosition(note)
    Note.super.new(self, id, area, love.graphics.getWidth(), y)
    self.note = note
    self.image = image
end

function Note:draw()
    love.graphics.draw(self.image, self.x, self.y)
end

function Note:update(dt)

end

return Note