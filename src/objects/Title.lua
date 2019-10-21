
local Entity = require('src.Entity')

local Title = Entity:extend()


function Title:new(area, options)
    Entity.new(self, area, options)
end

function Title:dispose()
    self.text:release()
    Title.super.dispose(self)
end

function Title:draw()
    love.graphics.setColor(self.color)
    love.graphics.draw(self.text, self.x, self.y)
end

function Title:width()
    return self.text:getWidth()
end

function Title:height()
    return self.text:getHeight()
end

return Title