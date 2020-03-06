local EntityContainer = require('src.objects.EntityContainer')
local RadioButton = require('src.objects.RadioButton')

--- To make it easier to handle the radio buttons group,
--- this class handles the selected values, and can
--- set a given value
---@class RadioButtonGroup : EntityContainer
local RadioButtonGroup = EntityContainer:extend()

--- constructor
---@param container EntityContainer
---@param options table
function RadioButtonGroup:new(container, options)
    EntityContainer.new(self, container, options)
end

--- Checks the given radio button
--- and unchecks all the other ones
---@param btn RadioButton
function RadioButtonGroup:_buttonClicked(btn)
    btn.consumed = false
    for _,radio in ipairs(self._entities) do
        if radio == btn then
            radio:check()
        else
            radio:uncheck()
        end
    end
end

--- Creates a radio button with the given options
--- and add it to the group
---@return RadioButton
---@param options table
function RadioButtonGroup:addRadioButton(options)
    if options.callback then
        local save = options.callback
        options.callback = function(btn)
            save(btn)
            self:_buttonClicked(btn)
        end
    else
        options.callback = function(btn) self:_buttonClicked(btn) end
    end
    return self:addEntity(RadioButton, options)
end

--- Access to the value of the selected button
---@return string
function RadioButtonGroup:getSelectedValue()
    for _,v in ipairs(self._entities) do
        if v.isChecked then return v.value end
    end
    return nil
end

--- Changes the group to select the radio
--- button with the given value
--- none will be selected if the value is
--- not contained by a single button
---@param val string
function RadioButtonGroup:setSelectedValue(val)
    for _, v in ipairs(self._entities) do
        if v.value == val then
            v:check()
        else
            v:uncheck()
        end
    end
end

return RadioButtonGroup