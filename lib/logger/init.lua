
---@class Logger
---@field close function
---@field init function
---@field debug function
---@field info function
---@field warning function
---@field error function
---@field fatal function
local Logger = {}

local levels = {'DEBUG', 'INFO', 'WARNING', 'ERROR', 'FATAL'}
local thread = nil
local currentFilePath = (...):gsub("%.init$",""):gsub('%.', '/')

function Logger.log(level, message)
    love.thread.getChannel('info'):push({type = 'log', level = level, message = message})
end

function Logger.close()
    love.thread.getChannel('info'):push({type = 'stop'})
    thread:wait()
    thread:release()
    thread = nil
end

for _, v in ipairs(levels) do
    Logger[string.lower(v)] = function(...) Logger.log(v, ...) end
end

function Logger.try(message, func, default)
    Logger.info(message)
    local success, data = pcall(func, default)
    if not success then
        Logger.error(data)
        return default
    end
    return data
end

function Logger.init(config)
    thread = love.thread.newThread(currentFilePath .. '/LoggerThread.lua')
    thread:start(config)
    Logger.info('Starting up')
end



return Logger