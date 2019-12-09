
--- LIBS
local Class = require('lib.class')
local Timer = require('lib.timer')
local ScreenManager = require('lib.ScreenManager')
local lume = require('lib.lume')
local Theme = require('src.utils.Theme')

---@class State
---@field public entities table
---@field public timer Timer
local State = Class:extend()

local function stateCall(methodName)
    return function(tbl, ...) return tbl:callOnEntities(methodName, ...) end
end
local redirectedevents = {'keypressed', 'mousemoved', 'mousepressed', 'mousereleased', 'touchpressed', 'touchmoved', 'touchreleased'}

function State:new()
    State.super.new(self)
    self.entities = {}
    self.HUD = {}
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

function State:addHUD(Type, options, ...)
    local widget = Type(self, options, ...)
    self.HUD[#self.HUD+1] = widget
    return widget
end

function State:addentity(Type, options, ...)
    local ent = Type(self, options, ...)
    self.entities[#self.entities+1] = ent
    return ent
end

function State:insertEntity(entity)
    self.entities[#self.entities+1] = entity
    entity.area = self
    entity.timer = self.timer
    return entity
end


function State:draw()
    love.graphics.setBackgroundColor(Theme.background)
    for _,v in ipairs(self.entities) do v:draw() end
    for _,v in ipairs(self.HUD) do v:draw() end
end

---@param dt number
function State:update(dt)
    self.timer:update(dt)
    for _,v in ipairs(self.HUD) do
        v:update()
    end
    for v = #self.entities, 1, -1 do
        local entity = self.entities[v]
        entity:update(dt)
        if entity.isDead then
            table.remove(self.entities, v)
            entity:dispose()
        end
    end
end

function State:transition(elements, callback, spacing)
    spacing = spacing or Vars.transition.spacing
    local size = #elements
    self.timer:every(spacing, function()
        local data = elements[1]
        table.remove(elements, 1)
        self:addElement(data, #elements == 0 and callback or nil)
    end, size)
end

function State:addElement(data, callback)
    self.timer:tween(data.time or Vars.transition.tween, data.element, data.target, 'out-expo', callback)
end

function State:callOnEntities(method, ...)
    for i = #self.HUD, 1, -1 do
        local entity = self.HUD[i]
        if entity[method] and entity[method](entity, ...) then
            return true
        end
    end
    for i = #self.entities, 1, -1 do
        local entity = self.entities[i]
        if entity[method] and entity[method](entity, ...) then
            return true
        end
    end
    return false
end

function State:close()
    for i = #self.HUD, 1, -1 do
        self.HUD[i]:dispose()
        table.remove(self.HUD, i)
    end
    for i = #self.entities, 1, -1 do
        self.entities[i]:dispose()
        table.remove(self.entities, i)
    end
    self.timer:destroy()
    self.timer = nil
    self.entities = nil
    self.HUD = nil
end

for _, v in ipairs(redirectedevents) do
    State[v] = stateCall(v)
end

return State