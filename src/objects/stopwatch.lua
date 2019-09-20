

local Entity = require('src.entity')

local Draft = require('lib.draft')
local draft = Draft()

---@class StopWatch : Object
---@field private color table
---@field private time number
local StopWatch = Entity:extend()

function StopWatch:new(area, id, config)
    Entity.new(self, area, id, config)
    self.color = assets.config.timer.startColor
    self.area.timer:tween(assets.config.trialTime, self, {color = assets.config.timer.endColor})
    self.time = assets.config.trialTime
end

---@param dt number
function StopWatch:update(dt)
    self.time = math.max(0, self.time - dt)
    if self.time == 0 and self.finishCallback then
        self.finishCallback()
        self.finishCallback = nil
    end
end

function StopWatch:draw()
    love.graphics.push()
    love.graphics.setColor(unpack(self.color))
    love.graphics.setLineWidth(2)
    draft:ellipticArc(self.x, self.y,  self.size, self.size, math.rad(360 * (self.time / assets.config.trialTime)), -math.pi / 2 )
    love.graphics.pop()

end


return StopWatch