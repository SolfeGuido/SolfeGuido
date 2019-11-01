

--- LIBS
local Rectangle = require('src.utils.Rectangle')
local lume = require('lib.lume')
local Theme = require('src.utils.Theme')

--- Entities
local AbstractButton = require('src.objects.AbstractButton')
local CarouselButton = require('src.objects.CarouselButton')

---@class MultiSelector : AbstractButton
local MultiSelector = AbstractButton:extend()

function MultiSelector:new(area, options)
    AbstractButton.new(self, area, options)
    self.currentChoice = lume.find(self.choices, self.selected) or 1
    self.selectedText = love.graphics.newText(self.text:getFont(), tr(self.selected))
    self.selector = self.area:addentity(CarouselButton, {
        target = self,
        color = Theme.transparent:clone(),
        visible = false
    })
    if self.centered then
        self.timer:tween(Vars.transition.tween, self, {x = self:getCenterX()}, 'out-expo')
    end
end

function MultiSelector:getCenterX()
    return (love.graphics.getWidth() - self.text:getWidth() - self.selectedText:getWidth()) / 2
end

function MultiSelector:center()
    self.x = self:getCenterX()
end

function MultiSelector:dispose()
    self.selectedText:release()
    self.selector.isDead = true
    MultiSelector.super.dispose(self)
end

function MultiSelector:width()
    return self.text:getWidth() + self.selectedText:getWidth() + 10
end

function MultiSelector:boundingBox()
    return Rectangle(self.x, self.y, self:width() + 20, math.max(self.selectedText:getHeight(),self.text:getHeight()) - 7)
end

function MultiSelector:draw()
    love.graphics.setColor(self.color)
    love.graphics.draw(self.text, self.x, self.y)

    local nwx = self.text:getWidth() + 10 + self.x
    love.graphics.draw(self.selectedText, nwx, self.y)
end

function MultiSelector:onclick()
    TEsound.play(assets.sounds.click)
    self.currentChoice = (self.currentChoice  % #self.choices) + 1
    self.selectedText:set( tr(self.choices[self.currentChoice]))
    if self.callback then self.callback(self.choices[self.currentChoice]) end
    self.consumed = false
    if self.centered then self:center() end
end

function MultiSelector:hovered()
    self.selector.visible = true
end

function MultiSelector:pressed()
    self.selector.visible = true
    self:animate(Vars.transition.tween, self, {color = {0.7, 0.7, 0.7, 1}}, 'out-expo')
end

function MultiSelector:released()
    self:animate(Vars.transition.tween, self, {color = Theme.font}, 'out-expo')
end

function MultiSelector:leave()
    self.selector.visible = false
end


return MultiSelector