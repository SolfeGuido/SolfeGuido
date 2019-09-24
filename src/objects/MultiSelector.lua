local Entity = require('src.entity')

---@class MultiSelector : Entity
local MultiSelector = Entity:extend()

function MultiSelector:new(area, options)
    Entity.new(self, area, options)
end

function MultiSelector:draw()
end

function MultiSelector:update(dt)
end

return MultiSelector