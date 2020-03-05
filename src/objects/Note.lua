

local Effect = require('src.objects.CorrectNoteEffect')
local Entity = require('src.Entity')
local Theme = require('src.utils.Theme')

--- Another core entity of the game, is used to repressent
--- a single note, it takes care of drawing itself in the
--- right orientation, and draws the extra lines if needed
--- When wrong, it draws it's name next to it, when
--- right, it spawns a particle to show it was right
--- must be contained inside a Measure to have access
--- to the right function, and be drawn correctly
---@class Note : Entity
---@field public container PlayState
---@field public measure Measure
---@field public rotation number
---@field public xOrigin number
---@field public yOrigin number
local Note = Entity:extend()

--- Constructor
---@param container EntityContainer
---@param options table
function Note:new(container, options)
    Note.super.new(self, container)
    self:reset(options.note, options.x)
end

--- Resets the note name, x position
--- and puts it at the end of the current
--- measure, this function is used by the circular
--- queue, in order to avoid garbage collection,
--- by using an object pool
---@param note string
---@param x number
function Note:reset(note, x)
    self.isDead =  false
    self.note = note
    self.x = x
    self.image = self.container.noteIcon
    self.color = Theme.font:clone()
    self.name = nil
    self.measureIndex = self.container:indexOf(self.note)
    self.y = self:noteToPosition(self.measureIndex)
    self.width = self.image:getWidth() + (Vars.note.padding * self.image:getWidth() * 2)
    self.rotation = self.measureIndex >= 10 and math.pi or 0
    self.yOrigin = Vars.note.yOrigin * self.container.noteHeight
    self.xOrigin = Vars.note.xOrigin * self.image:getWidth()
end

--- Inherited method
function Note:dispose()
    self.image = nil
    if self.name then
        self.name:release()
        self.name = nil
    end
    self.color = nil
    Note.super.dispose(self)
end

--- Quick acesss to the container
--- method
---@param note number
---@return number
function Note:noteToPosition(note)
    return self.container:getNotePosition(note)
end

--- Called whenever the answer given by the user
--- is the correct one, fades the note away
--- and spawns a Effect particle (could be optimized
--- with an object pool)
function Note:correct()
    self.color = Theme.correct:clone()
    self.container:addEntity(Effect, {
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

--- Called whenever the user's answer
--- is wrong, shows the actual note name,
--- changes the note icon to a ghost note,
--- changes the color to red
--- and starts fading away
function Note:wrong()
    self.color = Theme.wrong:clone()
    self:fadeAway()
    local font = love.graphics.newFont(self.container.noteHeight)
    self.image = self.container.wrongNoteIcon
    self.name = love.graphics.newText(font, self.container:getNoteName(self.note))
    self.nameColor = Theme.font:clone()
    self.nameYPos = self.y +  (self.measureIndex % 2 == 0 and 0 or -self.container.noteHeight / 2)
    self.nameXIncr = self.container.noteHeight * 2
end

--- Changes opcatiy to 0
--- over time
function Note:fadeAway()
    self:fadeTo(self.color:alpha(0))
end

---- Tweening to change the color
--- over time
function Note:fadeTo(color)
    self.timer:tween(Vars.note.fadeAway, self, {color = color}, 'linear', function() self.isDead = true end)
end

--- Inherited method
function Note:draw()
    --Color for the (optional) bars
    love.graphics.setColor(Theme.font:alpha(self.color.a))
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
    love.graphics.draw(self.image, self.x + padding + self.xOrigin, self.y,
                        self.rotation, nil, nil,  self.xOrigin, self.yOrigin)

    if self.name then
        self.nameColor[4] = self.color.a
        love.graphics.setColor(self.nameColor)
        love.graphics.draw(self.name, self.x + self.nameXIncr, self.nameYPos)
    end
end

--- Inherited method, moves the
--- note to the left by the amount
--- given by its container
---@param dt number
function Note:update(dt)
    Entity.update(self, dt)
    self.x = self.x - self.container:getMove()
    if self.x < 0 then
        self.isDead = true
    end
end

return Note