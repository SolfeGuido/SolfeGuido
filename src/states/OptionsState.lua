
--- LIBS
local State = require('src.State')
local Color = require('src.utils.Color')
local ScreenManager = require('lib.ScreenManager')
local Config = require('src.utils.Config')
local Mobile = require('src.utils.Mobile')

--- Entities
local IconButton = require('src.objects.IconButton')
local Title = require('src.objects.Title')

---@class OptionsState : State
local OptionsState = State:extend()

function OptionsState:new()
    State.new(self)
    self.yBottom = 0
    self.margin = Mobile.isMobile and 10 or assets.config.limitLine
end

function OptionsState:draw()
    local width = love.graphics.getWidth() - self.margin * 2

    love.graphics.setScissor(self.margin - 2, 0, width + 5, love.graphics.getHeight())
    love.graphics.push()
    love.graphics.translate(0,self.yBottom - love.graphics.getHeight())

    love.graphics.setColor(0.996, 0.996, 0.980,0.95)
    love.graphics.rectangle('fill', self.margin - 1, 0, width, love.graphics.getHeight() + 2)
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.rectangle('line', self.margin - 1, 0, width, love.graphics.getHeight() + 2)
    State.draw(self)

    love.graphics.pop()
    love.graphics.setScissor()
end

function OptionsState:slideOut()
    self:slideEntitiesOut()
    self.timer:tween(assets.config.transition.tween, self, {yBottom = 0}, 'out-expo',function()
        ScreenManager.pop()
        ScreenManager.first().settingsButton.consumed = false
    end)
end

function OptionsState:keypressed(key)
    if key == "escape" then
        self:slideOut()
    else
        State.keypressed(self, key)
    end
end

function OptionsState:init(...)
    local iconX = love.graphics.getWidth() - self.margin - assets.config.titleSize
    local title = love.graphics.newText(assets.MarckScript(assets.config.titleSize), tr("Options"))
    local elements = {
        {
            element = self:addentity(IconButton, {
                image = 'cross',
                width = assets.config.titleSize,
                callback = function() self:slideOut() end,
                x = iconX,
                y = - assets.config.titleSize,
                color = Color.transparent:clone()
            }),
            target  = {y = 0, color = Color.black}
        },
        {
            element = self:addentity(Title, {
                text = title,
                x = love.graphics.getWidth() /2 - title:getWidth() / 2,
                y = - title:getHeight(),
                framed = true,
                color = Color.transparent:clone()
            }),
            target = {y = 0, color = Color.black}
        },
        {
            element = self:addentity(IconButton, {
                image = Config.sound == 'on' and 'musicOn' or 'musicOff',
                x = self.margin,
                y = - assets.config.titleSize,
                width = assets.config.titleSize,
                color = Color.transparent:clone(),
                callback = function(btn)
                    btn.consumed = false
                    Config.update('sound', Config.sound == 'on' and 'off' or 'on')
                    btn:setImage(Config.sound == 'on' and 'musicOn' or 'musicOff')
                end
            }),
            target = {y = 0, color = Color.black}
        }
    }


    self:transition(elements)
    self:createUI({
        {
            {
                text = 'Notes',
                type = 'MultiSelector',
                config = 'noteStyle',
                centered = true,
                x = -math.huge
            },
            {
                text = 'Language',
                type = 'MultiSelector',
                config = 'lang',
                centered = true,
                x = -math.huge
            },
            {
                text = 'Answer',
                type = 'MultiSelector',
                config = 'answerType',
                platform = 'desktop',
                centered = true,
                x = -math.huge
            },
            {
                text = 'Vibrate',
                type = 'MultiSelector',
                config = 'vibrations',
                platform = 'mobile',
                centered = true,
                x = -math.huge
            }
        }
    }, self.margin)
    self.timer:tween(assets.config.transition.tween, self, {yBottom = love.graphics.getHeight()}, 'out-expo')
end

return OptionsState