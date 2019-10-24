
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
                statePush = 'PlaySelectState'
            },
            {
                type = 'TextButton',
                text = 'Zen',
                statePush = 'PlaySelectState'
            },
            {
                type = 'TextButton',
                text = 'Interval earing',
                statePush = 'PlaySelectState'
            }
        }
    })
end

return MenuState