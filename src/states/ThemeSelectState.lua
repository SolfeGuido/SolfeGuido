
local Theme  = require('src.utils.Theme')
local Config = require('src.utils.Config')
local ScreenManager = require('lib.ScreenManager')
local DialogState = require('src.states.DialogState')

---@class ThemeSelectState : State
local ThemeSelectState = DialogState:extend()


function ThemeSelectState:new()
    DialogState.new(self)
    self.selectedTheme = Config.theme
end

function ThemeSelectState:validate()
    if Config.update('theme', self.selectedTheme) then
        ScreenManager.switch('RootState')
    else
        self:slideOut()
    end
end

function ThemeSelectState:init(...)
    DialogState.init(self, {
        validate = 'Apply'
    })
end

function ThemeSelectState:draw()
    DialogState.draw(self)
end

function ThemeSelectState:update(dt)
    DialogState.update(self, dt)
end

return ThemeSelectState