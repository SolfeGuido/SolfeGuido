require('src.extensions.run')
require('src.extensions.errorhandler')
require('src.extensions.quit')

_G['Vars'] = require('src.Vars')
local ScreenManager = require('lib.ScreenManager')
local Mobile = require('src.utils.Mobile')
local Theme = require('src.utils.Theme')
local Config = require('src.data.Config')


--- BEGIN DEBUG
local debugGraph = require('lib.debugGraph')
local profile = require('lib.profile')
local fpsGraph = nil
local memoryGraph = nil
--- END DEBUG


function love.load()
    Mobile.load()
    Config.parse()
    Theme.init(Config.theme)
    ScreenManager.registerCallbacks({'keypressed', 'touchpressed', 'touchmoved', 'touchreleased', 'focus'})
    ScreenManager.init({SplashScreenState = require('src.states.SplashScreenState')}, 'SplashScreenState')

--- BEGIN DEBUG
    profile.start()
    fpsGraph = debugGraph:new('fps', love.graphics.getWidth() - 200, love.graphics.getHeight() - 100 , 200)
    memoryGraph = debugGraph:new('mem', love.graphics.getWidth() - 200, love.graphics.getHeight() - 50, 200)
--- END DEBUG
end

function love.draw()
    ScreenManager.draw()
--- BEGIN DEBUG
    love.graphics.setColor(Theme.font)
    love.graphics.setLineWidth(1)
    fpsGraph:draw()
    memoryGraph:draw()
--- END DEBUG
end

function love.update(dt)
    ScreenManager.update(dt)
--- BEGIN DEBUG
    if love.keyboard.isDown('d') then
        local report = profile.report(20)
        print(report)
        profile.reset()
    end
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