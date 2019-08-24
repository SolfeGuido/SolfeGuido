
local PlayState = require('src.scene.play')

local STATES = {
    ['play'] = PlayState('test')
}

local currentState = PlayState()

function love.draw()
    currentState:draw()
end

function love.update(dt)
    require('lib.lurker').update()
    currentState:update(dt)
end