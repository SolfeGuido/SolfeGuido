
local Logger = require('lib.logger')
local DateUtils = require('src.utils.DateUtils')
local FileUtils = require('src.utils.FilesUtils')

---@class StatsitcsManager
---@field news string[] the news of the current version
local StatisticsManager = {
    news = {'new1', 'new2', 'new3'}
}

local gameList = nil
local globalStats = nil

--- When changing from version 1.3 to version 1.2,
--- some internal stats were changed, this function is here
--- to help with that
---@param games table the old statistics
---@return table the fixed statistics
local function fixStatistics(games)
    local today = DateUtils.now()
    table.sort(games, function(a,b) return os.difftime(os.time(a.date), os.time(b.date)) < 0 end)
    local tPlayed = 0
    local tCorrect = 0
    local tWrong = 0
    local avgReac = 0
    local firstDay = games[1].date
    local currentStreak = 1
    local maxStreak = 1

    for _, v in ipairs(games) do
        -- Increment globals
        tPlayed = tPlayed + (v.timePlayed or 0)
        tCorrect = tCorrect + (v.correctNotes or 0)
        tWrong = tWrong + (v.wrongNotes or 0)
        avgReac = avgReac + (v.avgReacTime * (v.correctNotes or 1))

        -- Find streaks
        if DateUtils.within24Hours(firstDay, v.date) then
            if not DateUtils.sameDay(firstDay, v.date) then
                currentStreak = currentStreak + 1
            end
        else
            maxStreak = math.max(currentStreak, maxStreak)
            currentStreak = 1
        end
        firstDay = v.date
    end
    maxStreak = math.max(currentStreak, maxStreak)
    if not DateUtils.sameDay(firstDay, today) then
        currentStreak = 1
    end

    if tCorrect > 0 then
        avgReac = avgReac / tCorrect
    else
        avgReac = 0
    end
    while #games > Vars.statistics.maxGames do
        table.remove(games, 1)
    end
    return {
        globals = {
            totalGames = #games,
            totalCorrectNotes = tCorrect,
            totalWrongNotes = tWrong,
            totalTimePlayed = tPlayed,
            avgReacTime = avgReac,
            longestStreak = maxStreak,
            currentStreak = currentStreak
        },
        games = games
    }
end

--- Reads the saved statistics, and keep them in memory
--- if the version changed since the last launch, it will
--- fix the old save
function StatisticsManager.init()
    local default = {
        globals = {
            totalGames = 0,
            totalCorrectNotes = 0,
            totalWrongNotes = 0,
            totalTimePlayed = 0,
            avgReacTime = 0,
            longestStreak = 0,
            currentStreak = 0
        },
        games = {}
    }
    local data = Logger.try('Init statistics manager', function()
        return FileUtils.readCompressedData(Vars.statistics.fileName, Vars.statistics.dataFormat, default)
    end, default)
    -- 1.3 fix from 1.2 (saving globals too)
    if #data > 0 and not data.globals then
        data = fixStatistics(data)
    end
    StatisticsManager.newVersionAvailable = data.gameVersion ~= Vars.appVersion
    gameList = data.games
    globalStats = data.globals
end

--- Adds the given gameStatistics to the list
--- of all statistics, and updates the global
--- statistics
---@param stats GameStatistics
function StatisticsManager.add(stats)
    local obj = stats:finalize()
    local now = DateUtils.now()
    gameList[#gameList+1] = obj
    if not globalStats.playedToday then
        if #gameList == 1 then
            globalStats.currentStreak = 1
            globalStats.longestStreak = 1
        else
            local previous = gameList[#gameList - 1]
            if DateUtils.within24Hours(previous.date, now) and not DateUtils.sameDay(previous.date, now) then
                globalStats.currentStreak = globalStats.currentStreak + 1
                globalStats.longestStreak = math.max(globalStats.currentStreak, globalStats.longestStreak)
            end
        end
    end
    local tCorrect = globalStats.totalCorrectNotes
    globalStats.totalTimePlayed = globalStats.totalTimePlayed + obj.timePlayed
    globalStats.totalCorrectNotes = tCorrect + obj.correctNotes
    globalStats.totalWrongNotes = globalStats.totalWrongNotes + obj.wrongNotes
    if obj.correctNotes > 0 then
        globalStats.avgReacTime = ((globalStats.avgReacTime * tCorrect) +
        (obj.avgReacTime * obj.correctNotes) ) /
        (tCorrect + obj.correctNotes)
    end
    globalStats.totalGames = globalStats.totalGames + 1
    if #gameList > Vars.statistics.maxGames then
        table.remove(gameList, 1)
    end
end

--- Saves the current stats, the global and
--- every game's statistics
--- also saves the app version to fix the data
--- when updating to a new version
function StatisticsManager.save()
    local data = {
        games = gameList,
        globals = globalStats,
        gameVersion = Vars.appVersion
    }
    Logger.try('Saving statistics', function()
        return FileUtils.writeCompressedData(Vars.statistics.fileName, Vars.statistics.dataFormat, data)
    end)
end


--- Accessor to the list of all games
---@return table
function StatisticsManager.getAll()
    return gameList
end

--- Accessor to the global statistics
---@return table
function StatisticsManager.getGlobals()
    return globalStats
end


return StatisticsManager