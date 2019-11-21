
local ScreenManager = require('lib.ScreenManager')
local EventTransmitter = {}

local events = {
    'keypressed', 'keyreleased',
    'mousemoved', 'mousepressed', 'mousereleased',
    'touchmoved', 'touchpressed', 'touchreleased'
}

function EventTransmitter.transmitEvents(state)
    for _, ev in ipairs(events) do
        local base = state[ev] or function() end
        state[ev] = function(tbl, ...)
            if not base(tbl, ...) then
                local first = ScreenManager:first()
                first[ev](first, ...)
            end
        end
    end
end



return EventTransmitter