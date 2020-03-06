
local ScreenManager = require('lib.ScreenManager')

--- Utility class to modify a class to redirect
--- all events of a class when they are not processed
--- by the class itself
local EventTransmitter = {}

local events = {
    'keypressed', 'keyreleased',
    'mousemoved', 'mousepressed', 'mousereleased',
    'touchmoved', 'touchpressed', 'touchreleased'
}

--- Transmits all the events of the given class
--- when the given event returns false, calls
--- the function of the screenManager's first state
---@param state table
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