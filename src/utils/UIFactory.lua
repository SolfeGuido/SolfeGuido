

--- LIBS
local ScreenManager = require('lib.ScreenManager')
local Theme         = require('src.utils.Theme')
local RadioButtonGroup = require('src.objects.RadioButtonGroup')

--- ENTITIES
local IconButton    = require('src.objects.IconButton')
local TextButton    = require('src.objects.TextButton')
local Title         = require('src.objects.Title')
local Image         = require('src.objects.Image')

local UIFactory = {}

local function createCallback(config)
    if config.statePush and not config.callback then
        config.callback = function(btn)
            btn.consumed = false
            ScreenManager.push(config.statePush, config.statePushArgs)
        end
    end
end

local function addToState(config, element)
    local name = config.name
    if not name then return element end
    local container = element.container
    local obj = container[name]
    if not obj then
        container[name] = element
    elseif type(obj) == "table" then
        obj[#obj+1] = element
    end
    return element
end

function UIFactory.createIconButton(container, config)
    createCallback(config)
    local size = config.size or Vars.titleSize
    return addToState(config, container:addEntity(IconButton, {
        icon = assets.IconName[config.icon],
        size = size,
        x = config.x or -size,
        y = config.y,
        height = config.height or Vars.titleSize,
        color = config.color or Theme.transparent:clone(),
        callback = config.callback,
        circled = config.circled or false,
        framed = config.framed,
        centered = config.centered,
        anchor = config.anchor,
        padding = config.padding or 0
    }))
end

function UIFactory.createTextButton(container, config)
    createCallback(config)
    if not config.font then
        local font = config.fontName or 'MarckScript'
        config.font = assets.fonts[font](config.fontSize or Vars.titleSize)
    end
    local btnText = love.graphics.newText(config.font, tr(config.text) )
    if config.icon then
        config.icon = love.graphics.newText(
            assets.fonts.Icons(config.fontSize or Vars.titleSize),
            assets.IconName[config.icon]
        )
    end

    return addToState(config, container:addEntity(TextButton, {
        text = btnText,
        icon = config.icon,
        x = config.x,
        y = config.y,
        padding = config.padding or 0,
        color = config.color,
        callback = config.callback,
        framed = config.framed or false,
        centerText = config.centerText or false,
        xOrigin = config.xOrigin or 0,
        yOrigin = config.yOrigin or 0
    }))
end

function UIFactory.createImage(container, config)
    return addToState(config, container:addEntity(Image, {
        image = config.image,
        size = config.size,
        x = config.x,
        y = config.y,
        color = config.color or Theme.transparent:clone()
    }))
end

function UIFactory.createTitle(container, config)
    if type(config.text) == "string" then
        if not config.fontSize and not config.font then
            config.fontSize = Vars.titleSize
        end
        if not config.fontName and not config.font then
            config.fontName = 'MarckScript'
        end
        config.text = love.graphics.newText(
            config.fontSize and assets.fonts[config.fontName](config.fontSize) or config.font, tr(config.text)
        )
    end

    --local half = love.graphics.getWidth() / 2 - config.text:getWidth() / 2
    return addToState(config, container:addEntity(Title, {
        x = config.x or -config.text:getWidth(),
        y = config.y,
        color = config.color or Theme.transparent:clone(),
        text = config.text,
        centered = config.centered,
        framed = config.framed
    }))
end

function UIFactory.createRadioButton(container, config)
    if not container:is(RadioButtonGroup) then
        error('Can only add radio button to radio button groups')
    end
    if config.icon and not config.image then
        config.image = love.graphics.newText(
                assets.fonts.Icons(config.size or Vars.titleSize),
                assets.IconName[config.icon]
            )
    elseif config.text and not config.image then
        local font = config.font or 'MarckScript'
        config.image = love.graphics.newText(assets.fonts[font](config.size or Vars.titleSize), tr(config.text))
    end
    return addToState(config, container:addRadioButton({
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