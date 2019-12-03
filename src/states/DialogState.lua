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
    self:redirectMouse('mousemoved', 'mousepressed', 'mousereleased')
    self:redirectTouch('touchmoved', 'touchpressed', 'touchreleased')
    self.slidingOut = false
    self.margin = Vars.limitLine / 2
end

function DialogState:redirectMouse(...)
    for _, evName in ipairs({...}) do
        DialogState[evName] = function(obj, x, y, ...)
            State[evName](obj, x - self.margin, y - self.yBottom, ...)
        end
    end
end

function DialogState:redirectTouch(...)
    for _,evName in ipairs({...}) do
        DialogState[evName] = function(obj, id, x, y, ...)
            State[evName](obj, id, x - self.margin, y - self.yBottom, ...)
        end
    end
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
    local width = love.graphics.getWidth() - self.margin * 2
    love.graphics.push()
    love.graphics.translate(self.margin ,self.yBottom)

    love.graphics.setColor(Theme.background)
    love.graphics.rectangle('fill', 0, 0, width, self.height)
    love.graphics.setColor(Theme.font)
    love.graphics.rectangle('line', 0, 0, width, self.height)
    State.draw(self)

    love.graphics.pop()
end

return DialogState