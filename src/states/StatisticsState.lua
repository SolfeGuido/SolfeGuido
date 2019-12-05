
local State = require('src.State')
local Graphics = require('src.utils.Graphics')
local UIFactory = require('src.utils.UIFactory')
local Theme = require('src.utils.Theme')
local ScreenManager = require('lib.ScreenManager')
local StatisticsManager = require('src.data.StatisticsManager')

---@class StatisticsState : State
local StatisticsState = State:extend()

function StatisticsState:keypressed(key)
    if key == "escape" then

    else
        State.keypressed(self, key)
    end
end

function StatisticsState:draw()
    Graphics.drawMusicBars()
    State.draw(self)
end

function StatisticsState:keypressed(key)
    if key == "escape" then
        self:slideOut()
    else
        State.keypressed(self, key)
    end
end

function StatisticsState:slideOut(callback)
    callback = callback or function() ScreenManager.switch('MenuState') end
    local elements = {
        {
            element = self.title,
            target = {color = Theme.transparent, y = -Vars.titleSize}
        },
        {
            element = self.homeButton,
            target = {color = Theme.transparent, y = love.graphics.getHeight()}
        },
    }

    for _,v in ipairs(self.fromLeft) do
        elements[#elements+1] = {
            element = v,
            target = { color = Theme.transparent, x = -v:width() }
        }
    end

    for _,v in ipairs(self.fromRight) do
        elements[#elements+1] = {
            element = v,
            target = { color = Theme.transparent, x = love.graphics.getWidth() + 5}
        }
    end

    self:transition(elements, callback)
end

function StatisticsState:init()
    local titleSizes = 2 * Vars.lineHeight / 3
    local stats = StatisticsManager.getGlobals()
    self.fromLeft = {}
    self.fromRight = {}
    self:transition({
        {
            element = UIFactory.createTitle(self, {
                centered = true,
                name = 'title',
                text = 'Statistics',
                x = 0,
                y = -Vars.titleSize,
                color = Theme.transparent:clone()
            }),
            target = {color = Theme.font, y = 5}
        },
        {
            element = UIFactory.createIconButton(self, {
                icon = 'Home',
                name = 'homeButton',
                x = 5,
                y = love.graphics.getHeight(),
                color = Theme.transparent:clone(),
                callback = function()
                    self:slideOut(function()
                        ScreenManager.switch('MenuState')
                    end)
                end
            }),
            target = {color = Theme.font, y = love.graphics.getHeight() -Vars.titleSize - 5}
        },
        {
            element = UIFactory.createTitle(self, {
                text = 'total_games',
                fontName = 'Oswald',
                name =  'fromRight',
                x = love.graphics.getWidth(),
                y = Vars.baseLine + Vars.lineHeight,
                fontSize = titleSizes
            }),
            target = {color = Theme.font, x = Vars.limitLine + 5}
        },
        {
            element = UIFactory.createTitle(self, {
                text = 'total_points',
                fontName = 'Oswald',
                name = 'fromRight',
                x = love.graphics.getWidth(),
                y = Vars.baseLine + Vars.lineHeight * 2,
                fontSize = titleSizes
            }),
            target = {color = Theme.font, x = Vars.limitLine + 5}
        },
        {
            element = UIFactory.createTitle(self, {
                text = 'avg_reaction_time',
                fontName = 'Oswald',
                name = 'fromRight',
                x = love.graphics.getWidth(),
                y = Vars.baseLine + Vars.lineHeight * 3,
                fontSize =  titleSizes
            }),
            target = {color = Theme.font, x = Vars.limitLine + 5}
        },
        {
            element = UIFactory.createTitle(self, {
                text = 'longest_streak',
                fontName = 'Oswald',
                name = 'fromRight',
                x = love.graphics.getWidth(),
                y = Vars.baseLine + Vars.lineHeight * 4,
                fontSize = titleSizes
            }),
            target = {color = Theme.font, x =  Vars.limitLine + 5}
        },
        {
            element = UIFactory.createTitle(self, {
                text = tostring(stats.totalCorrectNotes),
                fontName = 'Oswald',
                name = 'fromLeft',
                x = -Vars.limitLine,
                fontSize = titleSizes,
                y = Vars.baseLine + Vars.lineHeight * 2
            }),
            target = {color = Theme.font, x = Vars.limitLine - self.fromLeft[#self.fromLeft]:width() - 5}
        },
        {
            element = UIFactory.createTitle(self, {
                text = string.format('%02.02f s', stats.avgReacTime),
                fontName = 'Oswald',
                name = 'fromLeft',
                x = -Vars.limitLine,
                fontSize = titleSizes,
                y = Vars.baseLine + Vars.lineHeight * 3
            }),
            target = {color = Theme.font, x = Vars.limitLine - self.fromLeft[#self.fromLeft]:width() - 5}
        },
        {
            element = UIFactory.createTitle(self, {
                text = tr('days', {count = stats.longestStreak}),
                fontName = 'Oswald',
                name = 'fromLeft',
                x = -Vars.limitLine,
                y = Vars.baseLine + Vars.lineHeight * 4,
                fontSize = titleSizes
            }),
            target = {color = Theme.font, x = Vars.limitLine - self.fromLeft[#self.fromLeft]:width() - 5}
        },
        {
            element = UIFactory.createTitle(self, {
                text = tostring(stats.totalGames),
                fontName = 'Oswald',
                name = 'fromLeft',
                x = -Vars.limitLine,
                y = Vars.baseLine + Vars.lineHeight,
                fontSize = titleSizes
            }),
            target = {color = Theme.font, x = Vars.limitLine - self.fromLeft[#self.fromLeft]:width() - 5}
        }
    })
end


return StatisticsState