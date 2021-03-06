
local DialogSate = require('src.states.DialogState')
local ScreenManager = require('lib.ScreenManager')
local UIFactory = require('src.utils.UIFactory')
local Theme = require('src.utils.Theme')
local Config = require('src.data.Config')
local PlayButton = require('src.objects.PlayButton')
local RadioButtonGroup = require('src.objects.RadioButtonGroup')

--- Dialog shown when the user wants to play
--- shows the existing game modes and their options
---@class PlaySelectState : DialogState
---@field private keyButtons table
---@field private timeButtons table
---@field private difficultyButtons table
---@field private gameModeButtons table
local PlaySelectState = DialogSate:extend()

--- Constructor
function PlaySelectState:new()
    DialogSate.new(self)
    self.keyButtons = {}
    self.timeButtons  = {}
    self.difficultyButtons = {}
    self.gameModeButtons = {}
    self:setWidth(Vars.titleSize * 10)
end

--- When the user decided he wants to play !
function PlaySelectState:validate()
    ScreenManager.switch('GamePrepareState')
end

--- Checks if the given posotion is contained by
--- the state
---@param x number
---@param y number
---@return boolean
function PlaySelectState:contains(x, y)
    return x >= self.margin and x <= self.margin + self.width and
            y >= self.yBottom and y <= self.yBottom + (self.height + Vars.mobileButton.fontSize)
end

--- Creates a row of radio buttons based
--- on the given configuration
---@param config table
function PlaySelectState:addRadioButtons(config)
    local list = Vars.userPreferences[config.configName]
    local padding = config.padding or 0
    local buttonSize = config.size or Vars.titleSize
    local buttonFullWidth = config.width + padding * 2 + 5
    local space = self.width -buttonFullWidth * #list
    local startSpace = space / 2

    local function levelName(lvl)
        if config.configName ~= 'difficulty' then return lvl end
        if lvl == 'all' then return lvl end
        return tr('level', {level = lvl})
    end

    local group = self:addEntity(RadioButtonGroup, {})
    for i, v in ipairs(list) do
        config.target[#config.target+1] = {
            element = UIFactory.createRadioButton(group, {
                text = config.icon and nil or levelName(v),
                font = 'Oswald',
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
                callback = function() Config.update(config.configName, v) end
            }),
            target = {color = Theme.font}
        }
    end
end

--- Creates all the buttons
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
            gClef = 'GClef',
            fClef = 'FClef',
            both = 'BothKeys',
            cClef3 = 'CClef3',
            cClef4 = 'CClef4'
        },
        listName = 'keyButtons',
        width = Vars.titleSize,
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
            element = self:addEntity(PlayButton, {
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