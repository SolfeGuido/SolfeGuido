
local AbstractButton = require('src.objects.AbstractButton')
local Theme = require('src.utils.Theme')
local lume = require('lib.lume')

---@class RadioButton : Entity
local RadioButton = AbstractButton:extend()

function RadioButton:new(area, options)
    AbstractButton.new(self, area, options)
    self.isChecked = options.isChecked or false
    self.padding = options.padding or 0
    self.backgroundColor = self.isChecked and Theme.secondary:clone() or Theme.background:clone()
    if self.image:type() == "Image" then
        self.scale = Vars.titleSize / self.image:getHeight()
    end
    if options.minWidth then
        local mWidth = self.image:getWidth() + self.padding * 2
        if mWidth < options.minWidth then
            self.padding = (options.minWidth - mWidth) / 2
        end
        self._width = options.minWidth
    else
        self._width = (options.width or self.image:getWidth() * (self.scale or 1)) + self.padding * 2
    end
    self.height = (self.image:getHeight() * (self.scale or 1)) + (self.padding * 2)
end

function RadioButton:width()
    return self._width
end

function RadioButton:uncheck()
    if not self.isChecked then return end
    self:toggle()
end

function RadioButton:check()
    if self.isChecked then return end
    self:toggle()
end

function RadioButton:toggle()
    self:animate(Vars.transition.tween, self, {backgroundColor = self.isChecked and Theme.background or Theme.secondary}, 'linear')
    self.isChecked = not self.isChecked
end

function RadioButton:contains(x, y)
    return self.x <= x and (self.x + self._width) >= x and
            self.y <= y and (self.y + self.height) >= y
end

function RadioButton:__tostring()
    return "RadioButton(" .. tostring(self.value) .. ")"
end

function RadioButton:onclick()
    assets.sounds.click:play()
    if self.callback then self.callback(self) end
end

function RadioButton:draw()
    local bgColor = self.backgroundColor.rgb
    bgColor[#bgColor+1] = self.color.a
    love.graphics.setColor(bgColor)
    love.graphics.rectangle('fill', self.x, self.y, self._width, self.height)
    if self.framed then
        love.graphics.setColor(self.color)
        love.graphics.rectangle('line', self.x, self.y, self._width, self.height)
    end
    if self.image:type() ~= "Image" then
        love.graphics.setColor(self.color)
    else
        love.graphics.setColor(1, 1, 1, 1)
    end
    if self.centerImage then
        local x = lume.round(self.x + self._width / 2 - self.image:getWidth() / 2)
        love.graphics.draw(self.image, x, lume.round(self.y + self.padding))
    else
        love.graphics.draw(self.image, lume.round(self.x + self.padding), lume.round(self.y + self.padding), 0, self.scale, self.scale)
    end
end


return RadioButton