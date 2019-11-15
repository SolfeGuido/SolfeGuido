
--- LIBS
local Class = require('lib.class')
local Timer = require('lib.timer')
local ScreenManager = require('lib.ScreenManager')
local lume = require('lib.lume')
local Theme = require('src.utils.Theme')
local Mobile = require('src.utils.Mobile')
local UIFactory = require('src.utils.UIFactory')

---@class State
---@field public entities table
---@field public timer Timer
local State = Class:extend()

local function stateCall(methodName)
    return function(tbl, ...) return tbl:callOnEntities(methodName, ...) end
end
local redirectedevents = {'mousemoved', 'mousepressed', 'mousereleased', 'touchpressed', 'touchmoved', 'touchreleased'}

function State:new()
    State.super.new(self)
    self.entities = {}
    self.timer = Timer()
    self.active = true
end

function State:init(...)

end

function State:isActive()
    return self.active
end

function State:setActive(acv)
    self.active = acv
end

function State:addentity(Type, options, ...)
    local ent = Type(self, options, ...)
    self.entities[#self.entities+1] = ent
    return ent
end

function State:insertEntity(entity)
    self.entities[#self.entities+1] = entity
    entity.area = self
    entity.timer = self.timer
    return entity
end

function State:draw()
    love.graphics.setBackgroundColor(Theme.background)
    for _,v in ipairs(self.entities) do
        v:draw()
    end
end

---@param dt number
function State:update(dt)
    self.timer:update(dt)
    for v = #self.entities, 1, -1 do
        local entity = self.entities[v]
        entity:update(dt)
        if entity.isDead then
            table.remove(self.entities, v)
            entity:dispose()
        end
    end
end

function State:keypressed(key)
    self:callOnEntities('keypressed', key)
end

function State:createUI(uiConfig)
    local yPos = Vars.baseLine + Vars.lineHeight
    local defaultFont = assets.MarckScript(Vars.lineHeight)
    local conf = {x = 30, font = defaultFont, type = 'Title', platform = "all"}
    local elements = {}
    for _, column in ipairs(uiConfig) do
        for _, elemConfig in ipairs(column) do
            elemConfig = lume.merge(conf, elemConfig)
            if Mobile.canBeAdded(elemConfig.platform) then
                if not elemConfig.y then
                    elemConfig.y = yPos
                    yPos = yPos + Vars.lineHeight
                end
                local target = {color = Theme.font}
                if elemConfig.x ~= -math.huge then target.x = elemConfig.x end
                elements[#elements+1] = {
                    element = UIFactory['create' .. elemConfig.type](self, elemConfig),
                    target = target
                }
            end
        end
        yPos = Vars.baseLine + Vars.lineHeight
        conf.x = conf.x + Vars.limitLine
    end
    self:transition(elements)
end

function State:transition(elements, callback, spacing)
    spacing = spacing or Vars.transition.spacing
    local size = #elements
    self.timer:every(Vars.transition.spacing, function()
        local data = elements[1]
        table.remove(elements, 1)
        self:addElement(data, #elements == 0 and callback or nil)
    end, size)
end

function State:addElement(data, callback)
    self.timer:tween(data.time or Vars.transition.tween, data.element, data.target, 'out-expo', callback)
end

function State:callOnEntities(method, ...)
    for _,v in ipairs(self.entities) do
        if v[method] then v[method](v, ...) end
    end
end

function State:close()
    for i = #self.entities, 1, -1 do
        self.entities[i]:dispose()
        table.remove(self.entities, i)
    end
    self.timer:destroy()
    self.timer = nil
    self.entities = nil
end

function State:switchState(statename)
    self:slideEntitiesOut(function() ScreenManager.switch(statename) end)
end

local yCompare = lume.lambda "a,b -> a.y > b.y"

local function elemSlide(v)
    local x = -20
    if v.width then
        if type(v.width) == "number" then
            x = -v.width
        elseif type(v.width) == "function" then
            x = -v:width()
        end
    end
    return {element = v, target = {x = x, color = Theme.transparent}}
end

function State:slideEntitiesOut(callback)
    lume(self.entities)
        :sort(yCompare)
        :map(elemSlide)
        :apply(function(x) self:transition(x, callback) end)
end

for _, v in ipairs(redirectedevents) do
    State[v] = stateCall(v)
end

return State