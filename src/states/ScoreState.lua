
-- LIBS
local State = require('src.State')
local ScoreManager = require('src.utils.ScoreManager')
local Theme = require('src.utils.Theme')
local Graphics = require('src.utils.Graphics')
local UIFactory = require('src.utils.UIFactory')
local ScreenManager = require('lib.ScreenManager')


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

function ScoreState:draw()
    Graphics.drawMusicBars()
    State.draw(self)
end

function ScoreState:init()
    local time = Vars.transition.tween / 3
    local middle = Vars.baseLine + Vars.lineHeight
    local font = assets.MarckScript(Vars.lineHeight)
    local maxSize = 0

    self.texts = {}
    self.radioButtons = {}
    local title = love.graphics.newText(assets.MarckScript(Vars.titleSize), tr("Score"))


    local elements = {
        {
            element = UIFactory.createIconButton(self, {
                icon = 'Home',
                x = 5,
                y = love.graphics.getHeight(),
                callback = function()
                    self:slideEntitiesOut(function()
                        ScreenManager.switch('MenuState')
                    end)
                end
            }),
            target = {color = Theme.font, y = love.graphics.getHeight() - Vars.titleSize - 5}
        },
        {
            element = UIFactory.createTitle(self, {
                name = 'title',
                text = title,
                y = -title:getHeight(),
                color = Theme.transparent:clone(),
                x = love.graphics.getWidth() / 2 - title:getWidth() / 2
            }),
            target = {color = Theme.font, y = 0}
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
            target = {x = Vars.limitLine / 2 - text:getWidth() / 2, color =  Theme.font},
        }
        middle = middle + Vars.lineHeight
    end

    middle = Vars.limitLine + 10
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

    local radioSpace = love.graphics.getWidth() - Vars.limitLine - space
    space = radioSpace / #Vars.userPreferences.time
    local yPos = Vars.baseLine + Vars.lineHeight * 6
    local xPos = Vars.limitLine +  space / 2  - (Vars.titleSize * 0.60)
    for i, v in ipairs(Vars.userPreferences.time) do
        elements[#elements+1] = {
            element = UIFactory.createRadioButton(self, {
                x = - Vars.titleSize * 2,
                value = v,
                name = 'radioButtons',
                padding = 10,
                width = space / 2,
                centerImage = true,
                isChecked = i == 1,
                y = yPos,
                framed = true,
                callback = function(btn)
                    btn.consumed = false
                    for _, radio in ipairs(self.radioButtons) do
                        if radio == btn then
                            self:updateScores(v)
                            radio:check()
                        else
                            radio:uncheck()
                        end
                    end
                end,
                image = love.graphics.newText(font, v)
            }),
            target = {color = Theme.font, x = xPos}
        }
        xPos = xPos + space
    end
    self:transition(elements, nil, Vars.transition.spacing / 3)
end

return ScoreState