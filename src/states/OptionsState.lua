local State = require('src.states.State')
local Graphics = require('src.Graphics')

---@class OptionsState : State
local OptionsState = State:extend()


function OptionsState:new()
    State.new(self)
end

function OptionsState:draw()
    State.draw(self)
    Graphics.drawMusicBars()
end

function OptionsState:init(...)
    
end

function OptionsState:update(dt)
    State.update(self, dt)
end

return OptionsState