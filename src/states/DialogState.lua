-- LIBS
local State = require('src.State')
local Mobile = require('src.utils.Mobile')
local ScreenManager = require('lib.ScreenManager')
local Theme = require('src.utils.Theme')

-- Entities
local Title = require('src.objects.Title')
local IconButton = require('src.objects.IconButton')

---@class DialogState : State
local DialogState = State:extend()


function DialogState:new()
    State.new(self)
    self.yBottom = 0
    self.margin = self:getMargin()
end

function DialogState:getMargin()
    -- Change for mobile, create ratio or something
    return Mobile.isMobile and 10 or assets.config.limitLine
end

function DialogState:keypressed(key)
    if key == "escape" then
        self:slideOut()
    else
        State.keypressed(self, key)
    end
end

function DialogState:slideOut()
    self:slideEntitiesOut()
    self.timer:tween(assets.config.transition.tween, self, {yBottom = 0}, 'out-expo',function()
        ScreenManager.pop()
    end)
end

function DialogState:init(title)
    local iconX = love.graphics.getWidth() - self.margin - assets.config.titleSize
    local elements = {
        {
            element = self:addentity(IconButton, {
                icon = assets.IconName.Times,
                callback = function(btn)
                    local settings = ScreenManager.first().settingsButton
                    if settings then
                        self.timer:tween(assets.config.transition.tween, settings, {rotation = settings.rotation + math.pi}, 'linear')
                    end
                    self:slideOut()
                end,
                x = iconX,
                y = -assets.config.titleSize,
                color = Theme.transparent:clone()
            }),
            target  = {y = 0, color = Theme.font}
        }
    }
    if title then
        local titleText = love.graphics.newText(assets.MarckScript(assets.config.titleSize), tr(title))
        elements[#elements + 1] = {
                element = self:addentity(Title, {
                text = titleText,
                x = love.graphics.getWidth() /2 - titleText:getWidth() / 2,
                y = - titleText:getHeight(),
                framed = true,
                color = Theme.transparent:clone()
            }),
            target = {y = 0, color = Theme.font}
        }
    end

    self:transition(elements)
    self.timer:tween(assets.config.transition.tween, self, {yBottom = love.graphics.getHeight()}, 'out-expo')
end

function DialogState:draw()
    local width = love.graphics.getWidth() - self.margin * 2

    love.graphics.setScissor(self.margin - 2, 0, width + 5, love.graphics.getHeight())
    love.graphics.push()
    love.graphics.translate(0,self.yBottom - love.graphics.getHeight())

    love.graphics.setColor(Theme.background)
    love.graphics.rectangle('fill', self.margin - 1, 0, width, love.graphics.getHeight() + 2)
    love.graphics.setColor(Theme.font)
    love.graphics.rectangle('line', self.margin - 1, 0, width, love.graphics.getHeight() + 2)
    State.draw(self)

    love.graphics.pop()
    love.graphics.setScissor()
end

return DialogState