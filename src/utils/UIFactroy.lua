

--- LIBS
local ScreenManager = require('lib.ScreenManager')
local Theme         = require('src.utils.Theme')
local Config        = require('src.utils.Config')

--- ENTITIES
local IconButton    = require('src.objects.IconButton')
local TextButton    = require('src.objects.TextButton')
local MultiSelector = require('src.objects.MultiSelector')
local Title         = require('src.objects.Title')

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

function UIFactory.createRadioButton(area, config)

end

function UIFactory.createIconButton(area, config)
    createCallback(area, config)
    local size = config.size or Vars.titleSize
    return area:addentity(IconButton, {
        icon = assets.IconName[config.icon],
        size = size,
        x = config.x or -size,
        y = config.y,
        height = Vars.titleSize,
        color = Theme.transparent:clone(),
        callback = config.callback,
        circled = config.circled or false
    })
end

function UIFactory.createTextButton(area, config)
    createCallback(area, config)

    local btnText = love.graphics.newText(config.font, tr(config.text) )

    return area:addentity(TextButton, {
        text = btnText,
        x = -btnText:getWidth(),
        y = config.y,
        color = Theme.transparent:clone(),
        callback = config.callback,
        framed = config.framed or false,
        icon = config.icon or nil,
        centered = config.centered or false
    })
end

function UIFactory.createTitle(area, config)
    local titleText = love.graphics.newText(config.fontSize and assets.MarckScript(config.fontSize) or config.font, tr(config.text))
    local half = love.graphics.getWidth() / 2 - titleText:getWidth() / 2
    return area:addentity(Title, {
        x = config.main and half or -titleText:getWidth(),
        y = config.y,
        color = Theme.transparent:clone(),
        text = titleText,
        centered = config.centered
    })
end

function UIFactory.createMultiSelector(area, config)
    local msText = love.graphics.newText(config.font, tr(config.text) )
    assert(config.config, "Can't create multiselect from something else than configuration")
    local confName = config.config
    return area:addentity(MultiSelector, {
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
    })
end

return UIFactory