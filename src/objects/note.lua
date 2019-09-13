

local Entity = require('src.entity')

---@param note integer
---@return number
local function noteToPosition(note)
    return 17 + note * 10
end

---@class Note : Object
local Note = Entity:extend()


function Note:new(area, id, note, x, image)
    local y = noteToPosition(note)
    Note.super.new(self, area, id, love.graphics.getWidth() + x, y)
    self.note = note
    self.image = image
end

function Note:draw()
    love.graphics.draw(self.image, self.x, self.y)
end

function Note:update(dt)
    self.x = self.x - self.area:getMove()
    if self.x < 0 then
        self.dispose(self)
    end
end

return Note