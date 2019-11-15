
local Config = require('src.utils.Config')
local ScreenManager = require('lib.ScreenManager')
local DialogState = require('src.states.DialogState')
local UIFactory = require('src.utils.UIFactory')
local Theme = require('src.utils.Theme')

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
    local yPos = love.graphics.getHeight() / 2 - Vars.titleSize / 2

    local margin = self:getMargin()
    local space = (love.graphics.getWidth() - margin * 2 - Vars.titleSize * 2 - 10) / 2


    local lightThemeButton = UIFactory.createRadioButton(self, {
        y = yPos,
        x = margin + space,
        icon = 'Sun',
        isChecked = Config.theme == 'light'
    })

    local darkThemeButton = UIFactory.createRadioButton(self, {
        y = yPos,
        x = margin + space + 10 + Vars.titleSize,
        icon = 'Moon',
        callback = function(btn)
            btn.consumed = false
            if not btn.isChecked then
                btn.isChecked = true
                lightThemeButton.isChecked = false
                self.selectedTheme = 'dark'
            end
        end,
        isChecked = Config.theme == 'dark'
    })

    lightThemeButton.callback = function(btn)
        btn.consumed = false
        if not btn.isChecked then
            btn.isChecked = true
            darkThemeButton.isChecked = false
            self.selectedTheme = 'light'
        end
    end

    self:transition({
        {
            element = lightThemeButton,
            target = {color = Theme.font}
        },
        {
            element = darkThemeButton,
            target = {color = Theme.font}
        }
    })

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