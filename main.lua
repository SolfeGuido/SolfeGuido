
local PlayState = require('src.scene.play')

local STATES = {
    ['play'] = PlayState('test')
}

local currentState = PlayState('test')

function love.draw()
    currentState:draw()
end

function love.update(dt)
    currentState:update(dt)
end