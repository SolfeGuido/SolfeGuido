
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
    local entries = { 'level', 'gKey', 'fKey' }
    local elements = {}

    local maxSize = 0

    local middle = assets.config.baseLine + assets.config.lineHeight
    local font = assets.MarckScript(assets.config.lineHeight)

    -- Adding titles
    for _,v in ipairs(entries) do
        local text = love.graphics.newText(font, v)
        maxSize = math.max(maxSize, text:getWidth())
        elements[#elements+1] = {
            element = self:addentity(Title, {
                text = text,
                color = Color.transparent:clone(),
                y = middle,
                x = assets.config.limitLine - text:getWidth()
            }),
            target = {x = assets.config.limitLine + 10, color =  Color.black}
        }
        middle = middle + assets.config.lineHeight
    end
    elements[#elements+1] = {
        element = self:addentity(Line, {
            color = Color.transparent:clone(),
            x = assets.config.limitLine - 2,
            lineWidth = 2,
            y = assets.config.baseLine + assets.config.lineHeight,
            height = assets.config.lineHeight * 4,
        }),
        target = {x = assets.config.limitLine + maxSize + 15, color = Color.black}
    }

    -- Now displaying scores
    table.remove(entries, 1)

    middle = assets.config.limitLine + maxSize + 10
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
    love.graphics.setScissor(assets.config.limitLine ,assets.config.baseLine, love.graphics.getWidth(), assets.config.baseLine + assets.config.lineHeight * 5)
    State.draw(self)
    love.graphics.setScissor()
end


return ScoreState