
local Scene = require('src.scene')


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
    love.graphics.print('Hello World!', 400, 300)
end

function PlayScene:update(dt)
    print("self = ", self)
    Scene.update(self, dt)
end

return PlayScene