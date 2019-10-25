
-- LIBS
local BaseState = require('src.states.BaseState')

---@class MenuState : State
local MenuState = BaseState:extend()

function MenuState:new()
    MenuState.super.new(self)
end

function MenuState:init(...)
    self:createUI({
        {},{
            {
                type = 'TextButton',
                text = 'Timed',
                statePush = 'PlaySelectState',
                statePushArgs = {timed = true}
            },
            {
                type = 'TextButton',
                text = 'Zen',
                statePush = 'PlaySelectState',
                statePushArgs = {timed = false}
            }
        }
    })
end

return MenuState