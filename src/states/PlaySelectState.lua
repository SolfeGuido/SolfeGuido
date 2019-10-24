
local State = require('src.State')
local Mobile = require('src.utils.Mobile')
local Color = require('src.utils.Color')
local ScreenManager = require('lib.ScreenManager')

local Title = require('src.objects.Title')
local IconButton = require('src.objects.IconButton')

---@class PlaySelectState : State
local PlaySelectState = State:extend()


function PlaySelectState:new()
    State.new(self)
    self.yBottom = 0
    self.margin = Mobile.isMobile and 10 or assets.config.limitLine
end

function PlaySelectState:draw()
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

function PlaySelectState:slideOut()
    self:slideEntitiesOut()
    self.timer:tween(assets.config.transition.tween, self, {yBottom = 0}, 'out-expo',function()
        ScreenManager.pop()
    end)
end

function PlaySelectState:init(...)
    local iconX = love.graphics.getWidth() - self.margin - assets.config.titleSize
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
        }
    }


    self:transition(elements)
    self:createUI({
        {
            {
                text = 'Key',
                type = 'MultiSelector',
                config = 'keySelect',
                centered = true,
                x = -math.huge
            },
            {
                text = 'Difficulty',
                type = 'MultiSelector',
                config = 'difficulty',
                centered = true,
                x = -math.huge
            },
            {
                text = 'Time',
                type = 'MultiSelector',
                config = 'time',
                centered = true,
                x = -math.huge
            }, {
                text = 'Play',
                type = 'TextButton',
                centered = true,
                framed = true,
                x = -math.huge,
                y = love.graphics.getHeight() - assets.config.titleSize * 2,
                image = assets.images.right,
                callback = function()
                    ScreenManager.switch('PlayState')
                end
            }
        }
    }, self.margin)
    self.timer:tween(assets.config.transition.tween, self, {yBottom = love.graphics.getHeight()}, 'out-expo')
end

return PlaySelectState