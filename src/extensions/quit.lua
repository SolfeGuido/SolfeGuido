local Config = require('src.data.Config')
local StatisticsManager = require('src.data.StatisticsManager')
local ScoreManager = require('src.data.ScoreManager')
local Logger = require('lib.logger')

function love.quit(a)
    Config.save()
    StatisticsManager.save()
    --ScoreManager.save()
    Logger.info('Exiting...')
    Logger.close()
    return a
end
