
local Scene = require('src.scene')
local Draft = require('lib.draft')
local draft = Draft()


---@class PlayScene : Scene
---@field public entities table
---@field public timer Timer
local PlayScene = Scene:extend()

---@param self PlayScene
function PlayScene:init()
    Scene.init(self)
end


---@param self PlayScene
function PlayScene:draw()
    love.graphics.push()
    love.graphics.setColor(1,1,1)
    love.graphics.rectangle('fill', 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

    local middle = love.graphics.getHeight() / 3
    love.graphics.setColor(0,0,0)
    for i = 1,5 do
        love.graphics.line(0, middle + 10 * i, love.graphics.getWidth(), middle +  10 * i)
    end
    love.graphics.print('Hello World!', 400, 300)

    love.graphics.pop()
end

function PlayScene:update(dt)
    Scene.update(self, dt)
end

return PlayScene