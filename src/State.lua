
--- LIBS
local EntityContainer = require('src.objects.EntityContainer')
local Theme = require('src.utils.Theme')

local UIBuilder = require('src.objects.UIBuilder')

---@class State
---@field public entities table
---@field public timer Timer
local State = EntityContainer:extend()

function State:new()
    State.super.new(self)
    self.HUD = EntityContainer()
    self.active = true
end

function State:init() end

function State:focus(_) end

function State:startUI(options)
    self.ui = self:addEntity(UIBuilder, options)
    return self.ui
end

function State:isActive()
    return self.active
end

function State:setActive(acv)
    self.active = acv
end

function State:addHUD(Type, options)
    self.HUD:addEntity(Type, options)
end

function State:draw()
    love.graphics.setBackgroundColor(Theme.background)
    EntityContainer.draw(self)
    self.HUD:draw()
end

---@param dt number
function State:update(dt)
    EntityContainer.update(self, dt)
    self.HUD:update(dt)
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


function State:close()
    self.HUD:dispose()
    self.ui = nil
    EntityContainer.dispose(self)
end


return State