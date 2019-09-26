

local Entity = require('src.entity')

---@class Note : Entity
---@field public area PlayState
local Note = Entity:extend()


function Note:new(area, options)
    Note.super.new(self, area, options)
    self.y = self:noteToPosition(self.note)
    self.image = assets.images.note
    self.color = assets.config.color.black()
    self.name = nil
end


--- The total width of a note
---@return number
function Note.width()
    local scale = assets.config.note.height / assets.images.note:getHeight()
    return assets.config.note.padding * 2 + scale * assets.images.note:getWidth()
end

---@param note number
---@return number
function Note:noteToPosition(note)
    local base = self.area:getBaseLine()
    return base - (note - 6) * (assets.config.lineHeight / 2)
end

function Note:correct()
    self.color = {0, 0.5, 0, 1}
    self:fadeTo({0, 0.5, 0, 0})
end

function Note:wrong()
    self.color = {0.5, 0, 0, 1}
    self:fadeTo(assets.config.color.transparent())-- {0.5, 0, 0, 0})
    self.name = self.area.key:getNoteName(self.note)
end

function Note:fadeAway()
    self:fadeTo(assets.config.color.transparent())
end

function Note:fadeTo(color)
    self.area.timer:tween(assets.config.note.fadeAway, self, {color = color}, 'linear', function() self:dispose() end)
end

function Note:draw()
    --Color for the (optional) bars
    love.graphics.setColor(0, 0, 0, self.color[4])
    local scale = assets.config.note.height / self.image:getHeight()
    local xOrig = assets.config.note.xOrigin
    local yOrig = assets.config.note.yOrigin
    local actualWidth = scale * self.image:getWidth()
    local padding = assets.config.note.padding
    if self.note <= 4 then
        for i = 6, self.note, -2 do
            love.graphics.line(self.x, self:noteToPosition(i), self.x + actualWidth + padding * 2, self:noteToPosition((i)))
        end
    elseif self.note >= 15 then
        for i = 16, self.note, 2 do
            love.graphics.line(self.x, self:noteToPosition(i), self.x +  actualWidth + padding * 2, self:noteToPosition((i)))
        end
    end

    if self.note >= 10 then scale = -scale end
    love.graphics.setColor(self.color)
    love.graphics.draw(self.image, self.x +  padding + actualWidth / 2, self.y, 0, scale, scale, xOrig, yOrig)

    if self.name then
        love.graphics.print(self.name, self.x - 15, self.y + 5)
    end
end

---@param dt number
function Note:update(dt)
    self.x = self.x - self.area:getMove()
    if self.x < 0 then
        self.dispose(self)
    end
end

return Note