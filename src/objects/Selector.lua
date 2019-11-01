
local Entity = require('src.Entity')
local Theme = require('src.utils.Theme')

local Selector = Entity:extend()

function Selector:new(area, options)
    Entity.new(self, area, options)
    self.color = Theme.clicked:clone()
    local font = assets.IconsFont(Vars.selectorSize)
    self.image = love.graphics.newText(font, options.icon or assets.IconName.WholeNote)
    self.padding = (Vars.lineHeight - Vars.selectorSize) / 2
end


function Selector:draw()
    if self.visible then
        love.graphics.setColor(self.color)
    else
        local r,g,b = unpack(Theme.font.rgb)
        love.graphics.setColor(r, g, b, 0.3)
    end
    love.graphics.draw(self.image, self.x, self.y + self.padding)
end


return Selector