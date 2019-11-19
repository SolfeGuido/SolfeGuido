
local Entity = require('src.Entity')
local Theme = require('src.utils.Theme')
local UIFactory = require('src.utils.UIFactory')
local lume = require('lib.lume')

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
            y = self.y + self.padding - 2,
            icon = 'Check',
            padding = 2,
            framed = true,
            color = Theme.font:clone(),
            x = self.x,
            callback = function(btn)
                btn.consumed = false
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
            y = self.y + 1,
            color = Theme.font:clone(),
            isChecked = options.selected == v.configValue,
            value = v.configValue,
            icon = v.icon,
            image = v.image,
            padding = math.floor(self.padding),
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
            x = self.x + (Vars.titleSize + self.padding * 2) * (#options.choices + 1),
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
    
    self.width = self.padding * 2 + lume.reduce(self.childs, function(acc, b)
            return acc + b:width()
    end, 0)
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
    local x = self.x + self.padding - 2
    for i, v in ipairs(self.childs) do
        v.x = x
        x = x + v:width() + 2
    end
end

return Drawer