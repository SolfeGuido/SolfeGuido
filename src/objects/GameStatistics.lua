
local Config = require('src.data.Config')
local Entity = require('src.Entity')
local DateUtils = require('src.utils.DateUtils')

--- Object used to store the statistics of a
--- game, must be updated while running the game
--- to keep track of the time-based stats
---@class GameStatistics : Entity
---@field timePlayed number
---@field correctNotes number
---@field wrongNotes number
---@field avgReacTime number
---@field currentReacTime number
---@field started boolean
local GameStatistics = Entity:extend()

function GameStatistics:new(container, options)
    Entity.new(self, container, options)
    self.timePlayed = 0
    self.correctNotes = 0
    self.wrongNotes = 0
    self.avgReacTime = 0
    self.currentReacTime = 0
    self.started = false
end

--- Start to keep track of the stats
function GameStatistics:start()
    self.started = true
    self.currentReacTime = 0
end

--- Stops to keep track of the stats every update
function GameStatistics:stop()
    self.started = false
end

--- When the answer given by the user was wrong
function GameStatistics:wrong()
    self.currentReacTime = 0
    self.wrongNotes = self.wrongNotes + 1
end

--- When the answer given by the user was correct
function GameStatistics:correct()
    self.avgReacTime = ((self.avgReacTime * self.correctNotes) + self.currentReacTime) / (self.correctNotes + 1)
    self.correctNotes = self.correctNotes + 1
    self.currentReacTime = 0
end

--- Updates the time based stats
--- (average reaction time and time played)
---@param dt number
function GameStatistics:update(dt)
    if not self.started then return end
    self.currentReacTime = self.currentReacTime + dt
    self.timePlayed = self.timePlayed + dt
end


--- Called by the statistics manager to
--- create a savable object, with the date
--- and the game configuration
---@return table
function GameStatistics:finalize()
    local date = DateUtils.now()
    return {
        timePlayed = self.timePlayed,
        correctNotes = self.correctNotes,
        wrongNotes = self.wrongNotes,
        avgReacTime = self.avgReacTime,
        date  = {year = date.year, month = date.month, day = date.day, hour = date.hour, sec = date.sec},
        difficulty = Config.difficulty,
        key = Config.keySelect,
        time = Config.time
    }
end

return GameStatistics