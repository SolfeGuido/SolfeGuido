
--- LIBS
local State = require('src.State')
local Theme = require('src.utils.Theme')
local ScreenManager = require('lib.ScreenManager')
local Config = require('src.utils.Config')
local UIFactory = require('src.utils.UIFactory')
local Drawer = require('src.objects.Drawer')

---@class OptionsState : State
local OptionsState = State:extend()

local inputIcons = {
    default = 'Keyboard',
    letters = 'PianoWithNotes',
    buttons = 'Pointer',
    piano   = 'PianoKeys'
}

function OptionsState:new()
    State.new(self)
    self.xPos = love.graphics.getWidth() - 5
    self.drawers = {}
end

function OptionsState:slideOut()
    for _, drawer in ipairs(self.drawers) do drawer:hide() end
    self.drawers = nil
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

function OptionsState:createDrawers(config, height)
    for _, v in ipairs(config) do
        local choices = {}
        for k, icon in pairs(v.icons) do
            choices[#choices+1] = {
                icon = icon,
                configValue = k
            }
        end

        local callback = nil
        if v.config == "lang" or v.config == "theme" then
            callback = function(drawer)
                if Config.update(v.config, drawer.selected) then
                    ScreenManager.switch('RootState')
                end
            end
        else
            callback = function(drawer)
                Config.update(v.config, drawer.selected)
                drawer:hide()
            end
        end
        local drawer = self:addentity(Drawer, {
            x = love.graphics.getWidth() + 5,
            y = v.y,
            height = height
        })
        self.drawers[#self.drawers+1] = drawer
        self[v.config .. 'Drawer']  = drawer
        drawer:init({
            selected = Config[v.config],
            choices = choices,
            callback = callback,
        })

    end
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
            element = UIFactory.createIconButton(self, {
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
            element = UIFactory.createIconButton(self, {
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
            element = UIFactory.createIconButton(self, {
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
            element = UIFactory.createIconButton(self, {
                icon = 'Tag',
                x = hiddenX,
                y = baseY  * 2 + padding,
                callback = function(btn)
                    btn.consumed = false
                end
            }),
            target = targets
        },
        {
            element = UIFactory.createIconButton(self, {
                icon = inputIcons[Config.answerType],
                x = hiddenX,
                y = baseY * 3 + padding,
                callback = function(btn)
                    btn.consumed = false
                    self.answerTypeDrawer:show()
                end
            }),
            target = targets
        },
        {
            element = UIFactory.createIconButton(self, {
                icon = 'Sphere',
                x = hiddenX,
                y = baseY * 4 + padding
            }),
            target = targets
        },
        {
            element = UIFactory.createIconButton(self, {
                type = 'IconButton',
                icon = 'Droplet',
                x = hiddenX,
                y = baseY * 5 + padding,
                callback = function(btn)
                    btn.consumed = false
                    self.themeDrawer:show()
                end
            }),
            target = targets
        }
    })
    self:createDrawers({
        {
            icons = {
                -- ?? 'Do ré' | 'Do re' | 'c d'
            },
            config = 'noteStyle',
            y = baseY * 2 + padding
        },
        {
            icons = inputIcons,
            config = 'answerType',
            y = baseY * 3 + padding / 2
        },
        {
            icons = {
                fr = 'Sun',
                en = 'Moon'
            },
            config = 'lang',
            y = baseY * 4 + padding
        },
        {
            icons = {
                light = 'Sun',
                dark = 'Moon'
            },
            config = 'theme',
            y = baseY * 5 + padding
        }
    }, padding + Vars.titleSize)
end

return OptionsState