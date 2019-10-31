
local Theme = require('src.utils.Theme')

local Graphics = {}

function Graphics.drawMusicBars()

    local middle = assets.config.baseLine

    love.graphics.setLineWidth(1)
    love.graphics.setColor(Theme.font)
    love.graphics.line(assets.config.limitLine, middle + assets.config.lineHeight, assets.config.limitLine, middle + assets.config.lineHeight * 5)
    for i = 1,5 do
        local ypos = middle + assets.config.lineHeight * i
        love.graphics.line(0, ypos, love.graphics.getWidth(), ypos)
    end
end

return Graphics