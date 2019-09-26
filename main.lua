_G['assets'] = require('lib.cargo').init('res')

local debugGraph = require('lib.debugGraph')
local fpsGraph = nil
local memoryGraph = nil
local ScreenManager = require('lib.ScreenManager')
local Config = require('src.Config')

function love.load()
    math.randomseed(os.time())
    local screens = {
        PlayState = require('src.states.PlayState'),
        MenuState = require('src.states.MenuState'),
        PauseState = require('src.states.PauseState'),
        OptionsState  = require('src.states.OptionsState'),
        ScoreState = require('src.states.ScoreState'),
        CreditsState = require('src.states.CreditsState'),
        EndGameState = require('src.states.EndGameState'),
        HelpState = require('src.states.HelpState')
    }
    ScreenManager.init(screens, 'MenuState')
    fpsGraph = debugGraph:new('fps', love.graphics.getWidth() - 200, 0 , 200);
    memoryGraph = debugGraph:new('mem', love.graphics.getWidth() - 200, 50, 200)
    Config.parse()
end

function love.draw()
    ScreenManager.draw()
    love.graphics.setColor(assets.config.color.black)
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

function love.mousepressed(x, y, button)
    ScreenManager.mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
    ScreenManager.mousereleased(x, y, button)
end