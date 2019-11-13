
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
    self.xPos = love.graphics.getWidth()
    self.yMax = (Vars.titleSize  + 5) * 6
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
    self.timer:tween(Vars.transition.tween, self, {xPos = love.graphics.getWidth()}, 'out-expo')
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
    love.graphics.setColor(Theme.background)
    love.graphics.rectangle('fill',self.xPos, 0,Vars.titleSize * 2, self.yMax)

    love.graphics.setColor(Theme.font)
    love.graphics.rectangle('line', self.xPos, 0, Vars.titleSize * 2, self.yMax)
    State.draw(self)
end

function OptionsState:init(...)
    self.timer:tween(Vars.transition.tween, self, {xPos = love.graphics.getWidth() - Vars.titleSize - 10}, 'out-expo')


    local hiddenX = love.graphics.getWidth()
    local xPos = love.graphics.getWidth() - Vars.titleSize - 5
    local baseY = Vars.titleSize  + 5
    local targets = {x = xPos, color = Theme.font}
    local elements = {
        {
            element = self:addIconButton({
                icon = 'Times',
                x = hiddenX,
                y = 0,
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
                y = baseY,
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
                icon = 'Music',
                statePush = 'NoteStyleState',
                x = hiddenX,
                y = baseY * 2
            }),
            target = targets
        },
        {
            element = self:addIconButton({
                icon = 'Sphere',
                statePush = 'LanguageState',
                x = hiddenX,
                y = baseY * 3
            }),
            target = targets
        },
        {
            element = self:addIconButton({
                type = 'IconButton',
                icon = 'Droplet',
                statePush = 'ThemeState',
                x = hiddenX,
                y = baseY * 4
            }),
            target = targets
        }
    }

    if Mobile.isMobile then
        elements[#elements+1] = {
            element = self:addIconButton({
                icon = Config.vibrations == 'on' and 'MobileVibrate' or 'Mobile',
                x = hiddenX,
                y = baseY,
                callback = function(btn)
                    btn.consumed = false
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
                y = baseY * 5
            }),
            target = targets
        }
    end
    self:transition(elements)
    --DialogState.init(self, {title = "Options", validate = 'Save', validateIcon = assets.IconName.FloppyDisk})
end

return OptionsState