
local Entity = require('src.entity')

local Config = require('src.Config')

--- Class used to represent the different possible keys in a music sheet (F, G for now)
---@class Key : Entity
---@field private config table
---@field private image any
local Key = Entity:extend()


function Key:new(area, config, keyData)
    Entity.new(self, area, config)
    self.keyData = keyData
    self.image = assets.images[self.keyData.image]
    self.color = {0, 0, 0, 0}
    self.x = -self.image:getWidth()
    self.y = self.keyData.y
end

function Key:draw()
    local imgHeigh = self.image:getHeight()
    local scale = self.keyData.height / imgHeigh
    local base = self.area:getBaseLine()
    love.graphics.setColor(self.color)
    love.graphics.draw(self.image, self.x, base - self.y, 0 , scale , scale, self.keyData.xOrigin, self.keyData.yOrigin)
end

---@param note number
---@param key string
---@return boolean
function Key:isCorrect(note, key)
    note = ((note + self.keyData.lowestNote) % 7) + 1
    return assets.config.letterOrder[note] == key
end

---@param note number
---@return string
function Key:getNoteName(note)
    --depending on user config, return 'a' style or 'do' style
    note = ((note + self.keyData.lowestNote) % 7) + 1
    return assets.config[Config.noteStyle == 'it' and 'itNotes' or 'enNotes'][note]
end

return Key