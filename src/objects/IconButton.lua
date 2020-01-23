-- LIBS
local Theme = require('src.utils.Theme')
local lume = require('lib.lume')

-- Entities
local AbstractButton = require('src.objects.AbstractButton')

---@class IconButton : AbstractButton
local IconButton = AbstractButton:extend()

function IconButton:new(container, config)
    AbstractButton.new(self, container, config)
    local defaultFont = assets.fonts.Icons(config.size or Vars.titleSize)
    self.image = love.graphics.newText(defaultFont,  config.icon)
    self.padding = config.padding or 0
    self.color = config.color or Theme.font:clone()
    self._width = (self.image:getWidth() + self.padding * 2)
    self.height = (self.image:getHeight() + self.padding * 2)
    if self.centered then
        self.x = love.graphics.getWidth() / 2 - self._width / 2
    end
    self.rotation = 0
    if self.anchor then
        self.x = self.x - self._width * self.anchor
        self.y = self.y - self.height * self.anchor
    end
    self.xOrigin = self._width / 2
    self.yOrigin = self.height / 2
    self.shaking = nil
    if self.circled then
        self.sqrWidth = math.pow(self._width + self.padding, 2)
        self.contains = function(this, x, y)
            return lume.distance(this.x + this._width / 2, this.y + this.height / 2, x, y, true) <= this.sqrWidth
        end
    end
end

function IconButton:shake()
    if self.shaking then return end
    local shakeTime = 0.1
    local shakeDistance = 8
    local originX = self.x
    self.shaking = self.timer:tween(shakeTime, self, {x = originX - shakeDistance}, 'linear', function()
        self.shaking = self.timer:tween(shakeTime, self, {x = originX + shakeDistance}, 'linear', function()
            self.shaking = self.timer:tween(shakeTime, self, {x = originX}, 'linear', function()
                self.shaking = nil
            end)
        end)
    end)
end


function IconButton:setIcon(icon)
    self.image:set(icon)
end

function IconButton:width()
    return self._width
end

function IconButton:dispose()
    self.image:release()
    self.image = nil
    IconButton.super.dispose(self)
end

function IconButton:__tostring()
    return "IconButton(" .. tostring(self.image) .. ")"
end

function IconButton:contains(x, y)
    return self.x <= x and (self.x + self._width) >= x and
            self.y <= y and (self.y + self.height) >= y
end

function IconButton:hovered()
    self:animate(Vars.transition.tween, self, {color =  Theme.hovered}, 'out-expo')
end

function IconButton:pressed()
    self:animate(Vars.transition.tween, self, {color = Theme.clicked}, 'out-expo')
end

function IconButton:released()
    self:animate(Vars.transition.tween, self, {color = Theme.font}, 'out-expo')
end

function IconButton:leave()
    self:animate(Vars.transition.tween, self, {color = Theme.font}, 'out-expo')
end

function IconButton:onclick()
    assets.sounds.click:play()
    if self.callback then self.callback(self) end
end

function IconButton:draw()
    love.graphics.setColor(self.color)
    if self.circled then
        love.graphics.circle('line', self.x + self.xOrigin, self.y + self.yOrigin,
                                self._width * 0.8 + self.padding, 100)
    elseif self.framed then
        love.graphics.setColor(Theme.background)
        love.graphics.rectangle('fill', self.x, self.y, self._width, self._width)
        love.graphics.setColor(self.color)
        love.graphics.rectangle('line', self.x, self.y, self._width, self._width)
    end

    love.graphics.draw(self.image,
        lume.round(self.x + self.xOrigin + self.padding), lume.round(self.y + self.yOrigin + self.padding),
        self.rotation,
        nil, nil,
        lume.round(self.xOrigin), lume.round(self.yOrigin))
end

return IconButton