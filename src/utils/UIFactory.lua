

--- LIBS
local ScreenManager = require('lib.ScreenManager')
local Theme         = require('src.utils.Theme')
local Config        = require('src.utils.Config')

--- ENTITIES
local IconButton    = require('src.objects.IconButton')
local TextButton    = require('src.objects.TextButton')
local MultiSelector = require('src.objects.MultiSelector')
local Title         = require('src.objects.Title')
local RadioButton   = require('src.objects.RadioButton')

local UIFactory = {}

local function createCallback(area, config)
    if config.state and not config.callback then
        config.callback = function() area:switchState(config.state) end
    elseif config.statePush and not config.callback then
        config.callback = function(btn)
            btn.consumed = false
            ScreenManager.push(config.statePush, config.statePushArgs)
        end
    end
end

local function addToState(config, element)
    local name = config.name
    if not name then return element end
    local area = element.area
    local obj = area[name]
    if not obj then
        area[name] = element
    elseif type(obj) == "table" then
        obj[#obj+1] = element
    end
    return element
end

function UIFactory.createIconButton(area, config)
    createCallback(area, config)
    local size = config.size or Vars.titleSize
    return addToState(config, area:addentity(IconButton, {
        icon = assets.IconName[config.icon],
        size = size,
        x = config.x or -size,
        y = config.y,
        height = Vars.titleSize,
        color = config.color or Theme.transparent:clone(),
        callback = config.callback,
        circled = config.circled or false,
        framed = config.framed,
        centered = config.centered,
        anchor = config.anchor,
        padding = config.padding or 0
    }))
end

function UIFactory.createTextButton(area, config)
    createCallback(area, config)

    local btnText = love.graphics.newText(config.font, tr(config.text) )

    return addToState(config, area:addentity(TextButton, {
        text = btnText,
        x = -btnText:getWidth(),
        y = config.y,
        color = Theme.transparent:clone(),
        callback = config.callback,
        framed = config.framed or false,
        icon = config.icon or nil,
        centered = config.centered or false
    }))
end

function UIFactory.createTitle(area, config)
    if type(config.text) == "string" then
        config.text = love.graphics.newText(config.fontSize and assets.MarckScript(config.fontSize) or config.font, tr(config.text))
    end

    --local half = love.graphics.getWidth() / 2 - config.text:getWidth() / 2
    return addToState(config, area:addentity(Title, {
        x = config.x or -config.text:getWidth(),
        y = config.y,
        color = config.color or Theme.transparent:clone(),
        text = config.text,
        centered = config.centered,
        framed = config.framed
    }))
end

function UIFactory.createMultiSelector(area, config)
    local msText = love.graphics.newText(config.font, tr(config.text) )
    assert(config.config, "Can't create multiselect from something else than configuration")
    local confName = config.config
    return addToState(config, area:addentity(MultiSelector, {
        text = msText,
        x = -msText:getWidth() * 3,
        y = config.y,
        selected = Config[confName] or Vars.userPreferences[confName][1],
        choices = Vars.userPreferences[confName],
        color = Theme.transparent:clone(),
        callback = function(value)
            if area.options then
                area.options[confName] = value
            else
                Config.update(confName, value)
            end
        end,
        centered = config.centered or false
    }))
end

function UIFactory.createRadioButton(area, config)
    if config.icon and not config.image then
        config.image = love.graphics.newText(assets.IconsFont(config.size or Vars.titleSize), assets.IconName[config.icon])
    elseif config.text and not config.image then
        config.image = love.graphics.newText(assets.MarckScript(config.size or Vars.titleSize), config.text)
    end
    return addToState(config, area:addentity(RadioButton, {
        x = config.x,
        y = config.y,
        value = config.value,
        isChecked = config.isChecked or false,
        color = config.color or Theme.transparent:clone(),
        callback = config.callback,
        image = config.image,
        framed = config.framed or false,
        padding = config.padding or 0,
        width = config.width,
        minWidth = config.minWidth,
        centerImage = config.centerImage
    }))
end

return UIFactory