
local lume = require('lib.lume')
local i18n = require('lib.i18n')
local Logger = require('lib.logger')
local FileUtils = require('src.utils.FilesUtils')
local Theme = require('src.utils.Theme')

---@class Config
--- Singleton class, used to save all the user preferences
--- the theme, language, sound, ..., whenever the user
--- updates one of the preferences, some internal functions can
--- be called to update the necessary stuff (mute the sound for example)
--- The config is store as a plain text, since it's not something at risk
--- if the user changes directly changes it
local Config = {}

local _configData = {}
local _needsUserHelp = false

---@return string The computer's locale
--- doesn't work really well on mobile though :/
local function getSimpleLocale()
    local l = os.setlocale()
    return l:sub(1, 2):lower()
end

--- Renaming things because that's how they're called
local function fixConfig()
    -- 1.3 keySelect renaming
    if _configData.keySelect == 'fKey' then
        _configData.keySelect = 'fClef'
    elseif _configData.keySelect == 'gKey' then
        _configData.keySelect = 'gClef'
    end
end

--- Reads the user's config file
--- Updates the save file if needed
--- And keep in memory the configuration
function Config.parse()
    _needsUserHelp = love.filesystem.getInfo(Vars.configSave) == nil
    local conf = Logger.try('Init config', function()
        return FileUtils.readData(Vars.configSave, {})
    end, {})

    -- Find user locale
    if not conf.lang then
        local l = getSimpleLocale()
        if lume.find(Vars.userPreferences.lang, l) then
            conf.lang = l
        end
    end

    -- Setting the config
    local allPrefs = Vars.userPreferences
    for k,v in pairs(allPrefs) do
        _configData[k] = conf[k] or v[1]
    end

    -- Update various things depending on the versions
    fixConfig()

    Config.updateSound()
end

--- When the sound config is changed, changes the
--- games sound
function Config.updateSound()
    if _G['SOUNDTAG'] then
        SOUNDTAG.volume = _configData.sound == 'off' and 0.0 or 1.0
    end
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

function Config.needsUserHelp()
    return _needsUserHelp
end

--- Saves the configuration into the config file
function Config.save()
    Logger.try('Saving config', function() FileUtils.writeData(Vars.configSave, _configData) end)
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