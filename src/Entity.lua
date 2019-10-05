

local Class = require('lib.class')

---@class Entity
---@field public area State
---@field public id string
---@field public x number
---@field public y number
local Entity = Class:extend()

function Entity:new(area, options)
    Entity.super.new(self)
    self.area = area
    self.timer = self.area.timer
    self.isDisposed = false
    for k,v in pairs(options) do
        self[k] = v
    end
end

--- Deletes the entity from the area
function Entity:dispose()
    self.timer = nil
    self.area = nil
end

function Entity:update(dt)
end


return Entity