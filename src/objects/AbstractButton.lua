
local Entity = require('src.Entity')

--- This class is the parent class of all buttons type, the icon button, the text button
--- the piano, the radio button, ..., It helps detect when the button is pressed,
--- eases the state handling, and calls the right method when somethings happens
--- On the desktop app, it changes the cursor to "hand" when it is hovered
--- To make it easier to deal with animations, an method can be called to create the
--- necessary animations
---@class AbstractButton : Entity
---@field state string the button's current state ('neutral', 'pressed', 'hovered')
---@field consumed boolean wether the button was pressed or not
---@field animataion number? the id of the current animation, if there is one runing
---@field fingerID number? the id of the finger that pressed the button (used for the mobile app)
local AbstractButton = Entity:extend()

AbstractButton.defaultCursor = love.mouse.getSystemCursor('arrow')
AbstractButton.hoveredCursor = love.mouse.getSystemCursor('hand')

--- Constructor
---@param container EntityContainer this button's container
---@param options table the entities options
function AbstractButton:new(container, options)
    Entity.new(self, container, options)
    self.state = "neutral"
    self.consumed = false
    self.animation = nil
    -- Keep track of the finger pressing the button
    self.fingerId = nil
end

--- Cancels the current animation and starts a new one
--- use it to animate the button, without conflicts with other animations
function AbstractButton:animate(...)
    if self.animation then
        self.timer:cancel(self.animation)
        self.animation = nil
    end
    self.animation = self.timer:tween(...)
end

--- Deletes the button
function AbstractButton:dispose()
    if self.text then
        self.text:release()
        self.text = nil
    end
    AbstractButton.super.dispose(self)
end

--- Called when the user presses
--- this button
function AbstractButton:pressed() end

--- Called when the mouse leaves this button
function AbstractButton:leave() end

--- Called when the user presses and releases
--- this button
function AbstractButton:onclick() end

--- Called when the user releases the button
--- (but might not have pressed it)
function AbstractButton:released() end

--- Called when the mouse enters the button
function AbstractButton:hovered() end

--- Private method, called to check if
--- The onclick method should be caleld
--- whenever the user clicks the button
---@return boolean wether the onclick method was actually called
function AbstractButton:handleClick()
    if not self.consumed then
        self.consumed = true
        self:onclick()
        return true
    end
    return false
end

--- Default function to test if the button
--- contains the given coordinates
---@param x number x coordinate
---@param y number y coordinate
---@return boolean wether the button contains the given point
function AbstractButton:contains(x, y)
    return self.x <= x and (self.x + self.width) >= x and
            self.y <= y and (self.y + self.height) >= y
end

--- Called whenever a finger presses the screen
--- could be optimized with a tree or something though
---@param id number id of the finger that pressed the screen
---@param x number x coordinate
---@param y number y coordinate
function AbstractButton:touchpressed(id, x, y)
    if self.fingerId then return false end-- can't be pressed by two touches
    if self:contains(x, y) then
        self.fingerId = id
        self.state = "pressed"
        self:pressed()
        return true
    end
    return false
end

--- Called whenever a finger is released from the screen
---@param id number id of the finger released from the screen
---@param x number x coordinate of the release
---@param y number y coordinate of the release
function AbstractButton:touchreleased(id, x, y)
    if not self.fingerId or id ~= self.fingerId then return false end
    self.fingerId = nil
    self.state = 'neutral'
    self:leave()
    self:released()
    if self:contains(x, y) then
        return self:handleClick()
    end
    return false
end

--- Called whenever the mouse moves on the screen
--- checks the internal states, and see if the mouse
--- enters or leave this button
---@param x number
---@param y number
function AbstractButton:mousemoved(x, y)
    if love.mouse.isDown(1) then
        return false
    end
    local isInButton = self:contains(x, y)
    if isInButton then
        love.mouse.setCursor(AbstractButton.hoveredCursor)
        if self.state == "neutral" then
            self.state = "hovered"
            self:hovered()
        end
        return true
    elseif self.state == "hovered" and not isInButton then
        self.state = "neutral"
        love.mouse.setCursor(AbstractButton.defaultCursor)
        self:leave()
    end
    return false
end

--- Called whenever a mouse button is pressed,
--- will check if it is pressed inside the button
--- and will update its state accordingly
---@param x number x coordinate of the button
---@param y number y coordinate of the button
---@param button number id of the button that pressed the screen
function AbstractButton:mousepressed(x, y, button)
    if button == 1 and (self.state == "neutral" or self.state == "hovered") then
        if self:contains(x, y) then
            self.state = "pressed"
            self:pressed()
            return true
        end
    end
    return false
end

--- Called whenever a mouse button is released
--- will check if the release has been done inside the button
--- if the left button of the mouse has been pressed AND released
--- inside this button, and that it's not consummed, it will
--- then call the 'onclick' method
--- In all case, it will update the internal state of the button
---@param x number x coordinate of the mouse
---@param y number y coordinate of the mouse
---@param button number id of the button released
function AbstractButton:mousereleased(x, y, button)
    if button == 1 and self.state == "pressed" then
        self:released()
        if self:contains(x, y) then
            self.state = "hovered"
            return self:handleClick()
        else
            self.state = "neutral"
            self:leave()
        end
    end
    return false
end

return AbstractButton