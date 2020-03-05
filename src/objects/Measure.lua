local EntityContainer = require('src.objects.EntityContainer')
local Config = require('src.data.Config')
local Theme = require('src.utils.Theme')
local Note = require('src.objects.Note')
local CircularQueue = require('src.utils.CircularQueue')
local lume = require('lib.lume')

--- One of the core entity of the game, represents a simple measure, can show several
--- notes and a single key at the begining of it, is also contains an image for when
--- the note is wrong (and for the note in itself) to share amongst the notes
---@class Measure : EntityContainer
---@field limitLine number
---@field noteIcon Image
---@field lowestNote string
---@field wrongNoteIcon Image
---@field notes CircularQueue
---@field baseLine number
---@field noteHeight number
local Measure = EntityContainer:extend()

function Measure:new(container, options)
    EntityContainer.new(self, container, options)
    self.height = options.height or love.graphics.getHeight()
    self.noteHeight = self.height / 12
    self.y = options.y or 0
    self.x = options.x or 0
    self.baseLine  = options.baseLine or self.y + self.noteHeight * 4
    local font = assets.fonts.Icons(self.noteHeight * self.keyData.height)
    self.image = love.graphics.newText(font, assets.IconName[self.keyData.icon])
    self.color =  options.color or Theme.font
    self.limitLine = self.height / 2
    self.lowestNote = lume.find(assets.NoteName, self.keyData.lowestNote)
    font = assets.fonts.Icons(self.noteHeight * Vars.note.height)
    self.noteIcon =  love.graphics.newText(font, assets.IconName.QuarterNote)
    self.wrongNoteIcon = love.graphics.newText(font, assets.IconName.GhostNote)
    self.noteChoice = 1
    self.notes = CircularQueue(function()
        local note = Note(self, {
            note = 'C4',
            x = math.huge
        })
        note.isDead = true
        return note
    end, 20)
end

--- Removes the first note of the
--- list
---@return Note
function Measure:removeNextNote()
    return self.notes:shift()
end

--- Checks if the given answer is the same
--- as the note currently selected by the measure
---@param answer string
---@return boolean
function Measure:isAnswerCorrect(answer)
    local currentNote = self:currentNote()
    if not currentNote then return false end
    return currentNote.note:sub(1, 1) == answer:sub(1, 1)
end

--- Fade all the notes
--- to use when the game is finished
function Measure:fadeAwayNotes()
    while not self.notes:isEmpty() do
        self.notes:shift():fadeAway()
    end
end

--- Creates a random note object, and adds
--- it at the end of the notes list
---@return Note
function Measure:generateRandomNote()
    return self:insertEntity(self.notes:push(function(ent)
        ent.container = self
       return ent:reset(self:getRandomNote(), love.graphics.getWidth())
    end))
end

--- Generates a random note from the possible choices
---@return string
function Measure:getRandomNote()
    --self.noteChoice = (self.noteChoice % #self.keyData.difficulties[Config.difficulty]) + 1
    --return self.keyData.difficulties[Config.difficulty][self.noteChoice]
    return lume.randomchoice(self.keyData.difficulties[Config.difficulty])
end

--- Access to the next note to choose from
---@return Note
function Measure:currentNote()
    return self.notes:peek()
end

--- Get the distance the notes must move from right
--- to left after an update
---@return number
function Measure:getMove()
    return self.container:getMove()
end

--- Gets the index of the note relative to the
--- measures lowest note
---@param note string
---@return number
function Measure:indexOf(note)
    local index = lume.find(assets.NoteName, note)
    if index < self.lowestNote then return 0 end
    return index - self.lowestNote
end

--- Inherited method
function Measure:draw()
    love.graphics.setColor(self.color)

    -- Drawing the lines
    local yStart = self.baseLine
    local yPos = yStart
    local width = love.graphics.getWidth()
    love.graphics.setLineWidth(1)
    for _ = 1, 5 do
        love.graphics.line(0 , yPos, width, yPos)
        yPos = yPos + self.noteHeight
    end
    love.graphics.line( self.limitLine - 1, yStart, self.limitLine - 1, yPos - self.noteHeight)


    -- Drawing the key
    love.graphics.draw(self.image, self.x + 5, self.y + self.keyData.yOrigin * self.noteHeight)

    love.graphics.setShader(assets.shaders.noteFade)
    EntityContainer.draw(self)
    love.graphics.setShader()
end

--- Get full note name, to show when
--- the note is incorrect
---@param noteName string
---@return string
function Measure:getNoteName(noteName)
    local sub = noteName:sub(1, 1)
    if Config.noteStyle == 'englishNotes' then return sub end
    local idx = lume.find(Vars.englishNotes, sub)
    if not idx then return sub end
    return Vars[Config.noteStyle][idx]
end

--- Gets the positions of the note relative to this
--- measure, in order for it to draw to the correct position
---@param measureIndex number
---@return number y position
function Measure:getNotePosition(measureIndex)
    local base = self.baseLine + self.noteHeight * 7
    return base - (measureIndex) * (self.noteHeight / 2)
end

--- Inherited method
function Measure:dispose()
    self.notes = nil
    EntityContainer.dispose(self)
end

return Measure