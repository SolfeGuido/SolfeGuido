
local Theme = require('src.utils.Theme')

local Graphics = {}

function Graphics.drawMusicBars()

    local middle = Vars.baseLine

    love.graphics.setLineWidth(1)
    love.graphics.setColor(Theme.font)
    love.graphics.line(Vars.limitLine, middle + Vars.lineHeight, Vars.limitLine, middle + Vars.lineHeight * 5)
    for i = 1,5 do
        local ypos = middle + Vars.lineHeight * i
        love.graphics.line(0, ypos, love.graphics.getWidth(), ypos)
    end
end

return Graphics