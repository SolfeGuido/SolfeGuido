
local DialogSate = require('src.states.DialogState')
local ScreenManager = require('lib.ScreenManager')

---@class PlaySelectState : State
local PlaySelectState = DialogSate:extend()


function PlaySelectState:new()
    DialogSate.new(self)
end

function PlaySelectState:validate()
    ScreenManager.switch('PlayState', self.config)
end

function PlaySelectState:init(config)
    self.config = config
    local UI = {
            {
                text = 'Key',
                type = 'MultiSelector',
                config = 'keySelect',
                centered = true,
                x = -math.huge
            },
            {
                text = 'Difficulty',
                type = 'MultiSelector',
                config = 'difficulty',
                centered = true,
                x = -math.huge
            }
        }

    if config.timed then
        UI[#UI+1] = {
            text = 'Time',
            type = 'MultiSelector',
            config = 'time',
            centered = true,
            x = -math.huge
        }
    end

    self:createUI({UI}, self.margin)
    DialogSate.init(self, {title = 'Play', validate = 'Play'})
end

return PlaySelectState