
local Class = require('lib.class')
local Timer = require('lib.timer')
local uuidGenerator = require('src.math')

---@class Scene
---@field public entities table
---@field public timer Timer
local Scene = Class:extend()

function Scene:new()
    Scene.super.new(self)
    self.entities = {}
    self.timer = Timer.new()
    self.paused = false

end

function Scene:addentity(Type, ...)
    local objId = uuidGenerator.uuid()
    self.entities[objId] = Type(self, objId, ...)
    return self.entities[objId]
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
    if self.paused then return end
    self.timer:update(dt)
    for _,v in pairs(self.entities) do
        v:update(dt)
    end
end

function Scene:keypressed(key)
    if key == "space" then
        self.paused = not self.paused
    end
end

return Scene
