local Logger  = require('lib.logger')
local DateUtils = require('src.utils.DateUtils')
local FileUtils = require('src.utils.FilesUtils')


-- Mocking love environement
_G['love'] = {
    graphics = {
        getHeight = function() return 10 end
    }
}
_G['Vars'] = require('src.Vars')

FileUtils.readCompressedData = function()
    local date = DateUtils.now()

    return {
        {
            timePlayed = 30,
            correctNotes = 30,
            wrongNotes = 0,
            avgReacTime = 1.0,
            date  = {year = date.year, month = date.month, day = date.day, hour = date.hour, sec = date.sec},
            difficulty = '1',
            key = 'gClef',
            time = '30s'
        },
        {
            timePlayed = 30,
            correctNotes = 30,
            wrongNotes = 0,
            avgReacTime = 1.0,
            date  = {year = date.year, month = date.month, day = date.day, hour = date.hour, sec = date.sec},
            difficulty = '1',
            key = 'gClef',
            time = '30s'
        },
        {
            timePlayed = 30,
            correctNotes = 30,
            wrongNotes = 0,
            avgReacTime = 1.0,
            date  = {year = date.year, month = date.month, day = date.day, hour = date.hour, sec = date.sec},
            difficulty = '1',
            key = 'gClef',
            time = '30s'
        }
    }
end

Logger.try = function(_, func, default)
    local success, data = pcall(func, default)
    if not success then
        print('error : ' .. data)
        return default
    end
    return data
end

local StatisticsManager = require('src.data.StatisticsManager')


describe("StatisticsManager", function()

    it("Should correctly init the stats manager", function()
        StatisticsManager.init()
        local globalStats = StatisticsManager.getGlobals()
        assert.are.equals(3, globalStats.totalGames)
        assert.are.equals(1.0, globalStats.avgReacTime)
        assert.are.equals(90, globalStats.totalCorrectNotes)
        assert.are.equals(0, globalStats.totalWrongNotes)
        assert.are.equals(90, globalStats.totalTimePlayed)
    end)

    local mock = {
        finalize = function(_)
            local date = DateUtils.now()
    
            return {
                timePlayed = 30,
                correctNotes = 30,
                wrongNotes = 0,
                avgReacTime = 1.0,
                date  = {year = date.year, month = date.month, day = date.day, hour = date.hour, sec = date.sec},
                difficulty = '1',
                key = 'gClef',
                time = '30s'
            }
        end
    }
    

    it("Should correctly add a new stat", function()
        StatisticsManager.add(mock)
        local globalStats = StatisticsManager.getGlobals()
        assert.are.equals(4, globalStats.totalGames)
        assert.are.equals(1.0, globalStats.avgReacTime)
        assert.are.equals(120, globalStats.totalCorrectNotes)
        assert.are.equals(0, globalStats.totalWrongNotes)
        assert.are.equals(120, globalStats.totalTimePlayed)
    end)

    local mock2 = {
        finalize = function(_)
            local date = DateUtils.now()
    
            return {
                timePlayed = 120,
                correctNotes = 10,
                wrongNotes = 50,
                avgReacTime = 2.0,
                date  = {year = date.year, month = date.month, day = date.day, hour = date.hour, sec = date.sec},
                difficulty = '1',
                key = 'gClef',
                time = '30s'
            }
        end
    }

    it("Should correctly add a new stat", function()
        StatisticsManager.add(mock2)
        local globalStats = StatisticsManager.getGlobals()
        assert.are.equals(5, globalStats.totalGames)
        assert.are.equals((120.0 + 20.0)  / (130.0), globalStats.avgReacTime)
        assert.are.equals(130, globalStats.totalCorrectNotes)
        assert.are.equals(50, globalStats.totalWrongNotes)
        assert.are.equals(240, globalStats.totalTimePlayed)
    end)
end)