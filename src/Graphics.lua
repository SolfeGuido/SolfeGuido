

local Graphics = {}

function Graphics.drawMusicBars()

    local middle = love.graphics.getHeight() / 3

    love.graphics.setLineWidth(1)
    love.graphics.setColor(assets.config.color.black())
    love.graphics.line(assets.config.limitLine, 0, assets.config.limitLine, love.graphics.getHeight())
    for i = 1,5 do
        local ypos = middle + assets.config.lineHeight * i
        love.graphics.line(0, ypos, love.graphics.getWidth(), ypos)
    end
end

return Graphics