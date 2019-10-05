
local lume = require('lib.lume')
local i18n = require('lib.i18n')

local Config = {}


local function getSimpleLocale()
    local l = os.setlocale()
    return l:sub(1, 2):lower()
end


function Config.parse()
    getSimpleLocale()
    local conf = {}
    if love.filesystem.getInfo(assets.config.configSave) then
        conf = love.filesystem.load(assets.config.configSave)()
        for k,v in pairs(conf) do
            Config[k] = v
        end
    else
        conf = assets.config.userPreferences
        for k,v in pairs(conf) do
            Config[k] = v[1]
        end
        -- trying to get the computer locale
        local l = getSimpleLocale()
        if lume.find(assets.config.userPreferences.lang, l) then
            Config.lang = l
        end
    end
    Config.updateSound()
end

function Config.updateSound()
    if Config.sound == 'off' then
        love.audio.setVolume(0)
    else
        love.audio.setVolume(1)
    end
end

function Config.update(key, value)
    Config[key] = value
    if key == "sound" then Config.updateSound() end
    if key == "lang" then i18n.setLocale(value) end
    Config.save()
end

function Config.save()
    local elems = {"return {"}
    for k,v in pairs(Config) do
        if type(v) ~= "function" then
            v = type(v) == 'string' and "'" .. v .. "'" or tostring(v)
            elems[#elems+1] = k .. ' = ' .. v .. ','
        end
    end
    elems[#elems+1] = '}'

    local total = table.concat(elems, '\n')
    love.filesystem.write(assets.config.configSave , total)
end




return Config