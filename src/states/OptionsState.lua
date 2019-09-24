
--- LIBS
local State = require('src.states.State')
local Graphics = require('src.Graphics')
local ScreenManager = require('lib.ScreenManager')

--- ENTITIES
local Title =  require('src.objects.Title')
local MultiSelector = require('src.objects.MultiSelector')

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
        Key = {'Sol', 'Fa'},
        Notes = {'it', 'en'}
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

    for k,v in pairs(selectors) do
        local text = love.graphics.newText(font, k)
        elements[#elements+1] = {
            element = self:addentity(MultiSelector, {
                text = text,
                x = -text:getWidth(),
                y = middle,
                selected = love.graphics.newText(font, ""),
                choices = v,
                color = assets.config.color.transparent
            }),
            target = {
                color = assets.config.color.black,
                x = 30
            }
        }
        middle = middle + assets.config.lineHeight
    end

    self:transition(elements)
end

function OptionsState:update(dt)
    State.update(self, dt)
end

function OptionsState:keypressed(key)
    if key == 'escape' then
        self:switchState('MenuState')
        return
    end
end

return OptionsState