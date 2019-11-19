
local Theme = require('src.utils.Theme')
local ScreenManager = require('lib.ScreenManager')
local State = require('src.State')

---@class CircleCloseState : State
local CircleCloseState = State:extend()


function CircleCloseState:new()
    State.new(self)
    self.x = love.graphics.getWidth() / 2
    self.y = love.graphics.getHeight() / 2
end

function CircleCloseState:init(transition, target)
    local maxRadius = math.sqrt(self.x * self.x + self.y * self.y)
    if transition == 'open' then
        self.radius = 0
        self.timer:tween(Vars.transition.state, self, {radius = maxRadius}, 'in-out-expo', function()
            ScreenManager.switch(target)
        end)
    else
        self.radius = maxRadius
        self.timer:tween(Vars.transition.state, self, {radius = 0}, 'in-out-expo', function()
            ScreenManager.pop()
        end)
    end
end

function CircleCloseState:draw()
    love.graphics.setColor(Theme.background)
    love.graphics.circle('fill', self.x, self.y, self.radius, 100)
    love.graphics.setColor(Theme.font)
    love.graphics.circle('line', self.x, self.y, self.radius, 100)
end

function CircleCloseState:update(dt)
    State.update(self, dt)
end

return CircleCloseState