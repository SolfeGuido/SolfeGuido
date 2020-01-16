local Entity = require('src.Entity')
local Config = require('src.data.Config')
local Theme = require('src.utils.Theme')
local lume = require('lib.lume')

---@class Measure : Entity
local Measure = Entity:extend()

function Measure:new(area, options)
    Entity.new(self, area, options)
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
end

function Measure:indexOf(note)
    local index = lume.find(assets.NoteName, note)
    if index < self.lowestNote then return 0 end
    return index - self.lowestNote
end

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
end

---@param expected string
---@param actual string
---@return boolean
function Measure:isCorrect(expected, actual)
    return expected:sub(1, 1) == actual:sub(1, 1)
end

---@param noteName string
---@return string
function Measure:getNoteName(noteName)
    local sub = noteName:sub(1, 1)
    if Config.noteStyle == 'englishNotes' then return sub end
    local idx = lume.find(Vars.englishNotes, sub)
    if not idx then return sub end
    return Vars[Config.noteStyle][idx]
end

---@param measureIndex number
---@return number y position
function Measure:getNotePosition(measureIndex)
    local base = self.baseLine + self.noteHeight * 7
    return base - (measureIndex) * (self.noteHeight / 2)
end

function Measure:getRequiredNotes()
    return self.keyData.difficulties[Config.difficulty]
end

function Measure:getRandomNote()
    --self.noteChoice = (self.noteChoice % #self.keyData.difficulties[Config.difficulty]) + 1
    --return self.keyData.difficulties[Config.difficulty][self.noteChoice]
    return lume.randomchoice(self.keyData.difficulties[Config.difficulty])

end

return Measure