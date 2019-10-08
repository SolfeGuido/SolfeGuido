

local AbstractButton = require('src.objects.AbstractButton')

---@class MobileButton : AbstractButton
local MobileButton = AbstractButton:extend()

function MobileButton:new(area, options)
    AbstractButton.new(self, area, options)
end

function MobileButton:draw()
    love.graphics.push()
    love.graphics.translate(self.x, self.y)
    local box = self:boundingBox()
    love.graphics.setColor(assets.config.color.black())
    love.graphics.rectangle('line', 0, 0, box.width, box.height)
    love.graphics.draw(self.text, 0, 0)

    love.graphics.pop()
end

return MobileButton