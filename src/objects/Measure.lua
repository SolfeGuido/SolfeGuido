local Entity = require('src.Entity')
local Config = require('src.utils.Config')
local Color = require('src.utils.Color')
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
    self.image = assets.images[self.keyData.image]
    self.color =  options.color or Color.black
    self.limitLine = self.height / 2
    self.lowestNote = lume.find(assets.NoteName, self.keyData.lowestNote)
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
    for i = 1, 5 do
        love.graphics.line(0 , yPos, width, yPos)
        yPos = yPos + self.noteHeight
    end
    love.graphics.line( self.limitLine - 1, yStart, self.limitLine - 1, yPos - self.noteHeight)


    -- Drawing the key
    local localScale = self.noteHeight / assets.config.lineHeight
    local imgHeigh = self.image:getHeight()
    local scale = (self.keyData.height / imgHeigh) * localScale
    local xPos = self.x + self.image:getWidth() * scale
    love.graphics.draw(self.image, xPos, self.y + (self.noteHeight * (4 + self.keyData.line)), 0 , scale , scale, self.keyData.xOrigin, self.keyData.yOrigin)
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
    local idx = lume.find(assets.config.englishNotes, sub)
    if not idx then return sub end
    return assets.config.romanNotes[idx]
end

---@param measureIndex number
---@return number y position
function Measure:getNotePosition(measureIndex)
    local base = self.baseLine + self.noteHeight * 7
    return math.floor(base - (measureIndex) * (self.noteHeight / 2))
end

function Measure:getRandomNote()
    return lume.randomchoice(self.keyData.difficulties[Config.difficulty])

end

return Measure