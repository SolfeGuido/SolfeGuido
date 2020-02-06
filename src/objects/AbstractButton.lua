
local Entity = require('src.Entity')

---@class AbstractButton : Entity
local AbstractButton = Entity:extend()

AbstractButton.defaultCursor = love.mouse.getSystemCursor('arrow')
AbstractButton.hoveredCursor = love.mouse.getSystemCursor('hand')

function AbstractButton:new(container, options)
    Entity.new(self, container, options)
    self.state = "neutral"
    self.consumed = false
    self.animation = nil
    -- Keep track of the finger pressing the button
    self.fingerId = nil
end

function AbstractButton:animate(...)
    if self.animation then
        self.timer:cancel(self.animation)
        self.animation = nil
    end
    self.animation = self.timer:tween(...)
end

function AbstractButton:dispose()
    if self.text then
        self.text:release()
        self.text = nil
    end
    AbstractButton.super.dispose(self)
end

function AbstractButton:pressed() end
function AbstractButton:leave() end
function AbstractButton:onclick() end
function AbstractButton:released() end
function AbstractButton:hovered() end

function AbstractButton:handleClick()
    if not self.consumed then
        self.consumed = true
        self:onclick()
        return true
    end
    return false
end

function AbstractButton:contains(x, y)
    return self.x <= x and (self.x + self.width) >= x and
            self.y <= y and (self.y + self.height) >= y
end

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