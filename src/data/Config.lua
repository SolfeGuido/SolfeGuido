
local lume = require('lib.lume')
local i18n = require('lib.i18n')
local Theme = require('src.utils.Theme')

local Config = {}

local _configData = {}

local function getSimpleLocale()
    local l = os.setlocale()
    return l:sub(1, 2):lower()
end


function Config.parse()
    local conf = {}
    if love.filesystem.getInfo(Vars.configSave) then
        conf = lume.deserialize(love.filesystem.read(Vars.configSave))
        local allPrefs = Vars.userPreferences
        for k,v in pairs(allPrefs) do
            _configData[k] = conf[k] or v[1]
        end
    else
        conf = Vars.userPreferences
        for k,v in pairs(conf) do
            _configData[k] = v[1]
        end
        -- trying to get the computer locale
        local l = getSimpleLocale()
        if lume.find(Vars.userPreferences.lang, l) then
            _configData.lang = l
        end
    end
    Config.updateSound()
end

function Config.updateSound()
    love.audio.setVolume(_configData.sound == 'off' and 0 or 1)
end

---@param key string the key config to update
---@param value any the value to set
---@return boolean true if the value was updated, false otherwise
function Config.update(key, value)
    if _configData[key] == value then return false end
    _configData[key] = value
    if key == "sound" then Config.updateSound() end
    if key == "lang" then i18n.setLocale(value) end
    if key == "theme" then Theme.updateTheme(value) end
    Config.save()
    return true
end

function Config.save()
    love.filesystem.write(Vars.configSave , lume.serialize(_configData))
end

return setmetatable(Config, {
    __newindex = function()
        error("Cannot directly access config, use Config.update instead")
    end,
    __index = function(table, k)
        assert(type(k) == "string", "Accessed property must be a string")
        local conf = rawget(table, k)
        if conf then return conf end
        if _configData[k] then return _configData[k] end
        error("Configuration " .. k .. " not found")
    end
})