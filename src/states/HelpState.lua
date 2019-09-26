
-- LIBS
local State = require('src.states.State')
local Graphics = require('src.Graphics')


---@class HelpState : State
local HelpState = State:extend()


function HelpState:new()
    State.new(self)
end

function HelpState:draw()
    State.draw(self)
    Graphics.drawMusicBars()
end

function HelpState:update(dt)
    State.update(self, dt)
end

return HelpState