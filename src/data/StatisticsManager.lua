
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

local function extractGlobals(games, today)
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
        avgReac = avgReac + (v.averageReactionTime * (v.correctNotes or 1))

        -- Find streaks
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
    avgReac = avgReac / tCorrect
    local res = {
        totalGames = #gameList,
        date = today,
        totalCorrectNotes = tCorrect,
        totalWrongNotes = tWrong,
        averageReactionTime = avgReac,
        playedToday = games[#games].date.day == today.day,
        longestPlayStreak = maxStreak,
        currentPlayStreak = currentStreak,
    }
    for k,v in pairs(res) do
        print(k,v)
    end
    return res
end

function StatisticsManager.init()

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
        globalStats = extractGlobals(gameList, today)
    else
        gameList = {}
        globalStats = {
            totalGames = #gameList,
            date = today,
            totalCorrectNotes = 0,
            totalWrongNotes = 0,
            averageReactionTime = 0,
            playedToday = false,
            longestPlayStreak = 0,
            currentPlayStreak = 0
        }
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