
local Color = require('src.utils.Color')

local Graphics = {}

function Graphics.drawMusicBars()

    local middle = assets.config.baseLine

    love.graphics.setLineWidth(1)
    love.graphics.setColor(Color.black)
    love.graphics.line(assets.config.limitLine, 0, assets.config.limitLine, love.graphics.getHeight())
    for i = 1,5 do
        local ypos = middle + assets.config.lineHeight * i
        love.graphics.line(0, ypos, love.graphics.getWidth(), ypos)
    end
end

return Graphics