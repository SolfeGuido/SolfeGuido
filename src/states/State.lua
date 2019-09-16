
local Class = require('lib.class')
local Timer = require('lib.timer')
local uuidGenerator = require('src.math')

---@class Scene
---@field public entities table
---@field public timer Timer
local State = Class:extend()

function State:new()
    State.super.new(self)
    self.entities = {}
    self.timer = Timer.new()
    self.paused = false
    self.active = true
end

function State:init(...)

end

function State:isActive()
    return self.active
end

function State:setActive(acv)
    self.active = acv
end

function State:addentity(Type, options)
    local objId = uuidGenerator.uuid()
    self.entities[objId] = Type(self, objId, options)
    return self.entities[objId]
end

---@param self Scene
function State:draw()
    for _,v in pairs(self.entities) do
        v:draw()
    end
end

---@param self Scene
---@param dt number
function State:update(dt)
    if self.paused then return end
    self.timer:update(dt)
    for _,v in pairs(self.entities) do
        v:update(dt)
    end
end

function State:keypressed(key)
    if key == "space" then
        self.paused = not self.paused
    end
end

return State
