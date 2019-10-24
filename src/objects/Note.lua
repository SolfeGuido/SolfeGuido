

local Entity = require('src.Entity')
local Color = require('src.utils.Color')

---@class Note : Entity
---@field public area PlayState
local Note = Entity:extend()


function Note:new(area, options)
    Note.super.new(self, area, options)
    self.y = self:noteToPosition(self.note)
    self.image = assets.images.note
    self.color = Color.black:clone()
    self.name = nil
end


--- The total width of a note
---@return number
function Note.width(measure)
    local scale = (measure.noteHeight * assets.config.note.height) / assets.images.note:getHeight()
    return assets.config.note.padding * 2 * measure.noteHeight + scale * assets.images.note:getWidth()
end

---@param note number
---@return number
function Note:noteToPosition(note)
    return self.measure:getNotePosition(note)
end

function Note:correct()
    self.color = Color(0, 0.5, 0, 1)
    self:fadeTo(Color(0, 0.5, 0, 0))
end

function Note:wrong()
    self.color = Color(0.5, 0, 0, 1)
    self:fadeTo(Color.transparent)
    self.name = self.measure:getNoteName(self.note)
end

function Note:fadeAway()
    self:fadeTo( Color.transparent)
end

function Note:fadeTo(color)
    self.timer:tween(assets.config.note.fadeAway, self, {color = color}, 'linear', function() self.isDead = true end)
end

function Note:draw()
    --Color for the (optional) bars
    love.graphics.setColor(0, 0, 0, self.color.a)
    love.graphics.setLineWidth(1)
    local scale = (self.measure.noteHeight * assets.config.note.height) / self.image:getHeight()
    local xOrig = assets.config.note.xOrigin
    local yOrig = assets.config.note.yOrigin
    local actualWidth = scale * self.image:getWidth()
    local padding = assets.config.note.padding * self.measure.noteHeight
    if self.note <= 4 then
        for i = 5, self.note + 1, -2 do
            local y = self:noteToPosition(i - 1)
            love.graphics.line(self.x, y, self.x + actualWidth + padding * 2, y)
        end
    elseif self.note >= 15 then
        for i = 16, self.note, 2 do
            local y = self:noteToPosition(i)
            love.graphics.line(self.x, y, self.x +  actualWidth + padding * 2, y)
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
    Note.super.update(self, dt)
    self.x = self.x - self.area:getMove()
    if self.x < 0 then
        self.isDead = true
    end
end

return Note