
local Entity = require('src.entity')

--- Class used to represent the different possible keys in a music sheet (F, G for now)
---@class Key : Object
---@field private config table
---@field private image love.image
local Key = Entity:extend()


function Key:new(area, id, config)
    Entity.new(self, area, id, config)
    self.config = config
    self.image = assets.images[self.config.image]
end

function Key:draw()
    local imgHeigh = self.image:getHeight()
    local scale = self.config.height / imgHeigh
    local base = self.area:getBaseLine()
    love.graphics.draw(self.image, self.xPosition, base - self.yPosition, 0 , scale , scale, self.xOrigin, self.yOrigin)
end

---@param note number
---@param key string
---@return boolean
function Key:isCorrect(note, key)
    note = ((note + self.config.lowestNote) % 7) + 1
    return assets.config.letterOrder[note] == key
end

return Key