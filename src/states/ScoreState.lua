
-- LIBS
local BaseState = require('src.states.BaseState')
local ScoreManager = require('src.utils.ScoreManager')
local Color = require('src.utils.Color')

-- Entities
local Title = require('src.objects.Title')
local Line = require('src.objects.Line')

---@class ScoreState : State
local ScoreState = BaseState:extend()



function ScoreState:init()
    local time = assets.config.transition.tween / 3
    local entries = { 'level', 'gKey', 'fKey', 'both' }
    local elements = {}

    local maxSize = 0

    local middle = assets.config.baseLine + assets.config.lineHeight
    local font = assets.MarckScript(assets.config.lineHeight)

    -- Adding titles
    for _,v in ipairs(entries) do
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
            target = {x = middle + padding, color = Color.black},
            time = time
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
                target = {x = middle + padding, color = Color.black},
                time = time
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
                target = {x = middle, color = Color.gray(0.5)},
                time = time
            }
        end
    end


    self:transition(elements, nil, assets.config.transition.spacing / 3)
end

return ScoreState