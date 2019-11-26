
local config = ...

config.logFile = config.logFile or 'logs.log'
config.maxSize = config.maxSize or 5 * 1024 * 1024-- 5 MB
config.logZip = config.logZip or config.logFile .. '.zip'

local run = true

local function compressLogFile()
    if love.filesystem.getInfo(config.logZip) then
        love.filesystem.remove(config.logZip)
    end
    love.filesystem.write(config.logZip, love.data.compress('data','zlib', love.filesystem.read(config.logFile)))
    love.filesystem.remove(config.logFile)
end

local function log(level, message)
    local now = os.date('*t')
    local content = string.format('%02d/%02d/%04d %02dh%02dm%02ds[%s]%s\n',
        now.day, now.month, now.year,
        now.hour, now.min, now.sec,
        level, message
    )
    love.filesystem.append(config.logFile, content)
    local info = love.filesystem.getInfo(config.logFile)
    if info and info.size > config.maxSize then
            compressLogFile()
    end
end

while run do
    local data = love.thread.getChannel('info'):demand()
    if data.type == 'stop' then
        run = false
    elseif data.type == 'log' then
        log(data.level or 'INFO', data.message)
    end
end

