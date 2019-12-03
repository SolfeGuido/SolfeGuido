
-- LIBS
local DialogState = require('src.states.DialogState')
local ScreenManager = require('lib.ScreenManager')
local Theme = require('src.utils.Theme')
local UIFactory = require('src.utils.UIFactory')

---@class EndGameState : State
local EndGameState = DialogState:extend()


function EndGameState:new()
    DialogState.new(self)
    self:setWidth(Vars.titleSize * 10)
end

function EndGameState:validate()
    ScreenManager.switch('PlayState')
end

function EndGameState:slideOut()
    ScreenManager.switch('MenuState')
end

function EndGameState:init(score, best)
    local title = best and 'Best Score' or 'Score'
    local text = love.graphics.newText(assets.fonts.MarckScript(Vars.titleSize), tr(title) .. ' : ' .. tostring(score))
    local dialogMiddle = (love.graphics.getWidth() - self.margin * 2) / 2
    local middle = dialogMiddle - text:getWidth() / 2
    local yStart = 85
    local padding = 10
    self:transition({
        {
            element = UIFactory.createTitle(self, {
                text = text,
                y = -Vars.titleSize,
                x = middle,
                color = Theme.transparent:clone()
            }),
            target = {y = 5, color = Theme.font}
        },
        {
            element = UIFactory.createTextButton(self, {
                text = 'Restart',
                icon = 'Reload',
                x = dialogMiddle,
                centerText = true,
                padding = padding,
                framed = true,
                y = -Vars.titleSize,
                fontSize = Vars.mobileButton.fontSize,
                color = Theme.transparent:clone(),
                callback = function()
                    ScreenManager.push('CircleCloseState', 'open', 'GamePrepareState')
                end
            }),
            target = {y = yStart + Vars.mobileButton.fontSize + padding * 5, color = Theme.font}
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
                text = 'Scores',
                icon = 'List',
                x = dialogMiddle,
                centerText = true,
                framed = true,
                y = -Vars.titleSize,
                fontSize = Vars.mobileButton.fontSize,
                padding = padding,
                color = Theme.transparent:clone(),
                callback = function()
                    -- Transition ?
                    ScreenManager.switch('ScoreState')
                end
            }),
            target = {y = yStart, color = Theme.font}
        }
    })
    self.height =  yStart + Vars.mobileButton.fontSize * 6 + padding * 7
    DialogState.init(self)
end

return EndGameState