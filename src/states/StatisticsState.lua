
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
    self:transition(self.ui:transitionOut(), callback)
end

function StatisticsState:init()
    local stats = StatisticsManager.getGlobals()
    local leftFunction = function(e) return Vars.limitLine - e:width() - 5 end
    local elements = self:startUI({
        fontSize = 2 * Vars.lineHeight / 3,
        fontName = 'Oswald',
        color = function() return Theme.transparent:clone() end
    })
        :createTransition()
            :add('Title', {
                from = 'top',
                to = 5,
                text = 'Statistics',
                fontName = 'MarckScript',
                x = 0,
                centered = true,
                fontSize = Vars.titleSize
            })
            :add('IconButton', {
                from = 'bottom',
                to = love.graphics.getHeight() -Vars.titleSize - 5,
                icon = 'Home',
                x = 5,
                callback = function() self:slideOut() end
            })
            :add('Title', {
                from = 'right',
                to = Vars.limitLine + 5,
                y = Vars.baseLine + Vars.lineHeight,
                text =  tr('total_games', {count = stats.totalGames})
            })
            :add('Title', {
                from = 'right',
                to = Vars.limitLine + 5,
                y = Vars.baseLine + Vars.lineHeight * 2,
                text = tr('total_points', {count = stats.totalCorrectNotes})
            })
            :add('Title', {
                from = 'right',
                to = Vars.limitLine + 5,
                y = Vars.baseLine + Vars.lineHeight * 3,
                text = 'avg_reaction_time',
            })
            :add('Title', {
                from = 'right',
                to = Vars.limitLine + 5,
                y = Vars.baseLine + Vars.lineHeight * 4,
                text = 'longest_streak'
            })
            :add('Title', {
                from = 'left',
                to = leftFunction,
                y = Vars.baseLine + Vars.lineHeight * 2,
                text = tostring(stats.totalCorrectNotes)
            })
            :add('Title', {
                from = 'left',
                to = leftFunction,
                y = Vars.baseLine + Vars.lineHeight * 3,
                text = string.format('%02.02f s', stats.avgReacTime)
            })
            :add('Title', {
                from = 'left',
                to = leftFunction,
                y = Vars.baseLine + Vars.lineHeight * 4,
                text = tr('days', {count = stats.longestStreak})
            })
            :add('Title', {
                from = 'left',
                to = leftFunction,
                y = Vars.baseLine + Vars.lineHeight,
                text = tostring(stats.totalGames)
            })
        :build()
    self:transition(elements)
end


return StatisticsState