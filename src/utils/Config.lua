
local lume = require('lib.lume')
local i18n = require('lib.i18n')
local Theme = require('src.utils.Theme')

local Config = {}


local function getSimpleLocale()
    local l = os.setlocale()
    return l:sub(1, 2):lower()
end


function Config.parse()
    getSimpleLocale()
    local conf = {}
    if love.filesystem.getInfo(Vars.configSave) then
        conf = lume.deserialize(love.filesystem.read(Vars.configSave))
        for k,v in pairs(conf) do
            Config[k] = v
        end
    else
        conf = Vars.userPreferences
        for k,v in pairs(conf) do
            Config[k] = v[1]
        end
        -- trying to get the computer locale
        local l = getSimpleLocale()
        if lume.find(Vars.userPreferences.lang, l) then
            Config.lang = l
        end
    end
    Config.updateSound()
end

function Config.updateSound()
    love.audio.setVolume(Config.sound == 'off' and 0 or 1)
end

---@param key string the key config to update
---@param value any the value to set
---@return boolean true if the value was updated, false otherwise
function Config.update(key, value)
    if Config[key] == value then return false end
    Config[key] = value
    if key == "sound" then Config.updateSound() end
    if key == "lang" then i18n.setLocale(value) end
    if key == "theme" then Theme.updateTheme(value) end
    Config.save()
    return true
end

local function isFunction(x)
    return type(x) == "function"
end

function Config.save()
    love.filesystem.write(Vars.configSave , lume.serialize(lume.reject(Config, isFunction, true)))
end




return Config