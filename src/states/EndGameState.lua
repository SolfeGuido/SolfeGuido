
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
    local title = best and 'best_score' or 'score'
    local text = love.graphics.newText(assets.fonts.MarckScript(Vars.titleSize), tr(title, {score = score}))
    local dialogMiddle = (love.graphics.getWidth() - self.margin * 2) / 2
    local middle = dialogMiddle - text:getWidth() / 2
    local yStart = 50
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
                text = 'Restart',
                icon = 'Reload',
                fontName = 'Oswald',
                x = dialogMiddle,
                centerText = true,
                padding = padding,
                framed = true,
                y = yStart + Vars.mobileButton.fontSize + padding * 4,
                fontSize = Vars.mobileButton.fontSize,
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
        },
        {
            element = UIFactory.createTextButton(self, {
                text = 'Scores',
                icon = 'List',
                fontName = 'Oswald',
                x = dialogMiddle,
                centerText = true,
                framed = true,
                y = yStart,
                fontSize = Vars.mobileButton.fontSize,
                padding = padding,
                color = Theme.transparent:clone(),
                callback = function()
                    -- Transition ?
                    ScreenManager.switch('ScoreboardState')
                end
            }),
            target = {color = Theme.font}
        }
    })
    self.height =  yStart + Vars.mobileButton.fontSize * 6 + padding * 6
    DialogState.init(self)
end

return EndGameState