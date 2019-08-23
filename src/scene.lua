
local Class = require('lib.class')
local Timer = require('lib.timer')

---@class Scene
---@field public entities table
---@field public timer Timer
local Scene = Class {
    init = function(self)

    end,
    ---@
    entities = {},
    timer = Timer.new()
}

---@param self Scene
function Scene:draw(self)
    for _,v in pairs(self.entities) do
        v:draw()
    end
end

---@param self Scene
---@param dt number
function Scene:update(self, dt)
    self.timer:update(dt)
    for _,v in pairs(self.entities) do
        v:update(dt)
    end
end


return Scene
