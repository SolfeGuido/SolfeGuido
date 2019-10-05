

local Entity = require('src.Entity')

local Draft = require('lib.draft')
local draft = Draft()

---@class StopWatch : Entity
---@field private color table
---@field private time number
local StopWatch = Entity:extend()

function StopWatch:new(area, config)
    Entity.new(self, area, config)
    self.color = assets.config.stopWatch.startColor
    self.time = assets.config.trialTime
end

function StopWatch:start()
    self.started = true
    self.timer:tween(assets.config.trialTime, self, {color = assets.config.stopWatch.endColor})
end

---@param dt number
function StopWatch:update(dt)
    if not self.started then return end
    self.time = math.max(0, self.time - dt)
    if self.time == 0 and self.finishCallback then
        self.finishCallback()
        self.finishCallback = nil
    end
end

function StopWatch:draw()
    love.graphics.push()
    love.graphics.setColor(self.color)
    love.graphics.setLineWidth(2)
    draft:ellipticArc(self.x, self.y,  self.size, self.size, math.rad(360 * (self.time / assets.config.trialTime)), -math.pi / 2 )
    love.graphics.pop()

end


return StopWatch