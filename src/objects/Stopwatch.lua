local Entity = require("src.Entity")
local Theme = require("src.utils.Theme")
local Config = require("src.data.Config")

--- Entity used when playing a game against the clock
--- is show on top of the screen, showing how much time
--- is left before the end of the game
---@class StopWatch : Entity
---@field private color Color
---@field private currentTime number
---@field private totalTime number
local StopWatch = Entity:extend()

local equivalences = {
	["30s"] = 30,
	["1mn"] = 60,
	["2mn"] = 120,
	["5mn"] = 300,
}

--- Constructor
---@param container EntityContainer
---@param config table
function StopWatch:new(container, config)
	Entity.new(self, container, config)
	self.color = Theme.secondary:clone()
	self.totalTime = equivalences[Config.time] or 60
	self.currentTime = self.totalTime
	self.subTime = self.totalTime
	self.tween = nil
	local safeX, _, safeW, _ = love.window.getSafeArea()
	self.xStart = safeX + Vars.mobileButton.padding
	self.xEnd = safeW - Vars.mobileButton.padding
	self.y = 3
end

function StopWatch:hide()
	self.timer:tween(Vars.transition.tween, self, { y = -5 }, "out-expo")
end
--- Enable the stopwatch,
--- will now diminish it's time every update call
function StopWatch:start()
	self.started = true
end

--- Diminish  the remaining time when activated
--- Also calls the finished callback when the timer
--- reaches 0
---@param dt number
function StopWatch:update(dt)
	if not self.started then
		return
	end
	self.currentTime = math.max(0, self.currentTime - dt)
	if not self.tween then
		self.subTime = self.currentTime
	end
	if self.currentTime == 0 and self.finishCallback then
		self.finishCallback()
		self.finishCallback = nil
	end
end

--- When the user gives a wrong answer,
--- triggers an animation, and diminshes
--- the time by the given dt
---@param dt number
function StopWatch:looseTime(dt)
	local time = 1
	if self.tween then
		self.timer:cancel(self.tween)
	end
	self.tween = self.timer:tween(time, self, { subTime = self.currentTime - dt - time }, "out-quad", function()
		self.tween = nil
	end)
	self:update(dt)
end

--- Inherited method
function StopWatch:draw()
	love.graphics.setLineWidth(6)

	-- Draw the black outlines
	love.graphics.setColor(Theme.font)
	love.graphics.line(0, self.y, self.xStart, self.y)
	love.graphics.line(self.xEnd, self.y, love.graphics.getWidth(), self.y)

	love.graphics.setColor(Theme.wrong)
	local width = (math.max(self.currentTime, self.subTime) / self.totalTime) * (self.xEnd - self.xStart)
	love.graphics.line(self.xStart, self.y, width + self.xStart, self.y)

	love.graphics.setColor(self.color)

	width = (self.currentTime / self.totalTime) * (self.xEnd - self.xStart)
	love.graphics.line(self.xStart, self.y, width + self.xStart, self.y)

	love.graphics.setLineWidth(0.5)
	love.graphics.setColor(Theme.font)
	love.graphics.line(0, self.y + 3.5, love.graphics.getWidth(), self.y + 3.5)
	love.graphics.line(0, self.y - 2.5, love.graphics.getWidth(), self.y - 2.5)

	love.graphics.setLineWidth(1)
end

return StopWatch
