local a = "coucou"

---@param a string
function a(a)
    
end

function love.draw()
    love.graphics.print('Hello World!', 400, 300)
end

function love.update(dt)
    print(dt)
end