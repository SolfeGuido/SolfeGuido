
--- LIBS
local State = require('src.states.State')
local Graphics = require('src.Graphics')
local Config = require('src.Config')

--- ENTITIES
local Title =  require('src.objects.Title')
local MultiSelector = require('src.objects.MultiSelector')
local Button = require('src.objects.button')

---@class OptionsState : State
local OptionsState = State:extend()


function OptionsState:new()
    State.new(self)
end

function OptionsState:draw()
    State.draw(self)
    Graphics.drawMusicBars()
end

function OptionsState:init(...)
    local selectors = {
        {'Key', 'keySelect'},
        {'Notes', 'noteStyle'},
        {'Sound', 'sound'},
        {'Language', 'lang'}
    }

    local titleText = love.graphics.newText(assets.MarckScript(40), "Options")

    local elements = {
        {
            element = self:addentity(Title, {
                x = -titleText:getWidth(),
                y = 0,
                color = assets.config.color.transparent,
                text = titleText
            }),
            target = { x = 30, color = assets.config.color.black}
        }
    }

    local font = assets.MarckScript(assets.config.lineHeight)
    local middle = love.graphics.getHeight() / 3

    for _,v in pairs(selectors) do
        local text = love.graphics.newText(font, v[1])
        local confName = v[2]
        elements[#elements+1] = {
            element = self:addentity(MultiSelector, {
                text = text,
                x = -text:getWidth() * 3,
                y = middle,
                selected = Config[confName],
                choices = assets.config.userPreferences[confName],
                color = assets.config.color.transparent,
                callback = function(value) Config[confName] = value end
            }),
            target = {
                color = assets.config.color.black,
                x = 30
            }
        }
        middle = middle + assets.config.lineHeight
    end

    local btnText = love.graphics.newText(font, "Back")
    elements[#elements+1] = {
        element = self:addentity(Button, {
            text = btnText,
            x = -btnText:getWidth(),
            y = middle,
            color = assets.config.color.transparent,
            callback = function() self:back() end
        }),
        target = {
            color = assets.config.color.black,
            x = 30
        }
    }

    self:transition(elements)
end

function OptionsState:update(dt)
    State.update(self, dt)
end

function OptionsState:keypressed(key)
    if key == 'escape' then
        self:back()
        return
    end
end

function OptionsState:back()
    Config.save()
    self:switchState('MenuState')
end

return OptionsState