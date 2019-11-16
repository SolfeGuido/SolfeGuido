
local Entity = require('src.Entity')
local Theme = require('src.utils.Theme')
local UIFactory = require('src.utils.UIFactory')

---@class Drawer : Entity
local Drawer = Entity:extend()

function Drawer:new(area, options)
    Entity.new(self, area, options)
    self.color = Theme.font:clone()
end

function Drawer:init(options)
    self.padding = (self.height - Vars.titleSize) / 2
    self.childs = {
        UIFactory.createIconButton(self.area, {
            y = self.y + self.padding,
            icon = 'Check',
            framed = true,
            color = Theme.font:clone(),
            x = self.x,
            callback = function()
                if self.selected ~= options.selected and options.callback then
                    options.callback(self)
                else
                    self:hide()
                end
            end
        })
    }
    for i, v in ipairs(options.choices) do
        self.childs[#self.childs+1] = UIFactory.createRadioButton(self.area, {
            x = self.x + i * Vars.titleSize,
            y = self.y + self.padding,
            color = Theme.font:clone(),
            isChecked = options.selected == v.configValue,
            value = v.configValue,
            icon = v.icon,
            padding = math.floor(self.padding),
            callback = function(btn)
                btn.consumed = false
                if not btn.isChecked then
                    for _, child in ipairs(self.childs) do child.isChecked = false end
                    self.selected = v.configValue
                    btn.isChecked = true
                end
            end
        })
    end

    self.childs[#self.childs+1] = UIFactory.createIconButton(self.area, {
            x = self.x + (Vars.titleSize + self.padding * 2) * (#options.choices + 1),
            y = self.y + self.padding,
            icon = 'Times',
            framed = true,
            color = Theme.font:clone(),
            callback = function(btn)
                btn.consumed = false
                self.selected = options.selected
                for _, child in ipairs(self.childs) do
                    child.isChecked = child.value == options.selected
                end
                self:hide()
            end
        })
    
    self.width = #self.childs * (Vars.titleSize + self.padding * 2)
end

function Drawer:show()
    self.timer:tween(Vars.transition.tween, self, {x = love.graphics.getWidth() - self.width}, 'out-expo')
end

function Drawer:hide()
    self.timer:tween(Vars.transition.tween, self, {x = love.graphics.getWidth() + 5}, 'out-expo')
end

function Drawer:draw()
    love.graphics.setColor(Theme.background)
    love.graphics.rectangle('fill', self.x, self.y, self.width + 10, self.height)

    love.graphics.setColor(self.color)
    love.graphics.rectangle('line', self.x, self.y, self.width + 10, self.height)
end

function Drawer:update(dt)
    for i, v in ipairs(self.childs) do
        v.x = self.x + (i-1) * Vars.titleSize + self.padding * (2*i-1)
    end
end

return Drawer