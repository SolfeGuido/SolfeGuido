

local Class = require('lib.class')

---@class Entity
---@field public area State
---@field public id string
---@field public x number
---@field public y number
local Entity = Class:extend()

function Entity:new(area, id, options)
    Entity.super.new(self)
    self.id = id
    self.area = area
    for k,v in pairs(options) do
        self[k] = v
    end
end

--- Deletes the entity from the area
function Entity:dispose()
    self.area.entities[self.id] = nil
end

function Entity:update(dt)

end

return Entity