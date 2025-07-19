local Config = require("src.data.Config")
local StatisticsManager = require("src.data.StatisticsManager")
local Logger = require("lib.logger")

function love.quit()
	Config.save()
	StatisticsManager.save()
	Logger.info("Exiting...")
	Logger.close()
	return 0
end
