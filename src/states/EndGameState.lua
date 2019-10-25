
-- LIBS
local DialogState = require('src.states.DialogState')


---@class EndGameState : State
local EndGameState = DialogState:extend()


function EndGameState:new()
    DialogState.new(self)
end

function EndGameState:init(score)
    self:createUI({
        {
            {
                type = 'TextButton',
                text = 'Restart',
                state = 'PlayState',
                centered = true,
                x = -math.huge
            }, {
                type = 'TextButton',
                text = 'Score',
                state = 'RootState',
                centered = true,
                x = -math.huge
            }, {
                type = 'TextButton',
                text = 'Menu',
                state = 'RootState',
                centered = true,
                x = -math.huge
            }
        }
    })
    DialogState.init(self, 'Score : ' .. tostring(score))
end

return EndGameState