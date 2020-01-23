
local AbstractButton = require('src.objects.AbstractButton')
local lume = require('lib.lume')
local Theme = require('src.utils.Theme')

---@class PlayButton : Entity
local PlayButton = AbstractButton:extend()

function  PlayButton:new(container, options)
    AbstractButton.new(self, container, options)
    self.image = love.graphics.newText(assets.fonts.Icons(Vars.mobileButton.fontSize),assets.IconName.Play)
    self.radius = self.image:getWidth() * 1.5
    self.color = options.color or Theme.font:clone()
    self.xOrigin = self.image:getWidth() / 2
    self.yOrigin = self.image:getHeight() / 2
end

function PlayButton:contains(x, y)
    return lume.distance(x, y, self.x, self.y, true) < self.radius * self.radius
end

function PlayButton:onclick()
    assets.sounds.click:play()
    local a = self.y * 2
    local b = love.graphics.getWidth() / 2
    local maxRadius = math.sqrt(a*a + b*b)
    self.timer:tween(
        Vars.transition.state,
        self,
        {radius = maxRadius, color = Theme.background},
        'in-out-expo',
        self.callback
    )
end

function  PlayButton:draw()
    love.graphics.setColor(Theme.background)
    love.graphics.circle('fill', self.x, self.y, self.radius, 100)
    love.graphics.setColor(Theme.font)
    love.graphics.circle('line', self.x, self.y, self.radius, 100)

    love.graphics.setColor(self.color)
    love.graphics.draw(self.image, self.x + 2, self.y, nil, nil, nil, self.xOrigin, self.yOrigin)
end

return PlayButton