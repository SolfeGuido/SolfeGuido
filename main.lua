require("lib.tesound")
_G['Vars'] = require('src.Vars')
local ScreenManager = require('lib.ScreenManager')
local Mobile = require('src.utils.Mobile')
local Theme = require('src.utils.Theme')
local Config = require('src.data.Config')
local StatisticsManager = require('src.data.StatisticsManager')

--- BEGIN DEBUG
local debugGraph = require('lib.debugGraph')
local fpsGraph = nil
local memoryGraph = nil
--- END DEBUG


function love.load()
    Mobile.load()
    Config.parse()
    Theme.init(Config.theme)
    ScreenManager.registerCallbacks({'keypressed', 'touchpressed', 'touchmoved', 'touchreleased'})
    ScreenManager.init({SplashScreenState = require('src.states.SplashScreenState')}, 'SplashScreenState')

--- BEGIN DEBUG
    fpsGraph = debugGraph:new('fps', love.graphics.getWidth() - 200, love.graphics.getHeight() - 100 , 200);
    memoryGraph = debugGraph:new('mem', love.graphics.getWidth() - 200, love.graphics.getHeight() - 50, 200)
--- END DEBUG
end

function love.run()
	love.load(love.arg.parseGameArguments(arg), arg)
    love.math.setRandomSeed(os.time())
	-- We don't want the first frame's dt to include time taken by love.load.
	love.timer.step()
 
    local dt = 0
    local fixed_dt = 1/60
    local accumulator = 0

 
	-- Main loop time.
	return function()
		-- Process events.
        love.event.pump()
        for name, a,b,c,d,e,f in love.event.poll() do
            if name == "quit" then
                return love.quit(a or 0)
            end
            love.handlers[name](a,b,c,d,e,f)
        end
 
		-- Update dt, as we'll be passing it to update
        dt = love.timer.step()
        accumulator = accumulator + dt

        while accumulator >= fixed_dt do
            love.update(fixed_dt)
            accumulator = accumulator - fixed_dt
        end
		-- Call update and draw
		love.update(dt)
 
		if love.graphics.isActive() then
			love.graphics.origin()
			love.graphics.clear(love.graphics.getBackgroundColor())
 
			love.draw()
 
			love.graphics.present()
		end
 
		love.timer.sleep(0.0001)
	end
end

function love.quit(a)
    Config.save()
    StatisticsManager.save()
    return a
end

function love.draw()
    ScreenManager.draw()
--- BEGIN DEBUG
    --love.graphics.setColor(Theme.font)
    --love.graphics.setLineWidth(1)
    --fpsGraph:draw()
    --memoryGraph:draw()
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