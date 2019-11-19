
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
    self.gameModeButtons = {}
end

function PlaySelectState:validate()
    ScreenManager.switch('GamePrepareState')
end


function PlaySelectState:addRadioButtons(config)
    local list = Vars.userPreferences[config.configName]
    local padding = config.padding or 0
    local buttonSize = config.size or Vars.titleSize
    local buttonFullWidth = config.width + padding * 2 + 5
    local space = love.graphics.getWidth() + 5 - self.margin * 2 -buttonFullWidth * #list
    local startSpace = space / 2

    for i, v in ipairs(list) do
        config.target[#config.target+1] = {
            element = UIFactory.createRadioButton(self, {
                text = config.icon and nil or v,
                icon = config.icons and config.icons[v] or nil,
                y = config.y,
                x = startSpace + buttonFullWidth * (i-1),
                size = buttonSize,
                padding = padding,
                width = config.width,
                isChecked = Config[config.configName] == v,
                centerImage = true,
                name = config.listName,
                framed = true,
                callback = function(btn)
                    Config.update(config.configName, v)
                    btn.consumed = false
                    for _,radio in ipairs(self[config.listName]) do
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
    local yStart = 30
    local verticalGap = 15
    self:addRadioButtons({
        y = yStart,
        target = elements,
        configName = 'gameMode',
        icons = {
            timed = 'Stopwatch',
            zen = 'Infinity'
        },
        listName = 'gameModeButtons',
        width = Vars.titleSize * 2,
        padding =  5
    })
    yStart = yStart + Vars.titleSize + 10 + verticalGap
    self:addRadioButtons({
        y = yStart,
        target = elements,
        configName = 'keySelect',
        icons = {
            gKey = 'GKey',
            fKey = 'FKey',
            both = 'BothKeys'
        },
        listName = 'keyButtons',
        width = Vars.titleSize * 2,
        padding =  5,
        size = Vars.titleSize
    })
    yStart = yStart + Vars.titleSize + 10 + verticalGap
    self:addRadioButtons({
        y = yStart,
        target = elements,
        configName = 'time',
        listName = 'timeButtons',
        width = Vars.titleSize * 1.5,
        padding =  5,
        size = Vars.mobileButton.fontSize
    })
    yStart = yStart + Vars.mobileButton.fontSize + 17 + verticalGap
    self:addRadioButtons({
        y = yStart,
        target = elements,
        configName = 'difficulty',
        listName = 'difficultyButtons',
        width = Vars.titleSize * 1.5,
        padding =  5,
        size = Vars.mobileButton.fontSize
    })

    self:transition(elements)
    DialogSate.init(self, {validate = 'Play'})
end

return PlaySelectState