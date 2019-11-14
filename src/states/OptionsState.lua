
--- LIBS
local State = require('src.State')
local Theme = require('src.utils.Theme')
local ScreenManager = require('lib.ScreenManager')
local Config = require('src.utils.Config')
local Mobile = require('src.utils.Mobile')

---@class OptionsState : State
local OptionsState = State:extend()

local inputIcons = {
    default = 'Keyboard',
    letters = 'PianoKeys',
    buttons = 'Pointer',
    piano   = 'PianoKeys'
}

function OptionsState:new()
    State.new(self)
    self.xPos = love.graphics.getWidth() - 5
end

function OptionsState:slideOut()
    local elements = {}
    for _,v in ipairs(self.entities) do
        elements[#elements+1] = {
            element = v,
            target = {color = Theme.transparent, x = love.graphics.getWidth() + 10}
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
    self:transition({
        {
            element = self:addIconButton({
                icon = 'Times',
                x = hiddenX,
                y = 10,
                circled = true,
                size = Vars.titleSize / 1.5,
                callback = function()
                    self:slideOut()
                end
            }),
            target = {x = xPos - Vars.titleSize * 1.25, color = Theme.font}
        },
        {
            element = self:addIconButton({
                icon = Config.sound == 'on' and 'VolumeOn' or 'VolumeOff',
                x = hiddenX,
                y = padding,
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
                icon = Config.vibrations == 'on' and 'MobileVibrate' or 'Mobile',
                x = hiddenX,
                y = baseY + padding,
                callback = function(btn)
                    btn.consumed = false
                    Config.update('vibrations', Config.vibrations == 'on' and 'off' or 'on')
                    if Config.vibrations == 'on' then btn:shake() end
                    btn:setIcon(Config.vibrations == 'on' and assets.IconName.MobileVibrate or assets.IconName.Mobile)
                end
            }),
            target = targets
        },
        {
            element = self:addIconButton({
                icon = 'Tag',
                x = hiddenX,
                y = baseY  * 2 + padding
            }),
            target = targets
        },
        {
            element = self:addIconButton({
                icon = 'Sphere',
                x = hiddenX,
                y = baseY * 3 + padding
            }),
            target = targets
        },
        {
            element = self:addIconButton({
                type = 'IconButton',
                icon = 'Droplet',
                x = hiddenX,
                y = baseY * 4 + padding
            }),
            target = targets
        },
        {
            element = self:addIconButton({
                icon = inputIcons[Config.answerType],
                x = hiddenX,
                y = baseY * 5 + padding
            }),
            target = targets
        }
    })
    --DialogState.init(self, {title = "Options", validate = 'Save', validateIcon = assets.IconName.FloppyDisk})
end

return OptionsState