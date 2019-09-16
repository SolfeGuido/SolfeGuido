

local Entity = require('src.entity')

---@param note integer
---@return number
local function noteToPosition(note)
    return 17 + note * 10
end

---@class Note : Object
local Note = Entity:extend()


function Note:new(area, id, options)
    Note.super.new(self, area, id, options)
    self.y = noteToPosition(self.note)
    self.image = assets.images.note
end

function Note:draw()
    if self.note <= 4 then
        love.graphics.push()
        love.graphics.translate(0, 50)
        for i = 4, self.note, -2 do
            love.graphics.line(self.x - 4, noteToPosition(i), self.x + 2 + self.image:getWidth(), noteToPosition((i)))
        end
        love.graphics.pop()
    elseif self.note >= 15 then
        love.graphics.push()
        for i = 15, 20, 2 do
            love.graphics.line(self.x - 4, noteToPosition(i), self.x + 2, noteToPosition((i)))
        end
        love.graphics.pop()
    end

    love.graphics.draw(self.image, self.x, self.y)
end

function Note:update(dt)
    self.x = self.x - self.area:getMove()
    if self.x < 0 then
        self.dispose(self)
    end
end

return Note