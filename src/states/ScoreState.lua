
-- LIBS
local State = require('src.states.State')
local Graphis = require('src.Graphics')

-- Entities
local Title = require('src.objects.Title')
local Line = require('src.objects.Line')

---@class ScoreState : State
local ScoreState = State:extend()


function ScoreState:new()
    State.new(self)
end

function ScoreState:init()
    local titleText = love.graphics.newText(assets.MarckScript(40), "Scores")

    local entries = { 'level', 'gKey', 'fkey' }
    local elements = {
        {
            element = self:addentity(Title, {
                text = titleText,
                color = assets.config.color.transparent(),
                y = 0,
                x = -titleText:getWidth()
            }),
            target = {x = 30, color = assets.config.color.black()}
        }
    }

    local middle = love.graphics.getHeight() / 3
    local font = assets.MarckScript(assets.config.lineHeight)
    for _,v in ipairs(entries) do
        local text = love.graphics.newText(font, v)
        elements[#elements+1] = {
            element = self:addentity(Title, {
                text = text,
                color = assets.config.color.transparent(),
                y = middle,
                x = - text:getWidth()
            }),
            target = {x = 30, color = assets.config.color.black()}
        }
        middle = middle + assets.config.lineHeight
    end

    middle = assets.config.limitLine + 10
    local space = love.graphics.getWidth() - middle
    local levels = assets.config.userPreferences.difficulty
    space = space / #levels
    for _,v in ipairs(levels) do
        local text = love.graphics.newText(font, v)
        local padding = (assets.config.limitLine - text:getWidth()) / 2
        elements[#elements+1] = {
            element = self:addentity(Title, {
                text = text,
                color = assets.config.color.transparent(),
                y = love.graphics.getHeight() / 3,
                x = -text:getWidth()
            }),
            target = {x = middle + padding, color = assets.config.color.black() }
        }
        middle = middle + space

        elements[#elements+1] = {
            element = self:addentity(Line, {
                color = assets.config.color.transparent(),
                x = -1,
                y = 0,
                height = love.graphics.getHeight(),
            }),
            target = {x = middle, color = assets.config.color.gray()}
        }
    end

    self:transition(elements)
end

function ScoreState:draw()
    State.draw(self)

    Graphis.drawMusicBars()
end

function ScoreState:update(dt)
    State.update(self, dt)
end

return ScoreState