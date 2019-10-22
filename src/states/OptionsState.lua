
--- LIBS
local State = require('src.State')
local Color = require('src.utils.Color')
local ScreenManager = require('lib.ScreenManager')

--- Entities
local IconButton = require('src.objects.IconButton')
local Title = require('src.objects.Title')

---@class OptionsState : State
local OptionsState = State:extend()

function OptionsState:new()
    State.new(self)
    self.yBottom = 0
end

function OptionsState:draw()
    local width = love.graphics.getWidth() - assets.config.limitLine * 2

    love.graphics.setScissor(assets.config.limitLine - 1, 0, width, love.graphics.getHeight())
    love.graphics.push()
    love.graphics.translate(0,self.yBottom - love.graphics.getHeight())

    love.graphics.setColor(1,1,1,0.9)
    love.graphics.rectangle('fill', assets.config.limitLine -1, 0, width, love.graphics.getHeight() + 2)
    love.graphics.setColor(0, 0, 0,0.9)
    love.graphics.rectangle('line', assets.config.limitLine -1, 0, width, love.graphics.getHeight() + 2)
    State.draw(self)

    love.graphics.pop()
    love.graphics.setScissor()
end

function OptionsState:slideOut()
    self.timer:tween(assets.config.transition.tween, self, {yBottom = 0}, 'out-expo',function()
        ScreenManager.pop()
        ScreenManager.first().settingsButton.consumed = false
    end)
end

function OptionsState:init(...)
    local iconX = love.graphics.getWidth() - assets.config.limitLine - assets.config.titleSize
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
        }
    }


    self:transition(elements)
    self:createUI({{},
        {{
                text = 'Key',
                type = 'MultiSelector',
                config = 'keySelect'
            }, {
                text = 'Sound',
                type = 'MultiSelector',
                config = 'sound'
            }, {
                text = 'Difficulty',
                type = 'MultiSelector',
                config = 'difficulty'
            }
        },
        {
            {
                text = 'Notes',
                type = 'MultiSelector',
                config = 'noteStyle'
            },
            {
                text = 'Language',
                type = 'MultiSelector',
                config = 'lang'
            },
            {
                text = 'Answer',
                type = 'MultiSelector',
                config = 'answerType',
                platform = 'desktop'
            },
            {
                text = 'Vibrate',
                type = 'MultiSelector',
                config = 'vibrations',
                platform = 'mobile'
            }
        }
    })
    self.timer:tween(assets.config.transition.tween, self, {yBottom = love.graphics.getHeight()}, 'out-expo')
end

return OptionsState