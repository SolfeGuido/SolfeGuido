
local Entity = require('src.Entity')
local Theme = require('src.utils.Theme')
local lume = require('lib.lume')

local Title = Entity:extend()


function Title:new(container, options)
    Entity.new(self, container, options)
    if options.centered then self:center() end
end

function Title:dispose()
    self.text:release()
    Title.super.dispose(self)
end

function Title:setText(text)
    self.text:set(text)
end

function Title:setCenteredText(text)
    local oldWidth = self.text:getWidth()
    self.text:set(text)
    local nwWidth = self.text:getWidth()
    self.x = self.x + (oldWidth - nwWidth) / 2
end

function Title:center()
    self.x = love.graphics.getWidth() / 2 - self.text:getWidth()  / 2
end

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

function Title:width()
    return self.text:getWidth()
end

function Title:height()
    return self.text:getHeight()
end

return Title