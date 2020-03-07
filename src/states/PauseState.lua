
local DialogState = require('src.states.DialogState')
local UIFactory = require('src.utils.UIFactory')
local Theme = require('src.utils.Theme')
local ScreenManager = require('lib.ScreenManager')

--- State shown when the user pauses the game
---@class PauseState : DialogState
local PauseState = DialogState:extend()

--- Constructor
function PauseState:new()
    DialogState.new(self)
    self:setWidth(Vars.titleSize * 6)
end

--- When the user clicks play
function PauseState:validate()
    self:slideOut()
end

--- Creates all the widgets
function PauseState:init()
    local text = love.graphics.newText(assets.fonts.MarckScript(Vars.titleSize), tr('Paused'))
    local dialogMiddle = (love.graphics.getWidth() - self.margin * 2) / 2
    local middle = dialogMiddle - text:getWidth() / 2
    local yStart = 60
    local padding = 10
    self:transition({
        {
            element = UIFactory.createTitle(self, {
                text = text,
                y = 2,
                x = middle,
                color = Theme.transparent:clone()
            }),
            target = {color = Theme.font}
        },
        {
            element = UIFactory.createTextButton(self, {
                text = 'Resume',
                fontName = 'Oswald',
                icon = 'Play',
                x = dialogMiddle,
                centerText = true,
                padding = padding,
                framed = true,
                y = yStart,
                fontSize = Vars.mobileButton.fontSize,
                color = Theme.transparent:clone(),
                callback = function()
                    self:slideOut()
                end
            }),
            target = {color = Theme.font}
        },
        {
            element = UIFactory.createTextButton(self, {
                text = 'Restart',
                fontName = 'Oswald',
                fontSize = Vars.mobileButton.fontSize,
                icon = 'Reload',
                x = dialogMiddle,
                centerText = true,
                framed = true,
                y = yStart + Vars.mobileButton.fontSize + padding * 4,
                padding = padding,
                color = Theme.transparent:clone(),
                callback = function()
                    ScreenManager.push('CircleCloseState', 'open', 'GamePrepareState')
                end
            }),
            target = {color = Theme.font}
        },
        {
            element = UIFactory.createTextButton(self, {
                text= 'Menu',
                fontName = 'Oswald',
                icon = 'Home',
                x = dialogMiddle,
                centerText = true,
                framed = true,
                y = yStart + Vars.mobileButton.fontSize * 2 + padding * 8,
                fontSize = Vars.mobileButton.fontSize,
                padding = padding,
                color = Theme.transparent:clone(),
                callback = function()
                    -- Transition ?
                    ScreenManager.switch('MenuState')
                end
            }),
            target = {color = Theme.font}
        }
    })
    self.height =  yStart + Vars.mobileButton.fontSize * 6 + padding * 6
    DialogState.init(self)
end

return PauseState