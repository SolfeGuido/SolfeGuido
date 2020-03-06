

local Class = require('lib.class')

--- Core class of the framework
--- contains a position (x,y)
--- and a parent (entityContiner)
---@class Entity
---@field public container EntityContainer
---@field public x number
---@field public y number
local Entity = Class:extend()

--- Constructor, used by a lot of subentities
--- the given container is used as this entity's parent
--- and all the keys of the given options are used
--- as field for the entity
---@param container EntityContainer
---@param options table
function Entity:new(container, options)
    Entity.super.new(self)
    self.container = container
    self.timer = container and container.timer or nil
    self.isDead = false
    if options then
        for k,v in pairs(options) do
            self[k] = v
        end
    end
end

--- Deletes the entity from the container
function Entity:dispose()
    self.timer = nil
    self.container = nil
end

--- Non abstract method, does not
--- have to be overriden by the subclasses
function Entity:update() end

--- Non abstract method, does
--- not have to be overriden by the subclasses
function Entity:draw() end


return Entity