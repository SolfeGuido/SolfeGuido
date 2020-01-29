local EntityContainer = require('src.objects.EntityContainer')
local RadioButton = require('src.objects.RadioButton')

---@class RadioButtonGroup : Entity
local RadioButtonGroup = EntityContainer:extend()

function RadioButtonGroup:new(container, options)
    EntityContainer.new(self, container, options)
end

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

function RadioButtonGroup:getSelectedValue()
    for _,v in ipairs(self._entities) do
        if v.isChecked then return v.value end
    end
    return nil
end

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