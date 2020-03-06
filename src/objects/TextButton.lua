-- LIBS
local Theme = require('src.utils.Theme')
local lume = require('lib.lume')

-- Entities
local AbstractButton = require('src.objects.AbstractButton')

--- A simple button, with text inside
--- can also have an icon before the text
---@class TextButton : AbstractButton
---@field private padding number
---@field private width number
---@field private height number
---@field private xOrigin number
---@field private yOrigin number
local TextButton = AbstractButton:extend()

function TextButton:new(container, config)
    AbstractButton.new(self, container, config)
    self.color = config.color or Theme.font:clone()
    self.padding = config.padding or 0
    self.width = self.text:getWidth() + self.padding * 2
    self.height = self.text:getHeight() + self.padding * 2


    if self.icon then
        self.width = self.width + self.icon:getWidth() + (self.padding * 2)
    end

    if self.centerText then
        self.x = self.x - (self.width / 2)
    end

    self.xOrigin = (config.xOrigin or 0) * self.width
    self.yOrigin = (config.yOrigin or 0) * self.height
end

--- Checks if the given point is inside the button
---@return boolean
---@param x number
---@param y number
function TextButton:contains(x,y)
    return x >= (self.x - self.xOrigin) and x <= (self.x - self.xOrigin + self.width) and
            y >= (self.y - self.yOrigin) and y <= (self.y - self.yOrigin + self.height)
end

--- Animates the button when presed
function TextButton:pressed()
    self:animate(Vars.transition.tween, self, {color = Theme.clicked}, 'out-expo')
end

--- Animates the button when released
function TextButton:released()
    self:animate(Vars.transition.tween, self, {color = Theme.font}, 'out-expo')
end

--- Calls the callback (if any)
function TextButton:onclick()
    assets.sounds.click:play()
    if self.callback then self.callback(self) end
end


--- Inherited method
function TextButton:draw()
    love.graphics.push()
    love.graphics.translate(self.x - self.xOrigin, self.y - self.yOrigin)

    if self.framed then
        love.graphics.setColor(Theme.background)
        love.graphics.rectangle('fill', 0, 0, self.width, self.height)
        love.graphics.setColor(self.color)
        love.graphics.rectangle('line', 0, 0, self.width, self.height)
    end
    love.graphics.setColor(self.color)
    local x = self.padding
    if self.icon then
        local iconY = lume.round(self.height / 2 - self.icon:getHeight() / 2)
        love.graphics.draw(self.icon, lume.round(x), iconY)
        x = x + self.icon:getWidth() + self.padding
    end

    love.graphics.draw(self.text, lume.round(x), lume.round(self.padding))
    love.graphics.pop()
end



return TextButton