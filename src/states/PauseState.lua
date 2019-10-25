
local DialogState = require('src.states.DialogState')
local ScreenManager = require('lib.ScreenManager')


---@class PauseState : State
local PauseState = DialogState:extend()


function PauseState:new()
    DialogState.new(self)
end

function PauseState:init(...)
    self:createUI({
        {
            {
                type = 'TextButton',
                text = 'Resume',
                callback = function() self:slideOut() end,
                centered = true,
                x = -math.huge
            }, {
                type = 'TextButton',
                text = 'Exit',
                state = 'RootState',
                centered = true,
                x = -math.huge
            }
        }
    })
    DialogState.init(self,"Pause")
end

return PauseState