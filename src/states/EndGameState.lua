
-- LIBS
local DialogState = require('src.states.DialogState')
local ScreenManager = require('lib.ScreenManager')

---@class EndGameState : State
local EndGameState = DialogState:extend()


function EndGameState:new()
    DialogState.new(self)
end

function EndGameState:validate()
    ScreenManager.switch('PlayState')
end

function EndGameState:slideOut()
    ScreenManager.switch('RootState')
end

function EndGameState:init(score)
    self:createUI({
        {{
                type = 'TextButton',
                text = 'Menu',
                state = 'RootState',
                centered = true,
                x = -math.huge
            }
        }
    })
    DialogState.init(self, {title = 'Score : ' .. tostring(score), validate = 'Restart'})
end

return EndGameState