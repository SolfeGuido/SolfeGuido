
local Entity = require('src.Entity')
local Rectangle = require('src.utils.Rectangle')
local Selector = require('src.objects.Selector')

---@class Button : Entity
local Button = Entity:extend()

function Button:new(area, config)
    Entity.new(self, area, config)
    self.selector = self.area:addentity(Selector, {
        x = self.x - 10,
        y = self.y + 5,
        visible = false
    })
    self.selector:createAlpha()
    self.color = {0,0,0,0}
    self.selected = false
    self.pressed = false
end

function Button:dispose()
    self.selector.isDead = true
    self.text:release()
    Button.super.dispose(self)
end

function Button:width()
    return self.text:getWidth()
end

function Button:boundingBox()
    return Rectangle(self.x, self.y, assets.config.limitLine - 10, self.text:getHeight() - 7)
end

function Button:select()
    self.selected = true
    self.selector.visible = true
end

function Button:deselect()
    self.selected = false
    self.selector.visible = false
end

function Button:mousemoved(x,y)
    if self:boundingBox():contains(x, y) then
        if not self.selected then
            self:select()
        end
    else
        self:deselect()
    end
end

function Button:mousepressed(x, y, button)
    if button == 1 and self:boundingBox():contains(x, y) then
        self.pressed = true
    end
end


function Button:mousereleased(x, y, button)
    if button == 1 and self.pressed and self:boundingBox():contains(x, y) then
        if self.callback then self.callback() end
    end
    self.pressed = false
end

function Button:draw()
    love.graphics.setColor(self.color)
    love.graphics.draw(self.text, self.x + 5, self.y)
end

function Button:update(dt)
    self.selector.x = self.x - 15
    self.selector.y = self.y
end




return Button