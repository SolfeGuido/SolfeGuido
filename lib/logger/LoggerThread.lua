
local run = true
local function log(level, message)
    local today = os.date('*t')
    local content = string.format('%02d/%02d/%04d %02dh%02dm%02s[%s]%s\n',
        today.day, today.month, today.year,
        today.hour, today.min, today.sec,
        level, message
    )
    love.filesystem.append('solfeguido.log', content)
    -- check for size, and if too big, zip and create new one
    -- if error ... ignore or fatal ?
end

while run do
    local data = love.thread.getChannel('info'):demand()
    if data.type == 'stop' then
        run = false
    elseif data.type == 'log' then
        log(data.level or 'INFO', data.message)
    end
end

