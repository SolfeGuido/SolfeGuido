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

		if love.graphics.isActive() then
			love.graphics.origin()
			love.graphics.clear(love.graphics.getBackgroundColor())

			love.draw()
			love.graphics.present()
		end

		love.timer.sleep(0.001)
	end
end