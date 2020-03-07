-- LIBS
local State = require('src.State')
local ScreenManager = require('lib.ScreenManager')
local Theme = require('src.utils.Theme')

-- Entities
local UIFactory = require('src.utils.UIFactory')

--- Abstract class used to create a simple modal dialog
---@class DialogState : State
---@field protected yBottom number
---@field private slidinOut boolean
---@field public width number
local DialogState = State:extend()


--- Constructor
function DialogState:new()
    State.new(self)
    self.yBottom = 0
    self.slidingOut = false
    self:setWidth(Vars.limitLine / 2)
end

--- Updates the dialog with, and centers
--- it on the screen
---@param width number
function DialogState:setWidth(width)
    self.width = width
    self.margin = (love.graphics.getWidth() - self.width) / 2
end

--- Checks if the dialog contains the
--- given point
---@param x number
---@param y number
---@return boolean
function DialogState:contains(x, y)
    return x >= self.margin and x <= self.margin + self.width and
            y >= self.yBottom and y <= self.yBottom + self.height
end

--- Capture the mousePressed to close the dialog
--- when clicked outside
---@param x number
---@param y number
---@param button number
function DialogState:mousepressed(x, y, button)
    if self:contains(x, y) then
        State.mousepressed(self, x - self.margin, y - self.yBottom, button)
    else
        self.outsideButton = button
    end
end

--- Capture the mouserealsed, so that if the user
--- pressed and released outside the dialog, it closes
---@param x number
---@param y number
---@param button number
function DialogState:mousereleased(x, y, button)
    if self:contains(x, y) then
        State.mousereleased(self, x - self.margin, y - self.yBottom, button)
    elseif self.outsideButton == button then
        self:slideOut()
    end
    self.outsideButton = nil
end

--- Capture the touchpressed event so that
--- the dialog closes if the user presses outside of it
---@param id number
---@param x number
---@param y number
function DialogState:touchpressed(id, x, y)
    if self:contains(x, y) then
        State.touchpressed(self, id, x - self.margin, y - self.yBottom)
    else
        self.outsideTouch = id
    end
end

--- Capture the touchreleased event so that
--- the dialog closes if the user presses outside of it
---@param id number
---@param x number
---@param y number
function DialogState:touchreleased(id, x ,y)
    if self:contains(x, y) then
        State.touchreleased(self, id, x - self.margin, y - self.yBottom)
    elseif self.outsideTouch == id then
        self:slideOut()
    end
    self.outsideTouch = nil
end

--- Call the parent event, while shifting
--- the position to cancel the relative position
--- of the widgets
---@param x number
---@param y number
function DialogState:mousemoved(x, y)
    State.mousemoved(self, x - self.margin, y - self.yBottom)
end

--- Calls the parent event, while shifting
--- the position to cancel the relative position
--- of the widgets
---@param id number
---@param x number
---@param y number
function DialogState:touchmoved(id, x, y)
    State.touchmoved(self, id, x - self.margin, y - self.yBottom)
end

--- Capture the escape event to close
--- the dialog if needed
---@param key string
function DialogState:keypressed(key)
    if key == "escape" then
        self:slideOut()
    else
        State.keypressed(self, key)
    end
end

--- Closes the dialog
function DialogState:slideOut()
    if self.slidingOut then return end
    self.slidingOut = true
    local target = -self.height - (love.graphics.getHeight() - self.height) / 2 - 10
    self.timer:tween(Vars.transition.tween, self, {yBottom = target}, 'out-expo',function()
        ScreenManager.pop()
    end)
end

--- Initializes the common parts of the dialog:
--- the cross icon to close it
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

--- Draws all the elements
--- relative to the position of the dialog
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