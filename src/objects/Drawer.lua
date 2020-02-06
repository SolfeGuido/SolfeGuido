
local EntityContainer = require('src.objects.EntityContainer')
local Theme = require('src.utils.Theme')
local UIFactory = require('src.utils.UIFactory')
local RadioButtonGroup = require('src.objects.RadioButtonGroup')

---@class Drawer : Entity
local Drawer = EntityContainer:extend()

function Drawer:new(container, options)
    EntityContainer.new(self, container, options)
    self.color = Theme.font:clone()
    self.isShown = false
    self.animation = nil
    self.touchId = nil
end

function Drawer:contains(x, y)
    return self.x <= x and (self.x + self.width) >= x and
            self.y <= y and (self.y + self.height) >= y
end

function Drawer:keypressed(key)
    if self.isShown and key == "escape" then
        return self:applyChanges()
    end
    return EntityContainer.keypressed(self, key)
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

function Drawer:mousemoved(x ,y)
    return EntityContainer.mousemoved(self, x - self.x, y - self.y)
end

function Drawer:mousepressed(x, y, button)
    if self.isShown and not self:contains(x, y) and button == 1 then
        self.touchId = button
        return true
    end
    return EntityContainer.mousepressed(self, x - self.x, y - self.y, button)
end

function Drawer:mousereleased(x, y, button)
    if self.isShown and not self:contains(x, y) and button == 1 and self.touchId then
        return self:applyChanges()
    end
    return EntityContainer.mousereleased(self, x - self.x, y - self.y, button)
end

function Drawer:touchpressed(id, x, y)
    if self.isShown and not self.touchId and not self:contains(x, y) then
        self.touchId = id
        return true
    end
    return EntityContainer.touchpressed(self, id, x - self.x, y - self.y)
end

function Drawer:touchreleased(id, x, y)
    if self.isShown and self.touchId == id and not self:contains(x, y) then
        return self:applyChanges()
    end
    return EntityContainer.touchreleased(self, id, x - self.x, y - self.y)
end

function Drawer:init(options)
    self.callback = options.callback or function() end
    self.padding = (self.height - Vars.titleSize) / 2
    local xPos = UIFactory.createIconButton(self, {
            x = self.padding / 2,
            y = self.padding - 2,
            padding = 2,
            icon = 'Times',
            framed = true,
            color = Theme.font:clone(),
            callback = function(btn)
                btn.consumed = false
                self.selected = options.selected
                for _, child in ipairs(self._entities) do
                    if child.value == options.selected then
                        child:check()
                    elseif child.uncheck then
                        child:uncheck()
                    end
                end
                self:hide()
            end
    }):width() + self.padding
    self.originSelection = options.selected
    self.selected = options.selected
    local group = self:addEntity(RadioButtonGroup, {})
    for _, v in ipairs(options.choices) do
        xPos = xPos + UIFactory.createRadioButton(group, {
            x = xPos,
            y = 0,
            color = Theme.font:clone(),
            isChecked = options.selected == v.configValue,
            value = v.configValue,
            icon = v.icon,
            image = v.image,
            padding = self.padding - 0.5,
            callback = function() self.selected = v.configValue end
        }):width()
    end

    self.width = xPos + UIFactory.createIconButton(self, {
        y = self.padding - 2,
        x = xPos + self.padding / 2,
        icon = 'Check',
        padding = 2,
        framed = true,
        color = Theme.font:clone(),
        callback = function(btn) self:applyChanges(btn) end
    }):width() + self.padding
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
    love.graphics.push()

    love.graphics.translate(self.x, self.y)
    love.graphics.setColor(Theme.background)
    love.graphics.rectangle('fill', 0, 0, self.width + 10, self.height)

    EntityContainer.draw(self)

    love.graphics.setColor(self.color)
    love.graphics.rectangle('line', 0, -0.5, self.width + 10, self.height + 0.5)

    love.graphics.pop()
end

return Drawer