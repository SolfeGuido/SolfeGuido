
local Entity = require('src.entity')

---@class Button
local Button = Entity:extend()

function Button:new(area, id, config)
    Entity.new(self, area, id, config)
    self.color = {0,0,0,0}
end

function Button:draw()
    love.graphics.setColor(unpack(self.color))
    love.graphics.draw(self.text, self.x + 5, self.y)
end

function Button:update(dt)

end




return Button