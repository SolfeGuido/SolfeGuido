
local Config = require('src.data.Config')
local Entity = require('src.Entity')
local DateUtils = require('src.utils.DateUtils')

---@class GameStatistics : Entity
---@field timePlayed number
---@field correctNotes number
---@field wrongNotes number
---@field avgReacTime number
local GameStatistics = Entity:extend()

function GameStatistics:new(area, options)
    Entity.new(self, area, options)
    self.timePlayed = 0
    self.correctNotes = 0
    self.wrongNotes = 0
    self.avgReacTime = 0
    self.currentReacTime = 0
    self.started = false
end

function GameStatistics:start()
    self.started = true
    self.currentReacTime = 0
end

function GameStatistics:stop()
    self.started = false
end

function GameStatistics:wrong()
    self.currentReacTime = 0
    self.wrongNotes = self.wrongNotes + 1
end

function GameStatistics:correct()
    self.avgReacTime = ((self.avgReacTime * self.correctNotes) + self.currentReacTime) / (self.correctNotes + 1)
    self.correctNotes = self.correctNotes + 1
    self.currentReacTime = 0
end

function GameStatistics:update(dt)
    if not self.started then return end
    self.currentReacTime = self.currentReacTime + dt
    self.timePlayed = self.timePlayed + dt
end


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