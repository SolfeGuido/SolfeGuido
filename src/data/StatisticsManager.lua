
local Logger = require('lib.logger')
local DateUtils = require('src.utils.DateUtils')
local FileUtils = require('src.utils.FilesUtils')

local StatisticsManager = {}

local gameList = nil
local globalStats = nil


local function extractGlobals(games)
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
    avgReac = avgReac / tCorrect
    return {
        totalGames = #gameList,
        totalCorrectNotes = tCorrect,
        totalWrongNotes = tWrong,
        avgReacTime = avgReac,
        longestStreak = maxStreak,
        currentStreak = currentStreak,
    }
end

function StatisticsManager.init()

    --[[To ensure correctness of the time
        We could connect to a remote server and get the 'real' time from there
        But since we want the game to work offline, and that the streak system
        is just for the user...
        If the user cheats, he just cheats on himself
    ]]--
    gameList = {}
    globalStats = {
        totalGames = #gameList,
        totalCorrectNotes = 0,
        totalWrongNotes = 0,
        avgReacTime = 0,
        longestStreak = 0,
        currentStreak = 0
    }
    gameList = Logger.try('Init statistics manager', function()
        return FileUtils.readCompressedData(Vars.statistics.fileName, Vars.statistics.dataFormat, {})
    end, {})
    if #gameList > 0 then
        globalStats = extractGlobals(gameList)
    end
end

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
    globalStats.totalCorrectNotes = tCorrect + obj.correctNotes
    globalStats.totalWrongNotes = globalStats.totalWrongNotes + obj.wrongNotes
    globalStats.avgReacTime = ((globalStats.avgReacTime * tCorrect) + obj.avgReacTime) / (tCorrect + 1)
    globalStats.totalGames = globalStats.totalGames + 1
end

function StatisticsManager.save()
    Logger.try('Saving statistics', function()
        return FileUtils.writeCompressedData(Vars.statistics.fileName, Vars.statistics.dataFormat, gameList)
    end)
end



function StatisticsManager.getAll()
    return gameList
end

function StatisticsManager.getGlobals()
    return globalStats
end


return StatisticsManager