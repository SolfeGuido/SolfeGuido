_G['assets'] = require('lib.cargo').init('res')

local debugGraph = require('lib.debugGraph')
local fpsGraph = nil
local memoryGraph = nil
local ScreenManager = require('lib.ScreenManager')

function love.load()
    math.randomseed(os.time())
    local screens = {
        play = require('src.states.PlayState'),
        menu = require('src.states.MenuState')
    }
    ScreenManager.init(screens, 'menu')
    fpsGraph = debugGraph:new('fps', love.graphics.getWidth() - 200, 0 , 200)
    memoryGraph = debugGraph:new('mem', love.graphics.getWidth() - 200, 50, 200)
end

function love.draw()
    ScreenManager.draw()
    fpsGraph:draw()
    memoryGraph:draw()
end

function love.update(dt)
    --require('lib.lurker').update()
    fpsGraph:update(dt)
    memoryGraph:update(dt)
    ScreenManager.update(dt)
end

function love.keypressed(key)
    ScreenManager.keypressed(key)
end

function love.mousemoved(x,y)
    ScreenManager.mousemoved(x, y)
end