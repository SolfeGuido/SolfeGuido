local Entity = require('src.Entity')
local Config = require('src.utils.Config')

---@class Measure : Entity
local Measure = Entity:extend()

function Measure:new(area, options)
    Entity.new(self, area, options)
    self.height = options.height or love.graphics.getHeight()
    self.noteHeight = self.height / 12
    self.baseLine  = options.baseLine or 0
    self.y = options.y or 0
    self.x = options.x or 0
    self.image = assets.images[self.keyData.image]
    self.color = {0, 0, 0, 0}
end

function Measure:draw()
    love.graphics.setColor(self.color)

    -- Drawing the lines
    local yStart = self.y + self.noteHeight * 4
    local yPos = yStart
    local width = love.graphics.getWidth()
    love.graphics.setLineWidth(1)
    for i = 1, 5 do
        love.graphics.line(0 , yPos, width, yPos)
        yPos = yPos + self.noteHeight
    end
    local diff = yPos - yStart
    love.graphics.line( diff, yStart, diff, yPos - self.noteHeight)


    -- Drawing the key
    local localScale = self.noteHeight / assets.config.lineHeight
    local imgHeigh = self.image:getHeight()
    local scale = (self.keyData.height / imgHeigh) * localScale
    local xPos = self.x + self.image:getWidth() * scale
    love.graphics.draw(self.image, xPos, self.y + (self.noteHeight * (4 + self.keyData.line)), 0 , scale , scale, self.keyData.xOrigin, self.keyData.yOrigin)
end

---@param expected number
---@param actual string
---@return boolean
function Measure:isCorrect(expected, actual)
    local note = ((expected + self.keyData.lowestNote) % 7) + 1
    return note == actual
end

---@param note number
---@return string
function Measure:getNoteName(note)
    note = ((note + self.keyData.lowestNote) % 7) + 1
    return assets.config[Config.noteStyle == 'it' and 'itNotes' or 'enNotes'][note]
end

function Measure:getRandomNote()
    return math.random(unpack(self.keyData.difficulties[Config.difficulty]))

end

function Measure:getSoundFor(note)
    local noteName = assets.config.notes[(self.keyData.firstNote or 0) + (note or 0) + 1]
    return assets.sounds.notes[noteName]
end


return Measure