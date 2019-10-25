
-- LIBS
local BaseState = require('src.states.BaseState')
local ScoreManager = require('src.utils.ScoreManager')
local Color = require('src.utils.Color')

-- Entities
local Title = require('src.objects.Title')
local Line = require('src.objects.Line')
local MultiSelector = require('src.objects.MultiSelector')

---@class ScoreState : State
local ScoreState = BaseState:extend()

function ScoreState:dispose()
    self.texts = {}
    BaseState.dispose(self)
end

function ScoreState:updateScores(nwTiming)
    for _, level in ipairs(assets.config.userPreferences.difficulty) do
        for _, key in ipairs(assets.config.userPreferences.keySelect) do
            local score = ScoreManager.get(key, level, nwTiming)
            self.texts[level][key]:setText(tostring(score))
        end
    end
end

function ScoreState:init()
    local time = assets.config.transition.tween / 3
    local middle = assets.config.baseLine + assets.config.lineHeight
    local font = assets.MarckScript(assets.config.lineHeight)
    local maxSize = 0

    self.texts = {}

    local elements = {
        {
            element = self:addentity(MultiSelector, {
                text = love.graphics.newText(font," "),
                x = 0,
                y = middle,
                selected = assets.config.userPreferences.time[1],
                choices = assets.config.userPreferences.time,
                color = Color.transparent:clone(),
                callback = function(value) self:updateScores(value) end,
            }),
            target = {color = Color.black, x = assets.config.limitLine}
        }
    }

    middle = middle + assets.config.lineHeight

    -- Adding titles
    for _,v in ipairs(assets.config.userPreferences.keySelect) do
        local text = love.graphics.newText(font, tr(v))
        maxSize = math.max(maxSize, text:getWidth())
        elements[#elements+1] = {
            element = self:addentity(Title, {
                text = text,
                color = Color.transparent:clone(),
                y = middle,
                x = assets.config.limitLine - text:getWidth()
            }),
            target = {x = assets.config.limitLine + 10, color =  Color.black},
            time = time
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
        target = {x = assets.config.limitLine + maxSize + 15, color = Color.black},
        time = time
    }

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
            target = {x = middle + padding, color = Color.black},
            time = time
        }
        self.texts[v] = {}
        local yPos = assets.config.baseLine + assets.config.lineHeight * 2
        for _, key in ipairs(assets.config.userPreferences.keySelect) do
            local score = ScoreManager.get(key, v, assets.config.userPreferences.time[1])
            text = love.graphics.newText(font, tostring(score))
            padding = (space - text:getWidth()) / 2
            elements[#elements+1] = {
                element = self:addentity(Title, {
                    text = text,
                    color = Color.transparent:clone(),
                    y = yPos,
                    x = -text:getWidth()
                }),
                target = {x = middle + padding, color = Color.black},
                time = time
            }
            self.texts[v][key] = elements[#elements].element
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
                target = {x = middle, color = Color.gray(0.5)},
                time = time
            }
        end
    end


    self:transition(elements, nil, assets.config.transition.spacing / 3)
end

return ScoreState