
local Entity = require('src.Entity')
local Theme = require('src.utils.Theme')
local UIFactory = require('src.utils.UIFactory')
local lume = require('lib.lume')
local Rectangle = require('src.utils.Rectangle')

---@class Drawer : Entity
local Drawer = Entity:extend()

function Drawer:new(area, options)
    Entity.new(self, area, options)
    self.color = Theme.font:clone()
    self.isShown = false
    self.animation = nil
    self.touchId = nil
end

function Drawer:contains(x, y)
    return Rectangle(self.x, self.y, self.width, self.height):contains(x, y)
end

function Drawer:keypressed(key)
    if self.isShown and key == "escape" then
        return self:applyChanges()
    end
    return false
end

function Drawer:applyChanges(btn)
    if btn then btn.consumed = false end
    self.touchId = nil
    if self.originSelection ~= self.selected then
        self.callback(self)
    end
    self:hide()
    return true
end

function Drawer:mousepressed(x, y, button)
    if self.isShown and not self:contains(x, y) and button == 1 then
        self.touchId = button
        return true
    end
    return false
end

function Drawer:mousereleased(x, y, button)
    if self.isShown and not self:contains(x, y) and button == 1 and self.touchId then
        return self:applyChanges()
    end
    return false
end

function Drawer:touchpressed(id, x, y)
    if self.isShown and not self.touchId and not self:contains(x, y) then
        self.touchId = id
        return true
    end
    return false
end

function Drawer:touchreleased(id, x, y)
    if self.isShown and self.touchId == id and not self:contains(x, y) then
        return self:applyChanges()
    end
    return false
end

function Drawer:init(options)
    self.callback = options.callback or function() end
    self.padding = (self.height - Vars.titleSize) / 2
    self.childs = {
        UIFactory.createIconButton(self.area, {
            x = self.x,
            y = self.y + self.padding - 2,
            padding = 2,
            icon = 'Times',
            framed = true,
            color = Theme.font:clone(),
            callback = function(btn)
                btn.consumed = false
                self.selected = options.selected
                for _, child in ipairs(self.childs) do
                    if child.value == options.selected then
                        child:check()
                    elseif child.uncheck then
                        child:uncheck()
                    end
                end
                self:hide()
            end
        })
    }
    self.originSelection = options.selected
    self.selected = options.selected
    for i, v in ipairs(options.choices) do
        self.childs[#self.childs+1] = UIFactory.createRadioButton(self.area, {
            x = self.x + i * Vars.titleSize,
            y = self.y + 1,
            color = Theme.font:clone(),
            isChecked = options.selected == v.configValue,
            value = v.configValue,
            icon = v.icon,
            image = v.image,
            padding = math.floor(self.padding) -1,
            callback = function(btn)
                btn.consumed = false
                if not btn.isChecked then
                    for _, child in ipairs(self.childs) do
                        if child == btn then
                            child:check()
                        elseif child.uncheck then
                            child:uncheck()
                        end
                    end
                    self.selected = v.configValue
                end
            end
        })
    end

    self.childs[#self.childs+1] = UIFactory.createIconButton(self.area, {
        y = self.y + self.padding - 2,
        icon = 'Check',
        padding = 2,
        framed = true,
        color = Theme.font:clone(),
        x = self.x + (Vars.titleSize + self.padding * 2) * (#options.choices + 1),
        callback = function(btn) self:applyChanges(btn) end
    })

    self.width = self.padding * 2 + lume.reduce(self.childs, function(acc, b)
            return acc + b:width()
    end, 0)
end

function Drawer:changeXPosition(nwX, callback)
    if self.animation then
        self.timer:cancel(self.animation)
    end
    self.animation = self.timer:tween(Vars.transition.tween, self, {x = nwX}, 'out-expo', function()
        self.animation = nil
        if callback then callback() end
    end)
end

function Drawer:show()
    self.isShown = true
    self:changeXPosition(love.graphics.getWidth() - self.width)
end

function Drawer:hide()
    self:changeXPosition(love.graphics.getWidth() + 5, function()
        self.isShown = false
    end)
end

function Drawer:draw()
    if not self.isShown then return end
    love.graphics.setColor(Theme.background)
    love.graphics.rectangle('fill', self.x, self.y, self.width + 10, self.height)

    love.graphics.setColor(self.color)
    love.graphics.rectangle('line', self.x, self.y, self.width + 10, self.height)
end

function Drawer:update(_)
    local x = self.x + self.padding - 2
    for _, v in ipairs(self.childs) do
        v.x = x
        x = x + v:width() + 2
    end
end

return Drawer