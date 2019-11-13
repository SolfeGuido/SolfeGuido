
--- LIBS
local State = require('src.State')
local Theme = require('src.utils.Theme')
local ScreenManager = require('lib.ScreenManager')
local Config = require('src.utils.Config')
local Mobile = require('src.utils.Mobile')

--- Entities
local IconButton = require('src.objects.IconButton')

---@class OptionsState : State
local OptionsState = State:extend()

function OptionsState:new()
    State.new(self)
    self.xPos = love.graphics.getWidth() - 5
end

function OptionsState:slideOut()
    local elements = {}
    for _,v in ipairs(self.entities) do
        elements[#elements+1] = {
            element = v,
            target = {color = Theme.transparent, x = love.graphics.getWidth()}
        }
    end
    self:transition(elements, function()
        ScreenManager.pop()
        ScreenManager.first().settingsButton.consumed = false
    end, 0)
    self.timer:tween(Vars.transition.tween, self, {xPos = love.graphics.getWidth() + 5}, 'out-expo')
    local settings = ScreenManager.first().settingsButton
    if settings then
        self.timer:tween(Vars.transition.tween, settings, {rotation = settings.rotation + math.pi}, 'linear')
    end
end

function OptionsState:keypressed(key)
    if key == "escape" then
        self:slideOut()
    end
end

function OptionsState:draw()
    local height = love.graphics.getHeight()
    local width = Vars.titleSize * 2
    love.graphics.setColor(Theme.background)
    love.graphics.rectangle('fill',self.xPos, -5, width, height + 10)

    love.graphics.setColor(Theme.font)
    love.graphics.rectangle('line', self.xPos, -5, width, height + 10)
    State.draw(self)
end

function OptionsState:init(...)
    self.timer:tween(Vars.transition.tween, self, {xPos = love.graphics.getWidth() - Vars.titleSize * 1.5}, 'out-expo')

    local optionIcons = 6
    local remainingSpace = (love.graphics.getHeight() - Vars.titleSize * optionIcons)
    local padding = remainingSpace / (optionIcons + 1)

    local hiddenX = love.graphics.getWidth()
    local xPos = love.graphics.getWidth() - Vars.titleSize * 1.25
    local baseY = Vars.titleSize  + padding
    local targets = {x = xPos, color = Theme.font}
    local elements = {
        {
            element = self:addIconButton({
                icon = 'Times',
                x = hiddenX,
                y = padding,
                callback = function()
                    self:slideOut()
                end
            }),
            target = targets
        },
        {
            element = self:addIconButton({
                icon = Config.sound == 'on' and 'VolumeOn' or 'VolumeOff',
                x = hiddenX,
                y = baseY + padding,
                callback = function(btn)
                    btn.consumed = false
                    Config.update('sound', Config.sound == 'on' and 'off' or 'on')
                    btn:setIcon(Config.sound == 'on' and assets.IconName.VolumeOn or assets.IconName.VolumeOff)
                end
            }),
            target = targets
        },
        {
            element = self:addIconButton({
                icon = 'Tag',
                statePush = 'NoteStyleState',
                x = hiddenX,
                y = baseY * 2 + padding
            }),
            target = targets
        },
        {
            element = self:addIconButton({
                icon = 'Sphere',
                statePush = 'LanguageState',
                x = hiddenX,
                y = baseY * 3 + padding
            }),
            target = targets
        },
        {
            element = self:addIconButton({
                type = 'IconButton',
                icon = 'Droplet',
                statePush = 'ThemeState',
                x = hiddenX,
                y = baseY * 4 + padding
            }),
            target = targets
        }
    }

    if Mobile.isMobile then
        elements[#elements+1] = {
            element = self:addIconButton({
                icon = Config.vibrations == 'on' and 'MobileVibrate' or 'Mobile',
                x = hiddenX,
                y = baseY * 5 + padding,
                callback = function(btn)
                    btn.consumed = false
                    if Config.vibrations == 'on' then btn:shake() end
                    Config.update('vibrations', Config.vibrations == 'on' and 'off' or 'on')
                    btn:setIcon(Config.vibrations == 'on' and assets.IconName.MobileVibrate or assets.IconName.Mobile)
                end
            }),
            target = targets
        }
    else
        elements[#elements+1] = {
            element = self:addIconButton({
                icon = 'Mouse',
                statePush = 'AnswerTypeState',
                x = hiddenX,
                y = baseY * 5 + padding
            }),
            target = targets
        }
    end
    self:transition(elements)
    --DialogState.init(self, {title = "Options", validate = 'Save', validateIcon = assets.IconName.FloppyDisk})
end

return OptionsState