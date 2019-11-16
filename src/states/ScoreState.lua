
-- LIBS
local State = require('src.State')
local ScoreManager = require('src.utils.ScoreManager')
local Theme = require('src.utils.Theme')

-- Entities
local Title = require('src.objects.Title')
local Line = require('src.objects.Line')
local MultiSelector = require('src.objects.MultiSelector')

---@class ScoreState : State
local ScoreState = State:extend()

function ScoreState:dispose()
    self.texts = {}
    State.dispose(self)
end

function ScoreState:updateScores(nwTiming)
    for _, level in ipairs(Vars.userPreferences.difficulty) do
        for _, key in ipairs(Vars.userPreferences.keySelect) do
            local score = ScoreManager.get(key, level, nwTiming)
            self.texts[level][key]:setText(tostring(score))
        end
    end
end

function ScoreState:init()
    local time = Vars.transition.tween / 3
    local middle = Vars.baseLine + Vars.lineHeight
    local font = assets.MarckScript(Vars.lineHeight)
    local maxSize = 0

    self.texts = {}

    local elements = {
        {
            element = self:addentity(MultiSelector, {
                text = love.graphics.newText(font," "),
                x = 0,
                y = middle,
                selected = Vars.userPreferences.time[1],
                choices = Vars.userPreferences.time,
                color = Theme.transparent:clone(),
                callback = function(value) self:updateScores(value) end,
            }),
            target = {color = Theme.font, x = Vars.limitLine}
        }
    }

    middle = middle + Vars.lineHeight

    -- Adding titles
    for _,v in ipairs(Vars.userPreferences.keySelect) do
        local text = love.graphics.newText(font, tr(v))
        maxSize = math.max(maxSize, text:getWidth())
        elements[#elements+1] = {
            element = self:addentity(Title, {
                text = text,
                color = Theme.transparent:clone(),
                y = middle,
                x = Vars.limitLine - text:getWidth()
            }),
            target = {x = Vars.limitLine + 10, color =  Theme.font},
            time = time
        }
        middle = middle + Vars.lineHeight
    end
    elements[#elements+1] = {
        element = self:addentity(Line, {
            color = Theme.transparent:clone(),
            x = Vars.limitLine - 2,
            lineWidth = 2,
            y = Vars.baseLine + Vars.lineHeight,
            height = Vars.lineHeight * 4,
        }),
        target = {x = Vars.limitLine + maxSize + 15, color = Theme.font},
        time = time
    }

    middle = Vars.limitLine + maxSize + 10
    local space = love.graphics.getWidth() - middle
    local levels = Vars.userPreferences.difficulty
    space = space / #levels
    for i,v in ipairs(levels) do
        local text = love.graphics.newText(font, v)
        local padding = (space - text:getWidth()) / 2
        elements[#elements+1] = {
            element = self:addentity(Title, {
                text = text,
                color = Theme.transparent:clone(),
                y = Vars.baseLine + Vars.lineHeight,
                x = -text:getWidth()
            }),
            target = {x = middle + padding, color = Theme.font},
            time = time
        }
        self.texts[v] = {}
        local yPos = Vars.baseLine + Vars.lineHeight * 2
        for _, key in ipairs(Vars.userPreferences.keySelect) do
            local score = ScoreManager.get(key, v, Vars.userPreferences.time[1])
            text = love.graphics.newText(font, tostring(score))
            padding = (space - text:getWidth()) / 2
            elements[#elements+1] = {
                element = self:addentity(Title, {
                    text = text,
                    color = Theme.transparent:clone(),
                    y = yPos,
                    x = -text:getWidth()
                }),
                target = {x = middle + padding, color = Theme.font},
                time = time
            }
            self.texts[v][key] = elements[#elements].element
            yPos = yPos + Vars.lineHeight
        end

        middle = middle + space


        if i ~= #levels then
            elements[#elements+1] = {
                element = self:addentity(Line, {
                    color = Theme.transparent:clone(),
                    x = -1,
                    y = Vars.baseLine + Vars.lineHeight,
                    height = Vars.lineHeight * 4,
                }),
                target = {x = middle, color = Theme.hovered},
                time = time
            }
        end
    end


    self:transition(elements, nil, Vars.transition.spacing / 3)
end

return ScoreState