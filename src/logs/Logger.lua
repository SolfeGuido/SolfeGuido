local Logger = {}

local levels = {'DEBUG', 'INFO', 'WARNING', 'ERROR', 'FATAL'}
local thread = nil

function Logger.log(level, message)
    love.thread.getChannel('info'):push({type = 'log', level = level, message = message})
end

function Logger.close()
    love.thread.getChannel('info'):push({type = 'stop'})
    thread:wait()
end

for _, v in ipairs(levels) do
    Logger[string.lower(v)] = function(...) Logger.log(v, ...) end
end

function Logger.init()
    thread = love.thread.newThread('src/logs/LoggerThread.lua')
    thread:start()
    Logger.info('Starting up')
end



return Logger