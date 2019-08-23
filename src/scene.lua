
local Class = require('lib.class')
local Timer = require('lib.timer')

---@class Scene
---@field public entities table
---@field public timer Timer
local Scene = Class:extend()

function Scene:new()
    print(self)
    self.entities = {}
    self.timer = Timer.new()

end

---@param self Scene
function Scene:draw()
    for _,v in pairs(self.entities) do
        v:draw()
    end
end

---@param self Scene
---@param dt number
function Scene:update(dt)
    self.timer:update(dt)
    for _,v in pairs(self.entities) do
        v:update(dt)
    end
end


return Scene
