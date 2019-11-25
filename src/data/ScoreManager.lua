
local FileUtils = require('src.utils.FilesUtils')
local Logger = require('lib.logger')
local ScoreManager = {}

local scores = {}

function ScoreManager.init()
    local success, existing = pcall(FileUtils.readCompressedData, Vars.score.fileName, Vars.score.dataFormat)
    if not success then Logger.error(existing) end

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

function ScoreManager.update(key, difficulty, timing, score)
    if score > scores[key][difficulty][timing] then
        scores[key][difficulty][timing] = score
        ScoreManager.save()
        return true
    end
    return false
end

function ScoreManager.save()
    local success, message = FileUtils.writeCompressedData(Vars.score.fileName, Vars.score.dataFormat, scores)
    if not success then
        print(message)
    end
end

return ScoreManager