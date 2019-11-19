
local DialogState = require('src.states.DialogState')
local UIFactory = require('src.utils.UIFactory')
local Theme = require('src.utils.Theme')
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
    local text = love.graphics.newText(assets.MarckScript(Vars.titleSize), tr('Paused'))
    local dialogMiddle = (love.graphics.getWidth() - self.margin * 2) / 2
    local middle = dialogMiddle - text:getWidth() / 2
    local yStart = 100
    local padding = 10
    self:transition({
        {
            element = UIFactory.createTitle(self, {
                text = text,
                y = -Vars.titleSize,
                x = middle,
                color = Theme.transparent:clone()
            }),
            target = {y = 20, color = Theme.font}
        },
        {
            element = UIFactory.createTextButton(self, {
                text = 'Resume',
                icon = 'Play',
                x = dialogMiddle,
                centerText = true,
                padding = padding,
                framed = true,
                y = -Vars.titleSize,
                fontSize = Vars.mobileButton.fontSize,
                color = Theme.transparent:clone(),
                callback = function(btn)
                    self:slideOut()
                end
            }),
            target = {y = yStart, color = Theme.font}
        },
        {
            element = UIFactory.createTextButton(self, {
                text= 'Menu',
                icon = 'Home',
                x = dialogMiddle,
                centerText = true,
                framed = true,
                y = -Vars.titleSize,
                fontSize = Vars.mobileButton.fontSize,
                padding = padding,
                color = Theme.transparent:clone(),
                callback = function()
                    -- Transition ?
                    ScreenManager.switch('MenuState')
                end
            }),
            target = {y = yStart + Vars.mobileButton.fontSize * 2 + padding * 10, color = Theme.font}
        },
        {
            element = UIFactory.createTextButton(self, {
                text = 'Restart',
                icon = 'Reload',
                x = dialogMiddle,
                centerText = true,
                framed = true,
                y = -Vars.titleSize,
                fontSize = Vars.mobileButton.fontSize,
                padding = padding,
                color = Theme.transparent:clone(),
                callback = function()
                    -- Transition ?
                    ScreenManager.push('CircleCloseState', 'open', 'GamePrepareState')
                end
            }),
            target = {y = yStart + Vars.mobileButton.fontSize + padding * 5, color = Theme.font}
        }
    })
    DialogState.init(self)
end

return PauseState