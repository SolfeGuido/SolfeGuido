
local Class = require('lib.class')
local Scene = require('src.scene')


---@class PlayScene : Scene
---@field public entities table
---@field public timer Timer
local PlayScene = Class {__includes=Scene,
    ---@param self PlayScene
    init = function(self)

    end
}


---@param self PlayScene
function PlayScene:draw(self)
    love.graphics.print('Hello World!', 400, 300)
end

return PlayScene