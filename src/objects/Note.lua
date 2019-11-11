

local Effect = require('src.objects.CorrectNoteEffect')
local Entity = require('src.Entity')
local Theme = require('src.utils.Theme')

---@class Note : Entity
---@field public area PlayState
---@field public measure Measure
local Note = Entity:extend()


function Note:new(area, options)
    Note.super.new(self, area, options)
    self.image = self.measure.noteIcon
    self.color = Theme.font:clone()
    self.name = nil
    self.measureIndex = self.measure:indexOf(self.note)
    self.y = self:noteToPosition(self.measureIndex)
    self.width = self.image:getWidth() + (Vars.note.padding * self.image:getWidth() * 2)
    self.rotation = self.measureIndex >= 10 and math.pi or 0
    self.yOrigin = Vars.note.yOrigin * self.measure.noteHeight
    self.xOrigin = Vars.note.xOrigin * self.image:getWidth()
end


function Note:dispose()
    self.image = nil
    if self.name then
        self.name:release()
        self.name = nil
    end
    self.color = nil
    Note.super.dispose(self)
end

---@param note number
---@return number
function Note:noteToPosition(note)
    return self.measure:getNotePosition(note)
end

function Note:correct()
    self.color = Theme.correct:clone()
    self.area:addentity(Effect, {
        image = self.image,
        color = Theme.correct:clone(),
        scale = 1,
        rotation = self.rotation,
        xOrigin = self.xOrigin,
        yOrigin = self.yOrigin,
        target = self,
        padding = Vars.note.padding * self.image:getWidth()
    })
    self:fadeAway()
end

function Note:wrong()
    self.color = Theme.wrong:clone()
    self:fadeAway()
    local font = love.graphics.newFont(self.measure.noteHeight)
    self.name = love.graphics.newText(font, self.measure:getNoteName(self.note))
end

function Note:fadeAway()
    local r,g,b = unpack(self.color.rgb)
    self:fadeTo({r, g, b, 0})
end

function Note:fadeTo(color)
    self.timer:tween(Vars.note.fadeAway, self, {color = color}, 'linear', function() self.isDead = true end)
end

function Note:draw()
    --Color for the (optional) bars
    local r,g,b = unpack(Theme.font.rgb)
    love.graphics.setColor(r,g,b, self.color.a)
    love.graphics.setLineWidth(1)
    local actualWidth = self.image:getWidth()
    local padding = Vars.note.padding * actualWidth
    if self.measureIndex <= 4 then
        for i = 5, self.measureIndex + 1, -2 do
            local y = self:noteToPosition(i - 1)
            love.graphics.line(self.x, y, self.x + actualWidth + padding * 2, y)
        end
    elseif self.measureIndex >= 15 then
        for i = 16, self.measureIndex, 2 do
            local y = self:noteToPosition(i)
            love.graphics.line(self.x, y, self.x +  actualWidth + padding * 2, y)
        end
    end
    love.graphics.setColor(self.color)
    love.graphics.draw(self.image, self.x + padding + self.xOrigin, self.y, self.rotation, nil, nil,  self.xOrigin, self.yOrigin)

    if self.name then
        r,g,b = unpack(Theme.font.rgb)
        love.graphics.setColor(r,g,b, self.color.a)
        local yPos = self.measureIndex % 2 == 0 and 0 or self.measure.noteHeight / 2
        love.graphics.draw(self.name, self.x - 15, self.y + yPos)
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