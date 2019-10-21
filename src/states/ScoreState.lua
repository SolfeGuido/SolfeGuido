
-- LIBS
local State = require('src.State')
local ScoreManager = require('src.utils.ScoreManager')
local EventTransmitter = require('src.utils.EventTransmitter')
local Color = require('src.utils.Color')
local ScreenManager = require('lib.ScreenManager')

-- Entities
local Title = require('src.objects.Title')
local Line = require('src.objects.Line')

---@class ScoreState : State
local ScoreState = State:extend()
ScoreState:implement(EventTransmitter)


function ScoreState:new()
    State.new(self)
end

function ScoreState:init()
    local titleText = love.graphics.newText(assets.MarckScript(assets.config.titleSize), "Scores")

    local entries = { 'level', 'gKey', 'fKey' }
    local elements = {}

    local middle = assets.config.baseLine + assets.config.lineHeight
    local font = assets.MarckScript(assets.config.lineHeight)
    for _,v in ipairs(entries) do
        local text = love.graphics.newText(font, v)
        elements[#elements+1] = {
            element = self:addentity(Title, {
                text = text,
                color = Color.transparent:clone(),
                y = middle,
                x = - text:getWidth()
            }),
            target = {x = 30, color =  Color.black}
        }
        middle = middle + assets.config.lineHeight
    end
    table.remove(entries, 1)

    middle = assets.config.limitLine + 10
    local space = love.graphics.getWidth() - middle
    local levels = assets.config.userPreferences.difficulty
    space = space / #levels
    for i,v in ipairs(levels) do
        local text = love.graphics.newText(font, v)
        local padding = (space - text:getWidth()) / 2
        elements[#elements+1] = {
            element = self:addentity(Title, {
                text = text,
                color = Color.transparent:clone(),
                y = assets.config.baseLine + assets.config.lineHeight,
                x = -text:getWidth()
            }),
            target = {x = middle + padding, color = Color.black}
        }
        local yPos = assets.config.baseLine + assets.config.lineHeight * 2
        for _, key in ipairs(entries) do
            local score = ScoreManager.get(key, v)
            text = love.graphics.newText(font, tostring(score))
            padding = (space - text:getWidth()) / 2
            elements[#elements+1] = {
                element = self:addentity(Title, {
                    text = text,
                    color = Color.transparent:clone(),
                    y = yPos,
                    x = -text:getWidth()
                }),
                target = {x = middle + padding, color = Color.black}
            }
            yPos = yPos + assets.config.lineHeight
        end

        middle = middle + space


        if i ~= #levels then
            elements[#elements+1] = {
                element = self:addentity(Line, {
                    color = Color.transparent:clone(),
                    x = -1,
                    y = assets.config.baseLine + assets.config.lineHeight,
                    height = assets.config.lineHeight * 4,
                }),
                target = {x = middle, color = Color.gray(0.5)}
            }
        end
    end


    self:transition(elements)
end

function ScoreState:receive(eventName, callback)
    if eventName == "pop" then
        self:slideEntitiesOut(function()
            ScreenManager.pop()
            if callback and type(callback) == "function" then callback() end
        end)
    end
end

function ScoreState:draw()
    State.draw(self)
end


return ScoreState