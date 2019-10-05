local Entity = require('src.Entity')
local Rectangle = require('src.utils.Rectangle')
local lume = require('lib.lume')

local CarouselButton = require('src.objects.CarouselButton')

---@class MultiSelector : Entity
local MultiSelector = Entity:extend()

function MultiSelector:new(area, options)
    Entity.new(self, area, options)
    self.pressed = false
    self.currentChoice = lume.find(self.choices, self.selected) or 1
    self.selectedText = love.graphics.newText(self.text:getFont(), tr(self.selected))
    self.selector = self.area:addentity(CarouselButton, {
        target = self,
        color = assets.config.color.transparent(),
        visible = false
    })
end

function MultiSelector:boundingBox()
    return Rectangle(self.x, self.y, self:width() + 20, self.text:getHeight() - 7)
end

function MultiSelector:width()
    return self.text:getWidth() + self.selectedText:getWidth() + 10
end

function MultiSelector:draw()
    love.graphics.setColor(self.color)
    love.graphics.draw(self.text, self.x, self.y)

    local nwx = self.text:getWidth() + 10 + self.x
    love.graphics.draw(self.selectedText, nwx, self.y)
    local middle = assets.config.lineHeight
    --love.graphics.polygon('fill',self.x - 10, self.y + middle / 2, self.x - 5, self.y + middle /3, self.x -5, self.y + middle - middle /3)
    --love.graphics.polygon('fill',self.x + self:width() + 10, self.y + middle / 2, self.x + self:width() + 5, self.y + middle /3, self.x + self:width() + 5, self.y + middle - middle /3)
end

function MultiSelector:mousepressed(x, y, button)
    self.pressed = button == 1 and self:boundingBox():contains(x, y) and not self.pressed
end

function MultiSelector:mousereleased(x, y, button)
    if button == 1 and self.pressed and self:boundingBox():contains(x, y) then
        self.currentChoice = (self.currentChoice  % #self.choices) + 1
        self.selectedText:set( tr(self.choices[self.currentChoice]))
        if self.callback then self.callback(self.choices[self.currentChoice]) end
    end
    self.pressed = false
end

function MultiSelector:mousemoved(x, y)
    if self:boundingBox():contains(x, y) then
        self.selector.visible = true
    else
        self.selector.visible = false
    end
end

function MultiSelector:update(dt)
end

return MultiSelector