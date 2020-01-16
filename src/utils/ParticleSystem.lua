local ParticleSystem = {}

function ParticleSystem.noteBurstParticles(originalColor)
    local canvas = love.graphics.newCanvas(30, 50)
    canvas:renderTo(function()
        love.graphics.setColor(originalColor)
        love.graphics.draw(love.graphics.newText(assets.fonts.Icons(30),assets.IconName.Music), 0, 0)
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

return ParticleSystem