local State = require('src.State')

---@class CreditsState : State
local CreditsState = State:extend()

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