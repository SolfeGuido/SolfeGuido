
local DialogSate = require('src.states.DialogState')
local ScreenManager = require('lib.ScreenManager')

---@class PlaySelectState : State
local PlaySelectState = DialogSate:extend()


function PlaySelectState:new()
    DialogSate.new(self)
end

function PlaySelectState:init(config)
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
            }, {
                text = 'Play',
                type = 'TextButton',
                centered = true,
                framed = true,
                x = -math.huge,
                y = love.graphics.getHeight() - assets.config.titleSize * 2,
                image = assets.images.right,
                callback = function()
                    ScreenManager.switch('PlayState', config)
                end
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
    DialogSate.init(self)
end

return PlaySelectState