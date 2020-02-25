local Entity = require('src.Entity')

---@class EntityContainer : Entity
local EntityContainer = Entity:extend()

--- Creates a callback that calls the given method
--- on all the container's entities
---@param methodName string
---@return function
local function containerCall(methodName)
    return function(tbl, ...) return tbl:callOnEntities(methodName, ...) end
end

--- Events redirected to entites
EntityContainer.entitiesEvents = {
    'keypressed',
    'mousemoved', 'mousepressed', 'mousereleased',
    'touchpressed', 'touchmoved', 'touchreleased'
}

-- Might add an iterator to directly iterate through entities
function EntityContainer:new(container, options)
    Entity.new(self, container, options)
    self._entities = {}
    if not self.timer then
        self.timer = container.timer
    end
end

--- Inherited function
function EntityContainer:draw()
    for _, e in ipairs(self._entities) do e:draw() end
end

--- Updates all the entities of this container
--- if some entities are found 'dead', they are
--- removed from the container, and disposed
---@param dt number
function EntityContainer:update(dt)
    for v = #self._entities, 1, -1 do
        local entity = self._entities[v]
        entity:update(dt)
        if entity.isDead then
            table.remove(self._entities, v)
            entity:dispose()
        end
    end
end

--- Clears all the entities contained
--- by this container and nils all the
--- attributes
function EntityContainer:dispose()
    for _, e in ipairs(self._entities) do
        e:dispose()
    end
    self._entities = nil
    self.timer = nil
    Entity.dispose(self)
end

--- Adds the given entity to the container
--- it will call the 'Type' constructor
--- and pass it the options
---@param Type function
---@param options table
---@return Entity the constructed entity
function EntityContainer:addEntity(Type, options)
    local ent = Type(self, options)
    self._entities[#self._entities+1] = ent
    return ent
end

--- When an entity already exists, and it
--- should just be inserted in the container
--- this method will update the entities
--- attributes to be linked with the container
---@param entity Entity
---@return Entity
function EntityContainer:insertEntity(entity)
    self._entities[#self._entities+1] = entity
    entity.container = self
    entity.timer = self.timer
    return entity
end

--- Calls the given method on all the entities
--- of this container
---@param method string
---@return boolean wether the given method was successfully callled
--- on an entity
function EntityContainer:callOnEntities(method, ...)
    for i = #self._entities, 1, -1 do
        local entity = self._entities[i]
        if entity[method] and entity[method](entity, ...) then
            return true
        end
    end
    return false
end

--- Setup the event listeners
for _, v in ipairs(EntityContainer.entitiesEvents) do
    EntityContainer[v] = containerCall(v)
end

return EntityContainer