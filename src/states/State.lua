
local Class = require('lib.class')
local Timer = require('lib.timer')
local uuidGenerator = require('src.math')

---@class State
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

function State:draw()
    for _,v in pairs(self.entities) do
        v:draw()
    end
end

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

function State:transition(elements, callback)
    local size = #elements
    self.timer:every(0.1, function()
        local data = elements[1]
        table.remove(elements, 1)
        if #elements == 0 and callback then
            self:addElement(data, callback)
        else
            self:addElement(data)
        end
    end, size)
end

function State:addElement(data, callback)
    self.timer:tween(1, data.element, data.target, 'out-expo', callback)

end

function State:mousemoved(x, y)

end

function State:mousepressed(x, y, button)

end

function State:mousereleased(x, y, button)

end

function State:close()

end

return State
