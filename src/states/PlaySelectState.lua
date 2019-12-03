
local DialogSate = require('src.states.DialogState')
local ScreenManager = require('lib.ScreenManager')
local UIFactory = require('src.utils.UIFactory')
local Theme = require('src.utils.Theme')
local Config = require('src.data.Config')
local PlayButton = require('src.objects.PlayButton')

---@class PlaySelectState : State
local PlaySelectState = DialogSate:extend()


function PlaySelectState:new()
    DialogSate.new(self)
    self.keyButtons = {}
    self.timeButtons  = {}
    self.difficultyButtons = {}
    self.gameModeButtons = {}
    self:setWidth(Vars.titleSize * 10)
end

function PlaySelectState:validate()
    ScreenManager.switch('GamePrepareState')
end


function PlaySelectState:addRadioButtons(config)
    local list = Vars.userPreferences[config.configName]
    local padding = config.padding or 0
    local buttonSize = config.size or Vars.titleSize
    local buttonFullWidth = config.width + padding * 2 + 5
    local space = self.width -buttonFullWidth * #list
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
    local yStart = 5
    local verticalGap = 13
    local pad = 3
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
        padding =  pad
    })
    yStart = yStart + Vars.titleSize + pad * 2 + verticalGap
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
        padding =  pad,
        size = Vars.titleSize
    })
    yStart = yStart + Vars.titleSize + pad *2 + verticalGap
    self:addRadioButtons({
        y = yStart,
        target = elements,
        configName = 'time',
        listName = 'timeButtons',
        width = Vars.titleSize * 1.5,
        padding =  pad,
        size = Vars.mobileButton.fontSize
    })
    yStart = yStart + Vars.mobileButton.fontSize + pad * 3 + 5 + verticalGap
    self:addRadioButtons({
        y = yStart,
        target = elements,
        configName = 'difficulty',
        listName = 'difficultyButtons',
        width = Vars.titleSize * 1.5,
        padding =  pad,
        size = Vars.mobileButton.fontSize
    })
    self:transition(elements)
    self.height = yStart + Vars.mobileButton.fontSize * 2 + pad * 3 + 5 + verticalGap
    DialogSate.init(self)

    local dialogMiddle =  self.width / 2

    self:transition({
        {
            element = self:addentity(PlayButton, {
                color = Theme.transparent:clone(),
                x = dialogMiddle,
                y = self.height,
                callback = function()
                    ScreenManager.switch('GamePrepareState')
                end
            }),
            target = {color = Theme.font}
        }
    
    })
end


return PlaySelectState