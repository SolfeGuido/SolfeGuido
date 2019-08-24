

local Class = require('lib.class')

---@class Object
---@field public area Scene
---@field public id string
---@field public x number
---@field public y number
local Entity = Class:extend()

function Entity:new(area, id, x, y)
    Entity.super.new(self)
    self.id = id
    self.area = area
    self.x = x
    self.y = y
end

function Entity:dispose()
    self.area.entities[self.id] = nil
end

return Entity