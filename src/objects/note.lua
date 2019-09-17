

local Entity = require('src.entity')

---@class Note : Object
---@field public area PlayScene
local Note = Entity:extend()


function Note:new(area, id, options)
    Note.super.new(self, area, id, options)
    self.y = self:noteToPosition(self.note)
    self.image = assets.images.note
end

---@param note number
---@return number
function Note:noteToPosition(note)
    local base = self.area:getBaseLine()
    return base - (note - 5) * (assets.config.lineHeight / 2)
end

function Note:draw()
    if self.note <= 4 then
        love.graphics.push()
        love.graphics.translate(0, 50)
        for i = 4, self.note, -2 do
            love.graphics.line(self.x - 4, self:noteToPosition(i), self.x + 2 + self.image:getWidth(), self:noteToPosition((i)))
        end
        love.graphics.pop()
    elseif self.note >= 15 then
        love.graphics.push()
        for i = 15, 20, 2 do
            love.graphics.line(self.x - 4, self:noteToPosition(i), self.x + 2, self:noteToPosition((i)))
        end
        love.graphics.pop()
    end

    local scale = assets.config.note.height / self.image:getHeight()
    love.graphics.draw(self.image, self.x, self.y, 0, scale, scale, 0, assets.config.note.yOrigin)
end

function Note:update(dt)
    self.x = self.x - self.area:getMove()
    if self.x < 0 then
        self.dispose(self)
    end
end

return Note