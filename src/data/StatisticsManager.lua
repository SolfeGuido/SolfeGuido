
local lume = require('lib.lume')

local StatisticsManager = {}

local gameList = nil
local globalStats = nil

local oneDayDuration = 24 * 60 * 60

local function lessThanOneDayDiff(dateA, dateB)
    return os.difftime(os.time(dateB), os.time(dateA)) <= oneDayDuration
end

local function sameDay(dateA, dateB)
    return dateA.day == dateB.day
end

local function findStreaks(games, today)
    table.sort(games, function(a,b) return os.difftime(os.time(a.date), os.time(b.date)) < 0 end)
    local firstDay = games[0].date
    local currentStreak = 1
    local maxStreak = 0
    for _, v in ipairs(games) do
        if lessThanOneDayDiff(firstDay, v.date) then
            if not sameDay(firstDay, v.date) then
                currentStreak = currentStreak + 1
            end
        else
            maxStreak = math.max(currentStreak, maxStreak)
            currentStreak = 1
        end
        firstDay = v.date
    end
    if firstDay.day ~= today.day then
        currentStreak = 1
    end

    return maxStreak, currentStreak
end

function StatisticsManager.init()
    local tPlayed = 0
    local tCorrect = 0
    local tWrong = 0
    local avgReac = 0
    local longestPlayStreak = 0
    local currentPlayStreak = 0
    --[[To ensure correctness of the time
        We could connect to a remote server and get the 'real' time from there
        But since we want the game to work offline, and that the streak system
        is just for the user...
        If the user cheats, he just cheats on himself
    ]]--
    local today = os.date("*t")
    if love.filesystem.getInfo(Vars.statistics.fileName) then
        local data = love.filesystem.read(Vars.statistics.fileName)
        local str = love.data.decompress('string', Vars.statistics.dataFormat, data)
        gameList = lume.deserialize(str)
        longestPlayStreak, currentPlayStreak = findStreaks(gameList, today)

        for _, v in ipairs(gameList) do
            tPlayed = tPlayed + (v.timePlayed or 0)
            tCorrect = tCorrect + (v.correctNotes or 0)
            tWrong = tWrong + (v.wrongNotes or 0)
            avgReac = avgReac + (v.averageReactionTime * (v.correctNotes or 1))
        end
        avgReac = avgReac / tCorrect
    else
        gameList = {}
    end
    globalStats = {
        totalGames = #gameList,
        date = today,
        totalCorrectNotes = tCorrect,
        totalWrongNotes = tWrong,
        averageReactionTime = avgReac,
        playedToday = gameList[#gameList].day == today.day,
        longestPlayStreak = longestPlayStreak,
        currentPlayStreak = currentPlayStreak
    }
    for k, v in pairs(globalStats) do
        print(k,v)
    end
end

function StatisticsManager.add(stats)
    gameList[#gameList+1] = stats:finalize()
end

function StatisticsManager.save()
    local str = lume.serialize(gameList)
    local data = love.data.compress('data',Vars.statistics.dataFormat, str)
    love.filesystem.write(Vars.statistics.fileName, data)
end



function StatisticsManager.getAll()
    return gameList
end

function StatisticsManager.getGlobals()
    return globalStats
end


return StatisticsManager