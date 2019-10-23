local BaseState = require('src.states.BaseState')

---@class CreditsState : State
local CreditsState = BaseState:extend()

function CreditsState:init()
    self:createUI({
        {}, {
            {text = 'created_by_azarias'},
            {text = 'with_love2d'},
            {text = 'and_many_libs'}
        }
    })
end


return CreditsState