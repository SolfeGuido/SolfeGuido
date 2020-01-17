-- LIBS
local State = require('src.State')
local ScreenManager = require('lib.ScreenManager')
local Theme = require('src.utils.Theme')

-- Entities
local UIFactory = require('src.utils.UIFactory')

---@class DialogState : State
local DialogState = State:extend()


function DialogState:new()
    State.new(self)
    self.yBottom = 0
    self.slidingOut = false
    self:setWidth(Vars.limitLine / 2)
end

function DialogState:setWidth(width)
    self.width = width
    self.margin = (love.graphics.getWidth() - self.width) / 2
end

function DialogState:contains(x, y)
    return x >= self.margin and x <= self.margin + self.width and
            y >= self.yBottom and y <= self.yBottom + self.height
end

function DialogState:mousepressed(x, y, button)
    if self:contains(x, y) then
        State.mousepressed(self, x - self.margin, y - self.yBottom, button)
    else
        self.outsideButton = button
    end
end

function DialogState:mousereleased(x, y, button)
    if self:contains(x, y) then
        State.mousereleased(self, x - self.margin, y - self.yBottom, button)
    elseif self.outsideButton == button then
        self:slideOut()
    end
    self.outsideButton = nil
end

function DialogState:touchpressed(id, x, y)
    if self:contains(x, y) then
        State.touchpressed(self, id, x - self.margin, y - self.yBottom)
    else
        self.outsideTouch = id
    end
end

function DialogState:touchreleased(id, x ,y)
    if self:contains(x, y) then
        State.touchreleased(self, id, x - self.margin, y - self.yBottom)
    elseif self.outsideTouch == id then
        self:slideOut()
    end
    self.outsideTouch = nil
end

function DialogState:mousemoved(x, y)
    State.mousemoved(self, x - self.margin, y - self.yBottom)
end

function DialogState:touchmoved(id, x, y)
    State.touchmoved(self, id, x - self.margin, y - self.yBottom)
end

function DialogState:keypressed(key)
    if key == "escape" then
        self:slideOut()
    else
        State.keypressed(self, key)
    end
end

function DialogState:slideOut()
    if self.slidingOut then return end
    self.slidingOut = true
    local target = -self.height - (love.graphics.getHeight() - self.height) / 2 - 10
    self.timer:tween(Vars.transition.tween, self, {yBottom = target}, 'out-expo',function()
        ScreenManager.pop()
    end)
end

function DialogState:init()
    local iconX = love.graphics.getWidth() - self.margin * 2 - Vars.titleSize / 1.2
    local elements = {
        {
            element = UIFactory.createIconButton(self, {
                icon = 'Times',
                callback = function() self:slideOut() end,
                x = iconX,
                y = -Vars.titleSize,
                size = Vars.titleSize / 1.5,
                color = Theme.transparent:clone()
            }),
            target  = {y = 5, color = Theme.font}
        }
    }
    self:transition(elements)
    if not self.height then
        self.height = love.graphics.getHeight() - 40
    end
    local target = (love.graphics.getHeight() - self.height) / 2
    self.timer:tween(Vars.transition.tween, self, {yBottom = target}, 'out-expo')
end

function DialogState:draw()
    love.graphics.push()
    love.graphics.translate(self.margin ,self.yBottom)

    love.graphics.setColor(Theme.background)
    love.graphics.rectangle('fill', 0, 0, self.width, self.height)
    love.graphics.setColor(Theme.font)
    love.graphics.rectangle('line', 0, 0, self.width, self.height)
    State.draw(self)

    love.graphics.pop()
end

return DialogState