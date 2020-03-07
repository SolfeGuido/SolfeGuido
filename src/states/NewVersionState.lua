local DialogState = require('src.states.DialogState')
local UIFactory = require('src.utils.UIFactory')
local Theme = require('src.utils.Theme')
local StatisticsManager = require('src.data.StatisticsManager')

--- Dialog shown where there is a new version,
--- shows the news brought by the new version
--- it can be shown when the app is updated
--- or when the user clicks the version on the main menu
---@class NewVersionState : DialogState
local NewVersionState = DialogState:extend()


--- Creates the news lines
function NewVersionState:init()
    local news = StatisticsManager.news
    local text = love.graphics.newText(
        assets.fonts.MarckScript(Vars.titleSize),
        tr('new_version', {version = Vars.appVersion})
    )
    self:setWidth(text:getWidth() + Vars.titleSize * 3)

    local dialogMiddle = (love.graphics.getWidth() - self.margin * 2) / 2
    local titleMiddle = dialogMiddle - text:getWidth() / 2

    local title = UIFactory.createTitle(self, {
        text = text,
        x = titleMiddle,
        y = 0,
        color = Theme.transparent:clone()
    })
    local width = title:width()

    local elements = {
        {
            element = title,
            target = {color = Theme.font}
        },
        {
            element = UIFactory.createTextButton(self, {
                text = tr('nice'),
                centerText = true,
                icon = 'Check',
                fontSize = Vars.mobileButton.fontSize,
                fontName = 'Oswald',
                framed = true,
                padding = 5,
                x = dialogMiddle,
                y = (#news + 1.5) * Vars.titleSize,
                callback = function () self:slideOut() end
            }),
            target = {color = Theme.font}
        }
    }
    for i, v in ipairs(news) do
        local element = UIFactory.createTitle(self, {
            text = ' - ' .. tr(v),
            x = 20,
            y = 10 + i * Vars.titleSize,
            fontSize = Vars.mobileButton.fontSize,
            fontName = 'Oswald',
            color = Theme.transparent:clone()
        })
        elements[#elements+1] = {
            element = element,
            target = {color = Theme.font}
        }
        width = math.max(width, element:width())
    end
    self.height = (#news + 3) * Vars.titleSize
    self:transition(elements)
    DialogState.init(self)
end


return NewVersionState