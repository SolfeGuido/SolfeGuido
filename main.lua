_G['CONST'] = require('src.constants')


--local PlayState = require('src.scene.play')
local Resources = require('src.resources')

local STATES = {
  --  ['play'] = PlayState('test')
}
_G['Resources'] = Resources()

--local currentState = PlayState()

function love.load()
    math.randomseed(os.time())
end

function love.draw()
  --  currentState:draw()
end

function love.update(dt)
    require('lib.lurker').update()
    --currentState:update(dt)
end

function love.keypressed(key)
    --currentState:keypressed(key)
end