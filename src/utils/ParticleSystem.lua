--- All particles related functions
local ParticleSystem = {}

--- Create a particle system for the endgame effect
--- of the notes bursting everywhere
---@param originalColor Color
function ParticleSystem.noteBurstParticles(originalColor)
	local canvas = love.graphics.newCanvas(30, 50)
	canvas:renderTo(function()
		love.graphics.setColor(originalColor)
		love.graphics.draw(love.graphics.newTextBatch(assets.fonts.Icons(30), assets.IconName.Music), 0, 0)
	end)
	local pSystem = love.graphics.newParticleSystem(canvas)
	pSystem:setParticleLifetime(1, 3)
	pSystem:setEmissionRate(5)
	pSystem:setSizeVariation(0.5)
	pSystem:setSizes(1, 0.5)
	pSystem:setLinearAcceleration(0, 125, 0, 125)
	pSystem:setSpeed(100, 600)
	pSystem:setRotation(-math.pi, math.pi)
	pSystem:setSpread(2 * math.pi)
	pSystem:setSpin(-math.pi, math.pi)
	local colorFade = originalColor:clone()
	colorFade.a = 0
	pSystem:setColors(originalColor, colorFade)

	return pSystem
end

--- Creates the particle system used by the stopwatch to show the time running out
---@param originalColor Color the color that the particles need to have
---@return love.ParticleSystem the generated particle system
function ParticleSystem.timeParticles(originalColor)
	local canvas = love.graphics.newCanvas(1, 1)
	canvas:renderTo(function()
		love.graphics.setColor(originalColor)
		love.graphics.points(1, 1)
	end)
	local pSystem = love.graphics.newParticleSystem(canvas, 32)
	pSystem:setParticleLifetime(0.7, 1.5)
	pSystem:setEmissionRate(6)
	pSystem:setSizeVariation(0.4)
	pSystem:setSizes(7, 0)
	pSystem:setLinearAcceleration(0, 125, 0, 125)
	pSystem:setDirection(0)
	pSystem:setSpeed(70, 100)
	pSystem:setRotation(-math.pi, math.pi)
	pSystem:setEmissionArea("uniform", 6, 6, math.pi)
	pSystem:setSpread(0)
	pSystem:setSpin(-math.pi * 2, math.pi * 2)
	local faded = originalColor:clone()
	faded.a = 0
	pSystem:setColors(originalColor, faded)
	return pSystem
end

return ParticleSystem
