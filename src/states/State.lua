
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
    self.timer = Timer()
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
    local ent = Type(self, options)
    self.entities[ent.id] = ent
    return ent
end

function State:draw()
    for _,v in pairs(self.entities) do
        v:draw()
    end
end

---@param dt number
function State:update(dt)
    if not self.active then return end
    self.timer:update(dt)
    for _,v in pairs(self.entities) do
        v:update(dt)
    end
end

function State:keypressed(key)
end

function State:transition(elements, callback)
    local size = #elements
    self.timer:every(assets.config.transition.spacing, function()
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
    self.timer:tween(assets.config.transition.tween, data.element, data.target, 'out-expo', callback)

end

function State:mousemoved(x, y)

end

function State:mousepressed(x, y, button)

end

function State:mousereleased(x, y, button)

end

function State:close()
    self.entities = {}
end

return State