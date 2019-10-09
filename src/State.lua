
--- LIBS
local Class = require('lib.class')
local Timer = require('lib.timer')
local ScreenManager = require('lib.ScreenManager')
local Config = require('src.utils.Config')
local lume = require('lib.lume')

-- ENTITES
local Button = require('src.objects.Button')
local Title = require('src.objects.Title')
local MultiSelector = require('src.objects.MultiSelector')

---@class State
---@field public entities table
---@field public timer Timer
local State = Class:extend()

function State:new()
    State.super.new(self)
    self.entities = {}
    self.timer = Timer()
    self.active = true
end

function State:init(...)

end

function State:addButton(config)
    local btnText = love.graphics.newText(config.font, tr(config.text) )

    if config.state and not config.callback then
        config.callback = function() self:switchState(config.state) end
    end

    return self:addentity(Button, {
        text = btnText,
        x = -btnText:getWidth(),
        y = config.y,
        color = assets.config.color.transparent(),
        callback = config.callback
    })
end

function State:addMultiSelector(config)
    local msText = love.graphics.newText(config.font, tr(config.text) )
    assert(config.config, "Can't create multiselect from something else than configuration")
    local confName = config.config
    return self:addentity(MultiSelector, {
        text = msText,
        x = -msText:getWidth() * 3,
        y = config.y,
        selected = Config[confName] or assets.config.userPreferences[confName][1],
        choices = assets.config.userPreferences[confName],
        color = assets.config.color.transparent(),
        callback = function(value) Config.update(confName, value) end
    })
end

function State:addTitle(config)
    local titleText = love.graphics.newText(config.fontSize and assets.MarckScript(config.fontSize) or config.font, tr(config.text))
    return self:addentity(Title, {
        x = -titleText:getWidth(),
        y = config.y,
        color = assets.config.color.transparent(),
        text = titleText
    })
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

function State:draw()
    for _,v in ipairs(self.entities) do
        v:draw()
    end
end

---@param dt number
function State:update(dt)
    if not self.active then return end
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
    if key == "escape" and self.back then
        self:back()
    else
        self:callOnEntities('keypressed', key)
    end
end

function State:createUI(uiConfig)
    local yPos = love.graphics.getHeight() / 3
    local defaultFont = assets.MarckScript(assets.config.lineHeight)
    local conf = {x = 30, font = defaultFont, type = 'Title'}
    local elements = {}
    for _, column in ipairs(uiConfig) do
        for _, elemConfig in ipairs(column) do
            elemConfig = lume.merge(conf, elemConfig)
            if not elemConfig.y then
                elemConfig.y = yPos
                yPos = yPos + assets.config.lineHeight
            end
            if elemConfig.type ~= 'Space' then
                elements[#elements+1] = {
                    element = self['add' .. elemConfig.type](self, elemConfig),
                    target = {x = elemConfig.x, color = assets.config.color.black()}
                }
            end
        end
        yPos = love.graphics.getHeight() / 3
        conf.x = conf.x + assets.config.limitLine
    end
    self:transition(elements)
end

function State:transition(elements, callback)
    local size = #elements
    self.timer:every(assets.config.transition.spacing, function()
        local data = elements[1]
        table.remove(elements, 1)
        self:addElement(data, #elements == 0 and callback or nil)
    end, size)
end

function State:addElement(data, callback)
    self.timer:tween(assets.config.transition.tween, data.element, data.target, 'out-expo', callback)
end

function State:mousemoved(x, y)
    self:callOnEntities('mousemoved', x, y)
end

function State:mousepressed(x, y, button)
    self:callOnEntities('mousepressed', x, y, button)
end

function State:mousereleased(x, y, button)
    self:callOnEntities('mousereleased', x, y, button)
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
    self.timer = nil
    self.entities = nil
end

function State:switchState(statename)
    self:slideEntitiesOut(function() ScreenManager.switch(statename) end)
end

local yCompare = lume.lambda "a,b -> a.y > b.y"

local function elemSlide(v)
    return {element = v, target = {x = v.width and -v:width() or -20, color = assets.config.color.transparent()}}
end

function State:slideEntitiesOut(callback)
    lume(self.entities)
        :sort(yCompare)
        :map(elemSlide)
        :apply(function(x) self:transition(x, callback) end)
end

return State