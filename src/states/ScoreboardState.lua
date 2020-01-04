
-- LIBS
local State = require('src.State')
local ScoreManager = require('src.data.ScoreManager')
local Theme = require('src.utils.Theme')
local Graphics = require('src.utils.Graphics')
local UIFactory = require('src.utils.UIFactory')
local ScreenManager = require('lib.ScreenManager')
local lume = require('lib.lume')


-- Entities
local Line = require('src.objects.Line')

---@class ScoreboardState : State
local ScoreboardState = State:extend()

function ScoreboardState:dispose()
    self.texts = {}
    self.radioButtons = {}
    self.titles = {}
    State.dispose(self)
end

function ScoreboardState:keypressed(key)
    if key == "escape" then
        self:slideOut()
    else
        State.keypressed(self, key)
    end
end

function ScoreboardState:updateScores(nwTiming)
    for _, level in ipairs(Vars.userPreferences.difficulty) do
        for _, key in ipairs(Vars.userPreferences.keySelect) do
            local score = ScoreManager.get(key, level, nwTiming)
            self.texts[level][key]:setCenteredText(tostring(score))
        end
    end
end

function ScoreboardState:slideOut(callback)
    callback = callback or function() ScreenManager.switch('MenuState') end
    local elements = {
        {
            element = self.title,
            target  = {y = -Vars.titleSize * 2, color = Theme.transparent}
        },
        {
            element = self.home,
            target = {y = love.graphics.getHeight(), color = Theme.transparent}
        }
    }
    for _,v in ipairs(self.radioButtons) do
        elements[#elements+1] = {
            element = v,
            target = {y = love.graphics.getHeight() + 20, color = Theme.transparent}
        }
    end

    for _,v in ipairs(self.titles) do
        elements[#elements+1] = {
            element = v,
            target = {color = Theme.transparent}
        }
    end

    self:transition(elements, callback, Vars.transition.spacing / 10)
end

function ScoreboardState:draw()
    Graphics.drawMusicBars()
    State.draw(self)
end

function ScoreboardState:init()
    local time = Vars.transition.tween / 3
    local middle = Vars.baseLine - Vars.lineHeight
    local font = assets.fonts.Oswald(2 * Vars.lineHeight / 3)
    local maxSize = 0

    self.texts = {}
    self.radioButtons = {}
    self.titles = {}
    local title = love.graphics.newText(assets.fonts.MarckScript(Vars.titleSize), tr("scoreboard"))


    local elements = {
        {
            element = UIFactory.createIconButton(self, {
                name = 'home',
                icon = 'Home',
                x = 5,
                y = love.graphics.getHeight(),
                callback = function()
                    self:slideOut()
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
                x = lume.round(love.graphics.getWidth() / 2 - title:getWidth() / 2)
            }),
            target = {color = Theme.font, y = 0}
        }
    }

    local line = self:addentity(Line, {
        color = Theme.transparent:clone(),
        x = 0,
        y = Vars.baseLine - Vars.lineHeight,
        width = 0,
    })
    elements[#elements+1] = {
        element = line,
        target = {color = Theme.font, width = love.graphics.getWidth()},
        time = time
    }
    self.titles[#self.titles+1] = line

    line = self:addentity(Line, {
        color = Theme.transparent:clone(),
        x = 0,
        y = Vars.baseLine,
        width = 0,
    })
    elements[#elements+1] = {
        element = line,
        target = {color = Theme.font, width = love.graphics.getWidth()},
        time = time,
    }
    self.titles[#self.titles+1] = line


    line = self:addentity(Line, {
        color = Theme.transparent:clone(),
        x = Vars.limitLine,
        y = Vars.baseLine - Vars.lineHeight,
        height = 0,
    })
    elements[#elements+1] = {
        element = line,
        target = {color = Theme.font, height = Vars.lineHeight * 2},
        time = time
    }
    self.titles[#self.titles+1] = line

    middle = middle + Vars.lineHeight

    -- Adding titles
    for _,v in ipairs(Vars.userPreferences.keySelect) do
        local text = love.graphics.newText(font, tr(v))
        local x = Vars.limitLine / 2 - text:getWidth() / 2
        maxSize = math.max(maxSize, text:getWidth())
        elements[#elements+1] = {
            element = UIFactory.createTitle(self, {
                name = 'titles',
                text = text,
                y = lume.round(middle),
                x = lume.round(x)
            }),
            target = {color =  Theme.font},
        }
        middle = middle + Vars.lineHeight
    end

    middle = Vars.limitLine + 10
    local space = love.graphics.getWidth() - middle
    local levels = Vars.userPreferences.difficulty
    space = space / #levels
    for i,v in ipairs(levels) do
        local text = love.graphics.newText(font, v == 'all' and tr(v) or tr('level', {level = v}))
        local padding = (space - text:getWidth()) / 2
        elements[#elements+1] = {
            element = UIFactory.createTitle(self, {
                name = 'titles',
                text = text,
                color = Theme.transparent:clone(),
                y = lume.round(Vars.baseLine - Vars.lineHeight),
                x = lume.round(middle + padding)
            }),
            target = {color = Theme.font},
            time = time
        }
        self.texts[v] = {}
        local yPos = Vars.baseLine
        for _, key in ipairs(Vars.userPreferences.keySelect) do
            local score = ScoreManager.get(key, v, Vars.userPreferences.time[1])
            text = love.graphics.newText(font, tostring(score))
            padding = (space - text:getWidth()) / 2
            elements[#elements+1] = {
                element = UIFactory.createTitle(self, {
                    name = 'titles',
                    text = text,
                    color = Theme.transparent:clone(),
                    y = lume.round(yPos),
                    x = lume.round(middle + padding)
                }),
                target = {color = Theme.font},
                time = time
            }
            self.texts[v][key] = elements[#elements].element
            yPos = yPos + Vars.lineHeight
        end

        middle = middle + space


        if i ~= #levels then
            line = self:addentity(Line, {
                    color = Theme.transparent:clone(),
                    x = middle,
                    y = Vars.baseLine - Vars.lineHeight,
                    height = Vars.lineHeight * 6,
            })
            elements[#elements+1] = {
                element = line,
                target = {color = Theme.hovered},
                time = time
            }
            self.titles[#self.titles+1] = line
        end
    end

    local radioSpace = love.graphics.getWidth() - Vars.limitLine - space
    space = radioSpace / #Vars.userPreferences.time
    local yPos = Vars.baseLine + Vars.lineHeight * 6
    local xPos = Vars.limitLine +  space / 2  - (Vars.titleSize * 0.60)
    for i, v in ipairs(Vars.userPreferences.time) do
        elements[#elements+1] = {
            element = UIFactory.createRadioButton(self, {
                x = xPos,
                value = v,
                name = 'radioButtons',
                padding = 10,
                width = space / 2,
                centerImage = true,
                isChecked = i == 1,
                y = love.graphics.getHeight()  + 20,
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
            target = {color = Theme.font, y = yPos}
        }
        xPos = xPos + space
    end
    self:transition(elements, nil, Vars.transition.spacing / 3)
end

return ScoreboardState