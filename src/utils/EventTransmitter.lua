
local Class = require('lib.class')
local ScreenManager = require('lib.ScreenManager')

local EventTransmitter = {}

local events = {
    'keypressed', 'keyreleased',
    'mousemoved', 'mousepressed', 'mousereleased',
    'touchmoved', 'touchpressed', 'touchreleased'
}

for _, ev in ipairs(events) do
    EventTransmitter[ev] = function(...) ScreenManager.publish(ev, ...) end
end

return EventTransmitter