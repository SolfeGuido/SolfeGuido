local Entity = require('src.Entity')
local Timer = require('lib.timer')

---@class EntityContainer : Entity
local EntityContainer = Entity:extend()

local function containerCall(methodName)
    return function(tbl, ...) return tbl:callOnEntities(methodName, ...) end
end

EntityContainer.entitiesEvents = {
    'keypressed',
    'mousemoved', 'mousepressed', 'mousereleased',
    'touchpressed', 'touchmoved', 'touchreleased'
}


function EntityContainer:new(container, options)
    Entity.new(self, container, options)
    self._entities = {}
    if not self.timer then self.timer = Timer() end
end

function EntityContainer:draw()
    for _, e in ipairs(self._entities) do e:draw() end
end

function EntityContainer:update(dt)
    self.timer:update(dt)
    for v = #self._entities, 1, -1 do
        local entity = self._entities[v]
        entity:update(dt)
        if entity.isDead then
            table.remove(self._entities, v)
            entity:dispose()
        end
    end
end

function EntityContainer:dispose()
    for _, e in ipairs(self._entities) do
        e:dispose()
    end
    self._entities = nil
    self.timer:destroy()
    self.timer = nil
    Entity.dispose(self)
end

function EntityContainer:addEntity(Type, options)
    local ent = Type(self, options)
    self._entities[#self._entities+1] = ent
    return ent
end

function EntityContainer:insertEntity(entity)
    self._entities[#self._entities+1] = entity
    entity.container = self
    entity.timer = self.timer
    return entity
end

function EntityContainer:callOnEntities(method, ...)
    for i = #self._entities, 1, -1 do
        local entity = self._entities[i]
        if entity[method] and entity[method](entity, ...) then
            return true
        end
    end
    return false
end


for _, v in ipairs(EntityContainer.entitiesEvents) do
    EntityContainer[v] = containerCall(v)
end

return EntityContainer