
--- LIBS
local DialogState = require('src.states.DialogState')
local Theme = require('src.utils.Theme')
local ScreenManager = require('lib.ScreenManager')
local Config = require('src.utils.Config')

--- Entities
local IconButton = require('src.objects.IconButton')

---@class OptionsState : State
local OptionsState = DialogState:extend()

function OptionsState:new()
    DialogState.new(self)
end

function OptionsState:slideOut()
    self:slideEntitiesOut()
    self.timer:tween(assets.config.transition.tween, self, {yBottom = 0}, 'out-expo',function()
        ScreenManager.pop()
        ScreenManager.first().settingsButton.consumed = false
    end)
end


function OptionsState:init(...)
    self:transition({
        {
            element = self:addentity(IconButton, {
                icon = Config.sound == 'on' and assets.IconName.VolumeOn or assets.IconName.VolumeOff,
                x = self.margin,
                y = - assets.config.titleSize,
                width = assets.config.titleSize,
                color = Theme.transparent:clone(),
                callback = function(btn)
                    btn.consumed = false
                    Config.update('sound', Config.sound == 'on' and 'off' or 'on')
                    btn:setIcon(Config.sound == 'on' and assets.IconName.VolumeOn or assets.IconName.VolumeOff)
                end
            }),
            target = {y = 0, color = Theme.font}
            }
        }
    )
    self:createUI({
        {
            {
                text = 'Notes',
                type = 'MultiSelector',
                config = 'noteStyle',
                centered = true,
                x = -math.huge
            },
            {
                text = 'Language',
                type = 'MultiSelector',
                config = 'lang',
                centered = true,
                x = -math.huge
            },
            {
                text = 'Answer',
                type = 'MultiSelector',
                config = 'answerType',
                platform = 'desktop',
                centered = true,
                x = -math.huge
            },
            {
                text = 'Vibrate',
                type = 'MultiSelector',
                config = 'vibrations',
                platform = 'mobile',
                centered = true,
                x = -math.huge
            }
        }
    }, self.margin)
    DialogState.init(self, "Options")
end

return OptionsState