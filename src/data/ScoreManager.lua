
local FileUtils = require('src.utils.FilesUtils')
local Logger = require('lib.logger')

---@class ScoreManager this class is a singleton
--- used to keep the game's best scores
--- The score depends on three variables:
--- The clef chosen by the user (fclef, gClef, ...)
--- The time chosen by the user (30s, 1mn, ...)
--- The level chosen by the user (level 1, ..., all levels)
--- Every possible configuration is initialized with a score
--- of 0, then when the user finishes a game, and beats the
--- best saved score, it is updated, and saved
local ScoreManager = {}

local scores = {}

--- Changes the name of some keys, because that's how they're called
---@param oldScores table the list of scores to update
---@return table the updated table
local function fixScore(oldScores)
    local oldKeys = { fKey = 'fClef', gKey = 'gClef' }
    for key, value in pairs(oldScores) do
        if oldKeys[key] then
            oldScores[oldKeys[key]] = value
            oldScores[key] = nil
        end
    end
    return oldScores
end

--- Parses the scores file, and keep it
--- in memory, in a table
--- Also updates the scores when switching version
function ScoreManager.init()
    local existing = Logger.try('Init score manager', function()
        return FileUtils.readCompressedData(Vars.score.fileName, Vars.score.dataFormat, {})
    end, {})

    existing = fixScore(existing)

    for _, key in ipairs(Vars.userPreferences.keySelect) do
        scores[key] = {}
        for _, diff in ipairs(Vars.userPreferences.difficulty) do
            scores[key][diff] = (existing[key] or {})[diff] or {}
            for _, time in ipairs(Vars.userPreferences.time) do
                scores[key][diff][time] = scores[key][diff][time] or 0
            end
        end
    end
end

---@param key string
---@param difficulty string
function ScoreManager.get(key, difficulty, timing)
    return scores[key][difficulty][timing] or 0
end

--- Checks if the given score is better than best one saved
--- if the given score is better, it will update the internal table
--- otherwise, nothing will change
---@param key string
---@param difficulty string
---@param timing string
---@param score number
---@return boolean wether the score was actually updated
function ScoreManager.update(key, difficulty, timing, score)
    if score > scores[key][difficulty][timing] then
        scores[key][difficulty][timing] = score
        ScoreManager.save()
        return true
    end
    return false
end

--- Saves the in-memory data in the save file
function ScoreManager.save()
    Logger.try('Saving scores', function()
        FileUtils.writeCompressedData(Vars.score.fileName, Vars.score.dataFormat, scores)
    end)
end

return ScoreManager