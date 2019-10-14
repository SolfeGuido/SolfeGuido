require "lib.tesound"
local ScreenManager = require('lib.ScreenManager')
local Color = require('src.utils.Color')
local Mobile = require('src.utils.Mobile')

--- BEGIN DEBUG
local debugGraph = require('lib.debugGraph')
local fpsGraph = nil
local memoryGraph = nil
--- END DEBUG


function love.load()
    Mobile.load()
    ScreenManager.init({SplashScreenState = require('src.states.SplashScreenState')}, 'SplashScreenState')

--- BEGIN DEBUG
    fpsGraph = debugGraph:new('fps', love.graphics.getWidth() - 200, 0 , 200);
    memoryGraph = debugGraph:new('mem', love.graphics.getWidth() - 200, 50, 200)
--- END DEBUG
end

function love.draw()
    ScreenManager.draw()
--- BEGIN DEBUG
    love.graphics.setColor(Color.black)
    fpsGraph:draw()
    memoryGraph:draw()
--- END DEBUG
end

function love.update(dt)
    TEsound.cleanup()
    ScreenManager.update(dt)
--- BEGIN DEBUG
    --require('lib.lurker').update()
    fpsGraph:update(dt)
    memoryGraph:update(dt)
--- END DEBUG
end

function love.mousemoved(x,y, _, _, istouch)
    if not istouch then
        ScreenManager.mousemoved(x, y)
    end
end

function love.mousepressed(x, y, button, istouch)
    if not istouch then
        ScreenManager.mousepressed(x, y, button)
    end
end

function love.mousereleased(x, y, button, istouch)
    if not istouch then
        ScreenManager.mousereleased(x, y, button)
    end
end
love.keypressed = ScreenManager.keypressed
love.touchpressed = ScreenManager.touchpressed
love.touchmoved = ScreenManager.touchmoved
love.touchreleased = ScreenManager.touchreleased