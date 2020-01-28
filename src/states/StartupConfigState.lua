local State = require('src.State')
local Config = require('src.data.Config')
local UIFactory = require('src.utils.UIFactory')
local ScreenManager = require('lib.ScreenManager')
local Theme = require('src.utils.Theme')
local RadiButtonGroup = require('src.objects.RadioButtonGroup')

---@class StartupConfigState : State
local StartupConfigState = State:extend()

function StartupConfigState.createOptions()
    StartupConfigState.options = {
        {
            title = 'language',
            subtitle = 'language_configure',
            icon = 'Sphere',
            configName = 'lang',
            options = {
                {
                    optionName = 'en',
                    image = assets.images.flags.en,
                    title = 'English'
                },
                {
                    optionName = 'fr',
                    image = assets.images.flags.fr,
                    title = 'Français'
                },
                {
                    optionName = 'sv',
                    image = assets.images.flags.sv,
                    title = 'Svenska'
                }
            },
            changeCallback = function(nwValue)
                -- Reload all states ?
            end
        },
        {
            title = 'note_style',
            subtitle = 'note_style_subtitle',
            icon = 'Tag',
            configName = 'noteStyle',
            options = {
                {
                    optionName = 'englishNotes',
                    icon = 'EnglishNotes',
                    title = 'english_note'
                },
                {
                    optionName = 'romanNotes',
                    icon = 'RomanNotes',
                    title = 'roman_notes'
                },
                {
                    optionName = 'latinNotes',
                    icon = 'LatinNotes',
                    title = 'latin_notes'
                }
            },
        },
        {
            title = 'answer_type',
            subtitle = 'answer_type_subtitle',
            icon = 'Pointer',
            configName = 'answerType',
            options = {
                {
                    optionName = 'buttons',
                    icon = 'NotesButton',
                    title = 'answer_button',
                    subtitle = 'answer_button_subtitle'
                },
                {
                    optionName = 'piano',
                    icon = 'PianoKeys',
                    title = 'answer_piano',
                    subtitle = 'answer_piano_subtitle'
                },
                {
                    optionName = 'pianoWithNotes',
                    icon = 'PianoWithNotes',
                    title = 'answer_pianowithnotes',
                    subtitle = 'answer_pianowithnotes_subtitle'
                }
            }
        },
        {
            title = 'theme',
            subtitle = 'theme_subtitle',
            configName = 'theme',
            icon = 'Droplet',
            options = {
                {
                    optionName = 'light',
                    icon = 'Sun',
                    title = 'light_theme'
                },
                {
                    optionName = 'dark',
                    icon = 'Moon',
                    title = 'dark_theme'
                },
            },
            changeCallback = function(nwValue)
                --  Reload all
            end
        }
    }
    return StartupConfigState.options
end

function StartupConfigState:draw()
    love.graphics.setColor(Theme.background)
    love.graphics.rectangle('fill', 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    State.draw(self)
end

function StartupConfigState:init(index, config)
    print(index, config.title)
    UIFactory.createTitle(self, {
        text = tr(config.title),
        centered = true,
        y = 5,
        color = Theme.font:clone()
    })

    UIFactory.createTitle(self, {
        text = assets.IconName[config.icon],
        fontName = 'Icons',
        y = 15,
        x = 15,
        color = Theme.font:clone()
    })

    if config.subtitle then
        UIFactory.createTitle(self, {
            text = tr(config.subtitle),
            fontSize = Vars.mobileButton.fontSize,
            centered = true,
            y = Vars.titleSize + 10,
            color = Theme.font:clone()
        })
    end

    local optionsSize = #config.options
    self.selectedTitle = UIFactory.createTitle(self, {
        text = 'title',
        centered = true,
        fontName = 'Oswald',
        y = Vars.titleSize * 2 + 20,
        color = Theme.font:clone()
    })

    self.selectedSubtitle = UIFactory.createTitle(self, {
        text = 'subtitle',
        fontName = 'Oswald',
        fontSize = Vars.mobileButton.fontSize,
        centered = true,
        y = Vars.titleSize * 3 + 30,
        color = Theme.font:clone()
    })

    self.choices = self:addEntity(RadiButtonGroup, {})
    local configValue = Config[config.configName]
    for i, v in pairs(config.options) do
        UIFactory.createRadioButton(self.choices, {
            callback = function(btn)
                Config.update(config.configName, btn.value)
                if config.changeCallback then
                    config.changeCallback(btn)
                end
                self.selectedTitle:setCenteredText(tr(v.title))
                if v.subtitle then
                    self.selectedSubtitle:setCenteredText(tr(v.subtitle))
                end
            end,
            color = Theme.font:clone(),
            framed = true,
            image = v.image,
            icon = v.icon,
            size = Vars.titleSize,
            padding = 5,
            width = Vars.titleSize * 2,
            x = (i * 3) * Vars.titleSize,
            y = Vars.titleSize * 4 + 40,
            value = v.optionName
        })
        if v.optionName == configValue then
            self.selectedTitle:setCenteredText(tr(v.title))
            if v.subtitle then
                self.selectedSubtitle:setCenteredText(tr(v.subtitle))
            else
                self.selectedSubtitle.isDead = true
                self.selectedSubtitle = nil
            end
        end
    end
    print(config.configName, Config[config.configName])
    self.choices:setSelectedValue(Config[config.configName])

    if index > 1 then
        UIFactory.createTextButton(self, {
            text = tr('previous'),
            x = 10,
            y = love.graphics.getHeight() - 10,
            yOrigin = 1,
            padding = 5,
            framed = true,
            color = Theme.font:clone()
        })
    end

    if index < #StartupConfigState.options then
        UIFactory.createTextButton(self, {
            text = tr('next'),
            y = love.graphics.getHeight() - 10,
            x = love.graphics.getWidth() - 10,
            padding = 5,
            xOrigin = 1,
            yOrigin = 1,
            framed = true,
            callback = function()
                ScreenManager.pop()
            end,
            color = Theme.font:clone()
        })
    else
        UIFactory.createTextButton(self, {
            text = tr('done'),
            icon = 'Check',
            y = love.graphics.getHeight() - 10,
            x = love.graphics.getWidth() - 10,
            padding = 5,
            xOrigin = 1,
            yOrigin = 1,
            framed = true,
            callback = function() ScreenManager.pop() end,
            color = Theme.font:clone()
        })
    end
    State.init(self)
end

return StartupConfigState