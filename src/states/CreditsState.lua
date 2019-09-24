local State = require('src.states.State')
local Graphics = require('src.Graphics')

---@class CreditsState : State
local CreditsState = State:extend()


function CreditsState:new()
    State.new(self)
end

function CreditsState:draw()
    State.draw(self)
    Graphics.drawMusicBars()
end

function CreditsState:update(dt)
    State.update(self, dt)
end

return CreditsState