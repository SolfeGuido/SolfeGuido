
--- LIBS
local EntityContainer = require('src.objects.EntityContainer')
local Theme = require('src.utils.Theme')
local Timer = require('lib.timer')

local UIBuilder = require('src.objects.UIBuilder')

---@class State : EntityContainer
---@field public timer Timer
---@field protected ui UIBuilder
local State = EntityContainer:extend()

--- Constructor
--- the state is the only class to create
--- a new timer, the timer is then shared among
--- all the entities of the scene
--- thus, only the state must update the timer
function State:new()
    State.super.new(self, {timer = Timer()})
    self.HUD = EntityContainer(self)
    self.active = true
end

--- Called by the screenManager, does not need
--- to be overriden by the subclasses
function State:init() end

--- Called by the screenManager, does not need
--- to be overriden by the subclasses
function State:focus(_) end

--- creates a UIBuilder, adds it as
--- an attribute, and returns it to allow
--- method chaining
---@param options table
---@return UIBuilder
function State:startUI(options)
    self.ui = self:addEntity(UIBuilder, options)
    return self.ui
end

--- Accessor toe the active for the screenManager
--- a state is active when it's on top of the stack
---@return boolean
function State:isActive()
    return self.active
end

--- Setter for the active attribute,
--- for the screenManager
---@param acv boolean
function State:setActive(acv)
    self.active = acv
end

--- The HUD is drawn above everything else
--- some entities can be added as HUD to ensure
--- that they are drawn last
--- currently only used by the pause button
--- in-game
---@param Type function(constructor)
---@param options table
function State:addHUD(Type, options)
    self.HUD:addEntity(Type, options)
end

--- Inherited method
--- Sets the background, draws the contained entities
--- then draws the HUD entities
function State:draw()
    love.graphics.setBackgroundColor(Theme.background)
    EntityContainer.draw(self)
    self.HUD:draw()
end

--- Updates the timer, then updates the contained
--- entities
--- then the HUD entities
---@param dt number
function State:update(dt)
    self.timer:update(dt)
    EntityContainer.update(self, dt)
    self.HUD:update(dt)
end

--- Transitions (probably to another state)
--- Every given elements are transitioned to the
--- given state
function State:transition(elements, callback, spacing)
    spacing = spacing or Vars.transition.spacing
    local size = #elements
    self.timer:every(spacing, function()
        local data = elements[1]
        table.remove(elements, 1)
        self:addElement(data, #elements == 0 and callback or nil)
    end, size)
end

--- Transitions the given element
---@param data table
---@param callback function?
function State:addElement(data, callback)
    self.timer:tween(data.time or Vars.transition.tween, data.element, data.target, 'out-expo', callback)
end

--- Called by the screenManager when the
--- state is disposed, calls dispose
--- of every entities, destroys the timer
--- and disposes the HUD
function State:close()
    self.HUD:dispose()
    self.ui = nil
    self.timer:destroy()
    EntityContainer.dispose(self)
end

--- Reroute all the events
--- to first call the HUD, then the state itself
for _, v in ipairs(EntityContainer.entitiesEvents) do
    State[v] = function (tbl, ...)
        return tbl.HUD[v](tbl.HUD, ...) or
                EntityContainer[v](tbl, ...)
    end
end

return State