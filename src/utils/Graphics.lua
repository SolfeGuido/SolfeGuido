
local Theme = require('src.utils.Theme')

--- All the graphics related functions
local Graphics = {}

--- Draws the default music bars
--- used by the menus, must not be used by the measures
--- as the height and position of the music bars is hard coded
--- which is not suitable for the measures
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