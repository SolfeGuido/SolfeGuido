

local Entity = require('src.Entity')
local Theme = require('src.utils.Theme')
local Config = require('src.utils.Config')

---@class StopWatch : Entity
---@field private color Color
---@field private currentTime number
---@field private totalTime number
local StopWatch = Entity:extend()

local equivalences = {
    ['30s'] = 30,
    ['1mn'] = 60,
    ['2mn'] = 120,
    ['5mn'] = 300
}


function StopWatch:new(area, config)
    Entity.new(self, area, config)
    self.color = Theme.secondary:clone()
    self.totalTime = equivalences[Config.time] or 60
    self.currentTime = self.totalTime
    self.subTime = self.totalTime
    self.tween = nil
end

function StopWatch:start()
    self.started = true
end

---@param dt number
function StopWatch:update(dt)
    if not self.started then return end
    self.currentTime = math.max(0, self.currentTime - dt)
    if not self.tween then
        self.subTime = self.currentTime
    end
    if self.currentTime == 0 and self.finishCallback then
        self.finishCallback()
        self.finishCallback = nil
    end
end

function StopWatch:looseTime(dt)
    local time = 1
    if self.tween then self.timer:cancel(self.tween) end
    self.tween = self.timer:tween(time, self, {subTime = self.currentTime - dt - time}, 'out-quad', function()
        self.tween = nil
    end)
    self:update(dt)
end

function StopWatch:draw()
    love.graphics.setLineWidth(3)

    love.graphics.setColor(Theme.wrong)
    local width = ( math.max(self.currentTime, self.subTime) / self.totalTime) * love.graphics.getWidth()
    love.graphics.line(0,2, width, 2)

    love.graphics.setColor(self.color)
    width = (self.currentTime / self.totalTime) * love.graphics.getWidth()
    love.graphics.line(0,2, width, 2)

    love.graphics.setLineWidth(1)
end


return StopWatch