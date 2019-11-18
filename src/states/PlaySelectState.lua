
local DialogSate = require('src.states.DialogState')
local ScreenManager = require('lib.ScreenManager')
local UIFactory = require('src.utils.UIFactory')
local Theme = require('src.utils.Theme')
local Config = require('src.utils.Config')

---@class PlaySelectState : State
local PlaySelectState = DialogSate:extend()


function PlaySelectState:new()
    DialogSate.new(self)
    self.keyButtons = {}
    self.timeButtons  = {}
    self.difficultyButtons = {}
end

function PlaySelectState:validate()
    ScreenManager.switch('GamePrepareState')
end

local keyIcons = {
    gKey = 'GKey',
    fKey = 'FKey',
    both = 'BothKeys'
}

function PlaySelectState:addKeyRadioButtons(elements, ypos)
    local buttonSize = Vars.titleSize
    local space = love.graphics.getWidth() - self:getMargin() * 2 - (buttonSize + 10) * #Vars.userPreferences.keySelect
    local startSpace = space / 3
    local betweenSpace = space / 6

    for i, v in ipairs(Vars.userPreferences.keySelect) do
        elements[#elements+1] = {
            element = UIFactory.createRadioButton(self, {
                icon = keyIcons[v],
                y = ypos,
                x = startSpace + (buttonSize + betweenSpace) * (i-1),
                size = buttonSize,
                padding = 5,
                width = Vars.titleSize * 1.5,
                isChecked = Config.keySelect == v,
                centerImage = true,
                name = 'keyButtons',
                framed = true,
                callback = function(btn)
                    Config.update('keySelect', v)
                    btn.consumed = false
                    for _,radio in ipairs(self.keyButtons) do
                        if radio == btn then
                            radio:check()
                        else
                            radio:uncheck()
                        end
                    end
                end
            }),
            target = {color = Theme.font}
        }
    end
end

function PlaySelectState:addLevelRadioButtons(elements, ypos)
    local config = Vars.userPreferences.time
    local buttonSize = Vars.mobileButton.fontSize
    local space = love.graphics.getWidth() - self:getMargin() * 2 - (buttonSize + 10) * #config
    local startSpace = space / (#config + 1)
    local betweenSpace = startSpace

    for i, v in ipairs(config) do
        elements[#elements+1] = {
            element = UIFactory.createRadioButton(self, {
                text = v,
                y = ypos,
                x = startSpace + (buttonSize + betweenSpace) * (i-1),
                size = buttonSize,
                padding = 5,
                width = Vars.titleSize * 1.5,
                isChecked = Config.time == v,
                centerImage = true,
                name = 'timeButtons',
                framed = true,
                callback = function(btn)
                    Config.update('time', v)
                    btn.consumed = false
                    for _,radio in ipairs(self.timeButtons) do
                        if radio == btn then
                            radio:check()
                        else
                            radio:uncheck()
                        end
                    end
                end
            }),
            target = {color = Theme.font}
        }
    end
end

function PlaySelectState:addTimeRadioButtons(elements, ypos)
    local config = Vars.userPreferences.difficulty
    local padding = 2
    local buttonSize = 20
    local space = love.graphics.getWidth() - self:getMargin() * 2 - (buttonSize + padding * 2) * #config
    local startSpace = space / (#config + 1)
    local betweenSpace = startSpace

    for i, v in ipairs(config) do
        elements[#elements+1] = {
            element = UIFactory.createRadioButton(self, {
                text = v,
                y = ypos,
                x = startSpace + (buttonSize + betweenSpace) * (i-1),
                size = buttonSize,
                padding = padding,
                width = Vars.titleSize,
                isChecked = Config.difficulty == v,
                centerImage = true,
                name = 'difficultyButtons',
                framed = true,
                callback = function(btn)
                    Config.update('difficulty', v)
                    btn.consumed = false
                    for _,radio in ipairs(self.difficultyButtons) do
                        if radio == btn then
                            radio:check()
                        else
                            radio:uncheck()
                        end
                    end
                end
            }),
            target = {color = Theme.font}
        }
    end
end

function PlaySelectState:init()
    local elements = {}
    local yStart = 50
    self:addKeyRadioButtons(elements, yStart)
    self:addTimeRadioButtons(elements, yStart + Vars.titleSize * 4)
    self:addLevelRadioButtons(elements, yStart + Vars.titleSize * 2)

    self:transition(elements)
    DialogSate.init(self, {validate = 'Play'})
end

return PlaySelectState