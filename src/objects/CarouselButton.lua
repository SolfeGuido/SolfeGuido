
local Entity = require('src.Entity')
local Theme = require('src.utils.Theme')

---@class CarouselButton : Entity
local CarouselButton = Entity:extend()

function CarouselButton:new(area, options)
    Entity.new(self, area, options)
    self:tweenIn()
end

function CarouselButton:tweenIn()
    if not self.isDisposed then
        self.timer:tween(Vars.transition.tween, self, {color = Theme.font}, 'out-quad', function()
            self:tweenOut()
        end)
    end
end

function CarouselButton:tweenOut()
    if not self.isDisposed then
        self.timer:tween(Vars.transition.tween, self, {color = Theme.font}, 'out-quad', function()
            self:tweenIn()
        end)
    end
end

function CarouselButton:update(_)
    self.x = self.target.x
    self.y = self.target.y
end

function CarouselButton:draw()
    if not self.visible then return end
    love.graphics.push()
    love.graphics.translate(0, 2.5)
    love.graphics.setColor(self.color)
    
    local middle = Vars.lineHeight
    local x = self.target.x
    local y = self.target.y
    local width = self.target:width()
    love.graphics.polygon('fill',x - 10, y + middle / 2, x - 5, y + middle /3, x -5, y + middle - middle /3)
    love.graphics.polygon('fill',x + width + 10, y + middle / 2, x + width + 5, y + middle /3, x + width + 5, y + middle - middle /3)


    love.graphics.pop()
end

return CarouselButton