_G['assets'] = require('lib.cargo').init('res')

local ScreenManager = require('lib.ScreenManager')

function love.load()
    math.randomseed(os.time())
    local screens = {
        play = require('src.states.PlayState')
    }
    ScreenManager.init(screens, 'play')
end

function love.draw()
    ScreenManager.draw()
end

function love.update(dt)
    require('lib.lurker').update()
    ScreenManager.update(dt)
end

function love.keypressed(key)
    ScreenManager.keypressed(key)
end
