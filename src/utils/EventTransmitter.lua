
local ScreenManager = require('lib.ScreenManager')
local State = require('src.State')

local EventTransmitter = {}

local events = {
    'keypressed', 'keyreleased',
    'mousemoved', 'mousepressed', 'mousereleased',
    'touchmoved', 'touchpressed', 'touchreleased'
}

function EventTransmitter.transmitEvents(state)
    for _, ev in ipairs(events) do
        state[ev] = function(tbl, ...)
            if not State[ev](tbl, ...) then
                local first = ScreenManager:first()
                first[ev](first, ...)
            end
        end
    end
end



return EventTransmitter