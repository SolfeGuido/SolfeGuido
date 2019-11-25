local Config = require('src.data.Config')
local StatisticsManager = require('src.data.StatisticsManager')
local Logger = require('lib.logger')

function love.quit(a)
    Config.save()
    StatisticsManager.save()
    Logger.info('Exiting...')
    Logger.close()
    return a
end
