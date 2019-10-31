

local Entity = require('src.Entity')
local Color = require('src.utils.Color')
local Config = require('src.utils.Config')

local Draft = require('lib.draft')
local draft = Draft()

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
    self.color = Color.watchStart:clone()
    self.totalTime = equivalences[Config.time] or 60
    self.currentTime = self.totalTime
end

function StopWatch:start()
    self.started = true
    --self.timer:tween(self.totalTime, self, {color = Color.watchEnd})
end

---@param dt number
function StopWatch:update(dt)
    if not self.started then return end
    self.currentTime = math.max(0, self.currentTime - dt)
    if self.currentTime == 0 and self.finishCallback then
        self.finishCallback()
        self.finishCallback = nil
    end
end

function StopWatch:draw()
    love.graphics.setColor(self.color)
    love.graphics.setLineWidth(3)
    local width = (self.currentTime / self.totalTime) * love.graphics.getWidth()
    love.graphics.line(0,2, width, 2)
    love.graphics.setLineWidth(1)
end


return StopWatch