
local EntityContainer = require('src.objects.EntityContainer')
local Theme = require('src.utils.Theme')
local UIFactory = require('src.utils.UIFactory')
local RadioButtonGroup = require('src.objects.RadioButtonGroup')

---@class Drawer : EntityContainer
--- Container used for the options sidebar, can be hidden
--- or shown, contains a set or radio buttons from which to choose
--- and a 'confirm', and a 'cancel' button
--- when clicking outside the drawer when it's open, it will
--- save the current choice, and close the drawer
local Drawer = EntityContainer:extend()

function Drawer:new(container, options)
    EntityContainer.new(self, container, options)
    self.color = Theme.font:clone()
    self.isShown = false
    self.animation = nil
    self.touchId = nil
end


---@param x number
---@param y number
---@return boolean wether the given coordinates are contained in the drawer
function Drawer:contains(x, y)
    return self.x <= x and (self.x + self.width) >= x and
            self.y <= y and (self.y + self.height) >= y
end

--- when pressing the escape key
--- the changes are saved and the drawer is closed
---@param key string
---@return boolean
function Drawer:keypressed(key)
    if self.isShown and key == "escape" then
        return self:applyChanges()
    end
    return EntityContainer.keypressed(self, key)
end

--- Saves the choice made by the user
--- and hides the drawer
---@param btn AbstractButton
---@return boolean
function Drawer:applyChanges(btn)
    if btn then btn.consumed = false end
    self.touchId = nil
    if self.originSelection ~= self.selected then
        self.callback(self)
    end
    self:hide()
    return true
end

--- Inherited function, calls the method of the container
--- relative to the position of the drawer
---@param x number
---@param y number
---@return boolean
function Drawer:mousemoved(x ,y)
    return EntityContainer.mousemoved(self, x - self.x, y - self.y)
end

--- Inherited functio, only interesed when the left button is clicked
--- calls the method of the container, relative to the position of
--- the drawer
---@param x number
---@param y number
---@param button number
---@return boolean
function Drawer:mousepressed(x, y, button)
    if self.isShown and not self:contains(x, y) and button == 1 then
        self.touchId = button
        return true
    end
    return EntityContainer.mousepressed(self, x - self.x, y - self.y, button)
end

--- Checks for when the user clisk outside the drawer
--- if it's the case,just apply the changes
--- otherwise, calls the method of the container, relative
--- to the position of the drawer
---@param x number
---@param y number
---@param button number
---@return boolean
function Drawer:mousereleased(x, y, button)
    if self.isShown and not self:contains(x, y) and button == 1 and self.touchId then
        return self:applyChanges()
    end
    return EntityContainer.mousereleased(self, x - self.x, y - self.y, button)
end

--- First step when pressing the screen, saves the id of the
--- finger that pressed the screen
--- and calls the method of the container relative to the
--- position of the drawer
---@param id number
---@param x number
---@param y number
---@return boolean
function Drawer:touchpressed(id, x, y)
    if self.isShown and not self.touchId and not self:contains(x, y) then
        self.touchId = id
        return true
    end
    return EntityContainer.touchpressed(self, id, x - self.x, y - self.y)
end

--- Inherited function, if the touch is outside the screen
--- apply the changes, otherwise, calls the method of the container
-- relative to the position of the drawer
---@param id number
---@param x number
---@param y number
---@return boolean
function Drawer:touchreleased(id, x, y)
    if self.isShown and self.touchId == id and not self:contains(x, y) then
        return self:applyChanges()
    end
    return EntityContainer.touchreleased(self, id, x - self.x, y - self.y)
end

--- Initiliazes the buttons of the drawer
--- and hides it
---@param options table
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

--- Triggers an animation to hide or show
--- the drawer, the calls the given callback
---@param nwX number
---@param callback function?
function Drawer:changeXPosition(nwX, callback)
    if self.animation then
        self.timer:cancel(self.animation)
    end
    self.animation = self.timer:tween(Vars.transition.tween, self, {x = nwX}, 'out-expo', function()
        self.animation = nil
        if callback then callback() end
    end)
end

--- Triggers the animation to show the drawer
function Drawer:show()
    self.isShown = true
    self:changeXPosition(love.graphics.getWidth() - self.width)
end

--- Triggers the animation to hide the drawer
function Drawer:hide()
    self:changeXPosition(love.graphics.getWidth() + 5, function()
        self.isShown = false
    end)
end

--- Inherited function
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