
local State = require('src.State')
local Graphics = require('src.utils.Graphics')
local UIFactory = require('src.utils.UIFactory')
local Theme = require('src.utils.Theme')
local ScreenManager = require('lib.ScreenManager')

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

function StatisticsState:slideOut(callback)
    self:transition({
        {
            element = self.title,
            target = {color = Theme.transparent, y = -Vars.titleSize}
        },
        {
            element = self.homeButton,
            target = {color = Theme.transparent, y = love.graphics.getHeight()}
        },
        {
            element = self.madeWithTitle,
            target = {color = Theme.transparent, x = -self.madeWithTitle:width() - 5}
        },
        {
            element = self.soundsTitle,
            target = {color = Theme.transparent, x = -self.soundsTitle:width() - 5}
        },
        {
            element = self.iconsTitle,
            target = {color = Theme.transparent, x = -self.iconsTitle:width() - 5}
        },
        {
            element = self.byTitle,
            target = {color = Theme.transparent, x = -self.byTitle:width() - 5}
        },
        {
            element = self.loveImage,
            target = {color = Theme.transparent, x = love.graphics.getWidth()}
        },
        {
            element = self.loveTitle,
            target = {color = Theme.transparent, x = love.graphics.getWidth()}
        },
        {
            element = self.azariasTitle,
            target = {color = Theme.transparent, x = love.graphics.getWidth()}
        },
        {
            element = self.iowaTitle,
            target = {color = Theme.transparent, x = love.graphics.getWidth()}
        },
        {
            element = self.iconMoonTitle,
            target = {color = Theme.transparent, x = love.graphics.getWidth()}
        }
    }, callback)
end

function StatisticsState:init()
    local titleSizes = 2 * Vars.lineHeight / 3
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
                text = 'Total games',
                fontName = 'Oswald',
                name =  'totalGamesTitle',
                x = -100,
                y = Vars.baseLine + Vars.lineHeight,
                fontSize = titleSizes
            }),
            target = {color = Theme.font, x = Vars.limitLine - self.totalGamesTitle:width() - 5}
        },
        {
            element = UIFactory.createTitle(self, {
                text = 'Total points',
                fontName = 'Oswald',
                name = 'totalPointsTitle',
                x = -100,
                y = Vars.baseLine + Vars.lineHeight * 2,
                fontSize = titleSizes
            }),
            target = {color = Theme.font, x = Vars.limitLine - self.totalPointsTitle:width() - 5}
        },
        {
            element = UIFactory.createTitle(self, {
                text = 'Avg. reaction time',
                fontName = 'Oswald',
                name = 'averageReactionTimeTitle',
                x = -100,
                y = Vars.baseLine + Vars.lineHeight * 3,
                fontSize =  titleSizes
            }),
            target = {color = Theme.font, x = Vars.limitLine - self.averageReactionTimeTitle:width() - 5}
        },
        {
            element = UIFactory.createTitle(self, {
                text = 'Longest streak',
                fontName = 'Oswald',
                name = 'longestStreakTitle',
                x = -100,
                y = Vars.baseLine + Vars.lineHeight * 4,
                fontSize = titleSizes
            }),
            target = {color = Theme.font, x = Vars.limitLine - self.longestStreakTitle:width() - 5}
        },
        {
            element = UIFactory.createTitle(self, {
                text = 'Azarias',
                fontName = 'Oswald',
                name = 'azariasTitle',
                x = love.graphics.getWidth(),
                fontSize = titleSizes,
                y = Vars.baseLine + Vars.lineHeight * 2
            }),
            target = {color = Theme.font, x = Vars.limitLine + 5}
        },
        {
            element = UIFactory.createTitle(self, {
                text = 'IconMoonApp',
                fontName = 'Oswald',
                name = 'iconMoonTitle',
                x = love.graphics.getWidth(),
                fontSize = titleSizes,
                y = Vars.baseLine + Vars.lineHeight * 3
            }),
            target = {color = Theme.font, x = Vars.limitLine + 5}
        },
        {
            element = UIFactory.createTitle(self, {
                text = 'University of Iowa',
                fontName = 'Oswald',
                name = 'iowaTitle',
                x = love.graphics.getWidth(),
                y = Vars.baseLine + Vars.lineHeight * 4,
                fontSize = titleSizes
            }),
            target = {color = Theme.font, x = Vars.limitLine + 5}
        },
        {
            element = UIFactory.createTitle(self, {
                text = 'Löve2d',
                fontName = 'Oswald',
                name = 'loveTitle',
                x = love.graphics.getWidth(),
                y = Vars.baseLine + Vars.lineHeight,
                fontSize = titleSizes
            }),
            target = {color = Theme.font, x = Vars.limitLine + Vars.lineHeight}
        }
    })
end


return StatisticsState