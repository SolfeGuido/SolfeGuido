
local Entity = require('src.Entity')
local Theme = require('src.utils.Theme')
local lume = require('lib.lume')

--- Simple title, that contains a text
--- and can have border
---@class Title: Entity
---@field private framed boolean
---@field private centered boolean
local Title = Entity:extend()

--- Constructor
---@param container EntityContainer
---@param options table
function Title:new(container, options)
    Entity.new(self, container, options)
    if options.centered then self:center() end
end

--- Inherited method
function Title:dispose()
    self.text:release()
    Title.super.dispose(self)
end

--- Changes the text, and centers the title
---@param text string
function Title:setCenteredText(text)
    local oldWidth = self.text:getWidth()
    self.text:set(text)
    local nwWidth = self.text:getWidth()
    self.x = self.x + (oldWidth - nwWidth) / 2
end

--- Centers the title in the middle of the screen
function Title:center()
    self.x = love.graphics.getWidth() / 2 - self.text:getWidth()  / 2
end

--- Inherited method
function Title:draw()
    if self.framed then
        love.graphics.setColor(Theme.background)
        love.graphics.rectangle('fill', self.x - 5, self.y - 5, self:width() + 10, self:height() + 5)
        love.graphics.setColor(Theme.font)
        love.graphics.rectangle('line', self.x - 5, self.y - 5, self:width() + 10, self:height() + 5)
    end
    love.graphics.setColor(self.color)
    love.graphics.draw(self.text, lume.round(self.x), lume.round(self.y))
end

--- Width accessor
---@return number
function Title:width()
    return self.text:getWidth()
end

--- Height accessor
---@return number
function Title:height()
    return self.text:getHeight()
end

return Title