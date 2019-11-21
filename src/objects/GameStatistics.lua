
local Config = require('src.data.Config')
local Entity = require('src.Entity')

---@class GameStatistics : Entity
local GameStatistics = Entity:extend()

function GameStatistics:new(area, options)
    Entity.new(self, area, options)
    self.timePlayed = 0
    self.correctNotes = 0
    self.wrongNotes = 0
    self.averageReactionTime = 0
    self.currentReactionTime = 0
    self.started = false
end

function GameStatistics:start()
    self.started = true
    self.currentReactionTime = 0
end

function GameStatistics:stop()
    self.started = false
end

function GameStatistics:wrong()
    self.currentReactionTime = 0
    self.wrongNotes = self.wrongNotes + 1
end

function GameStatistics:correct()
    self.averageReactionTime = ((self.averageReactionTime * self.correctNotes) + self.currentReactionTime) / (self.correctNotes + 1)
    self.correctNotes = self.correctNotes + 1
    self.currentReactionTime = 0
end

function GameStatistics:update(dt)
    if not self.started then return end
    self.currentReactionTime = self.currentReactionTime + dt
    self.timePlayed = self.timePlayed + dt
end


function GameStatistics:finalize()
    local date = os.date("*t")
    return {
        timePlayed = self.timePlayed,
        correctNotes = self.correctNotes,
        wrongNotes = self.wrongNotes,
        averageReactionTime = self.averageReactionTime,
        date  = {year = date.year, month = date.month, day = date.day, hour = date.hour, sec = date.sec},
        difficulty = Config.difficulty,
        key = Config.keySelect,
        time = Config.time
    }
end

return GameStatistics