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

local function mock(data)
    return {
        finalize = function(_)
            local date = DateUtils.now()
            data.date = {year = date.year, month = date.month, day = date.day, hour = date.hour, sec = date.sec}
            return data
        end
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

FileUtils.readCompressedData = function()
    local date = DateUtils.now()
    return {
        {
            timePlayed = 30,
            correctNotes = 0,
            avgReacTime = 0,
            difficulty = '1',
            date = {year = date.year, month = date.month, day = date.day, hour = date.hour, sec = date.sec},
            key = 'gClef',
            time = '30s',
        }
    }
end


local StatisticsManager = require('src.data.StatisticsManager')

describe("Testing stats edge cases", function()


    it("Should handle the 0 points cases", function()
        StatisticsManager.init()
        local globalStats = StatisticsManager.getGlobals()
        assert.are.equals(1, globalStats.totalGames)
        assert.are.equals(0.0, globalStats.avgReacTime)
        assert.are.equals(0, globalStats.totalCorrectNotes)
        assert.are.equals(0, globalStats.totalWrongNotes)
        assert.are.equals(30, globalStats.totalTimePlayed)
    end)
end)