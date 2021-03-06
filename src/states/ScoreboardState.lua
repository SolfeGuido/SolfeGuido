
-- LIBS
local State = require('src.State')
local ScoreManager = require('src.data.ScoreManager')
local Theme = require('src.utils.Theme')
local Graphics = require('src.utils.Graphics')
local UIFactory = require('src.utils.UIFactory')
local ScreenManager = require('lib.ScreenManager')
local RadioButtonGroup = require('src.objects.RadioButtonGroup')
local lume = require('lib.lume')


-- Entities
local Line = require('src.objects.Line')

--- State used to show the score acheived
--- in the different gamemodes and levels
---@class ScoreboardState : State
---@field private texts table
---@field private radioButtons table
---@field private title table
local ScoreboardState = State:extend()

--- resets everything
function ScoreboardState:dispose()
    self.texts = nil
    self.radioButtons = nil
    self.titles = nil
    State.dispose(self)
end

--- Capture the escape key to go back to the menu
---@param key string
function ScoreboardState:keypressed(key)
    if key == "escape" then
        self:slideOut()
    else
        State.keypressed(self, key)
    end
end

--- Changes all the texts to show the score
--- corresponding to the given timing
---@param nwTiming string
function ScoreboardState:updateScores(nwTiming)
    for _, level in ipairs(Vars.userPreferences.difficulty) do
        for _, key in ipairs(Vars.userPreferences.keySelect) do
            local score = ScoreManager.get(key, level, nwTiming)
            self.texts[level][key]:setCenteredText(tostring(score))
        end
    end
end

--- slides out back to the menu
---@param callback function
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
    for _,v in ipairs(self.radioButtons._entities) do
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

--- Inherited method
function ScoreboardState:draw()
    Graphics.drawMusicBars()
    State.draw(self)
end

--- Creates all the lines and the widgets
function ScoreboardState:init()
    local time = Vars.transition.tween / 3
    local middle = Vars.baseLine
    local font = assets.fonts.Oswald(2 * Vars.lineHeight / 3)
    local maxSize = 0

    self.texts = {}
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

    local line = self:addEntity(Line, {
        color = Theme.transparent:clone(),
        x = 0,
        y = Vars.baseLine,
        width = 0,
    })
    elements[#elements+1] = {
        element = line,
        target = {color = Theme.font, width = love.graphics.getWidth()},
        time = time
    }
    self.titles[#self.titles+1] = line

    line = self:addEntity(Line, {
        color = Theme.transparent:clone(),
        x = 0,
        y = Vars.baseLine + Vars.lineHeight * 6,
        width = 0,
    })
    elements[#elements+1] = {
        element = line,
        target = {color = Theme.font, width = love.graphics.getWidth()},
        time = time,
    }
    self.titles[#self.titles+1] = line


    line = self:addEntity(Line, {
        color = Theme.transparent:clone(),
        x = Vars.limitLine,
        y = Vars.baseLine,
        height = 0,
    })
    elements[#elements+1] = {
        element = line,
        target = {color = Theme.font, height = Vars.lineHeight * 6},
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
                y = lume.round(Vars.baseLine),
                x = lume.round(middle + padding)
            }),
            target = {color = Theme.font},
            time = time
        }
        self.texts[v] = {}
        local yPos = Vars.baseLine + Vars.lineHeight
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
            line = self:addEntity(Line, {
                    color = Theme.transparent:clone(),
                    x = middle,
                    y = Vars.baseLine,
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
    local yPos = Vars.baseLine + Vars.lineHeight * 7
    local xPos = Vars.limitLine +  space / 2  - (Vars.titleSize * 0.60)
    self.radioButtons = self:addEntity(RadioButtonGroup, {})
    for i, v in ipairs(Vars.userPreferences.time) do
        elements[#elements+1] = {
            element = UIFactory.createRadioButton(self.radioButtons, {
                x = xPos,
                value = v,
                padding = 10,
                width = space / 2,
                centerImage = true,
                isChecked = i == 1,
                y = love.graphics.getHeight()  + 20,
                framed = true,
                callback = function() self:updateScores(v) end,
                image = love.graphics.newText(font, v)
            }),
            target = {color = Theme.font, y = yPos}
        }
        xPos = xPos + space
    end
    self:transition(elements, nil, Vars.transition.spacing / 3)
end

return ScoreboardState