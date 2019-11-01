
local DialogState = require('src.states.DialogState')
local ScreenManager = require('lib.ScreenManager')


---@class PauseState : State
local PauseState = DialogState:extend()


function PauseState:new()
    DialogState.new(self)
end

function PauseState:validate()
    self:slideOut()
end

function PauseState:init(...)
    self:createUI({
        {{
                type = 'TextButton',
                text = 'Exit',
                state = 'RootState',
                centered = true,
                x = -math.huge
            }
        }
    })
    DialogState.init(self, {title = 'Pause', validate = 'Resume'})
end

return PauseState