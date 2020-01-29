

local Class = require('lib.class')

---@class Entity
---@field public container State
---@field public id string
---@field public x number
---@field public y number
local Entity = Class:extend()

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

function Entity:update() end
function Entity:draw() end


return Entity