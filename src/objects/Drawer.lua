
local Entity = require('src.Entity')
local Theme = require('src.utils.Theme')
local UIFactory = require('src.utils.UIFactory')

---@class Drawer : Entity
local Drawer = Entity:extend()

function Drawer:new(area, options)
    Entity.new(self, area, options)
    self.childs = {
        UIFactory.createIconButton(area, {
            x = self.x,
            y = self.y,
            icon = 'Times',
            color = Theme.font:clone(),
            callback = function(btn)
                btn.consumed = false
                self:hide()
            end
        }),
        UIFactory.createIconButton(area, {
            y = self.y,
            icon = 'Check',
            color = Theme.font:clone(),
            x = self.x + Vars.titleSize * (#options.choices + 1),
            callback = function()
                if self.selected ~= options.selected and self.callback then
                    self.callback(self)
                else
                    self:hide()
                end
            end
        })
    }
    for i, v in ipairs(options.choices) do
        self.childs[#self.childs+1] = UIFactory.createRadioButton(area, {
            x = i * Vars.titleSize,
            y = self.y,
            color = Theme.font:clone(),
            isChecked = options.selected == v.configValue,
            icon = v.icon,
            callback = function(btn)
                if not btn.isChecked then
                    for _, child in ipairs(self.childs) do child.isChecked = false end
                    btn.consumed = false
                    self.selected = v.configValue
                    btn.isChecked = true
                end
            end
        })
    end
    self.width = (#options + 2) * Vars.titleSize
    self.height = options.height or Vars.titleSize
end

function Drawer:show()
    self.timer:tween(Vars.transition.tween, self, {x = love.graphics.getWidth() - self.width}, 'out-expo')
end

function Drawer:hide()
    self.timer:tween(Vars.transition.tween, self, {x = love.graphics.getWidth()}, 'out-expo')
end

function Drawer:draw()
    love.graphics.setColor(Theme.background)
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)

    love.graphics.setColor(Theme.font)
    love.graphics.rectangle('line', self.x, self.y, self.width, self.height)
    for _,v in ipairs(self.childs) do
        v:draw()
    end
end

function Drawer:update(dt)
    for i, v in ipairs(self.childs) do
        v.x = self.x + (i-1) * Vars.titleSize
    end
end

return Drawer