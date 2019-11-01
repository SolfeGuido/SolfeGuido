
local lume = require('lib.lume')
local ScoreManager = {}

local scores = {}

function ScoreManager.init()
    local existing = {}
    if love.filesystem.getInfo(Vars.score.fileName) then
        local data = love.filesystem.read(Vars.score.fileName)
        local str = love.data.decompress('string', Vars.score.dataFormat, data)
        existing = lume.deserialize(str)
    end

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
    end
end

function ScoreManager.save()
    local str = lume.serialize(scores)
    local data = love.data.compress('data',Vars.score.dataFormat, str)
    love.filesystem.write(Vars.score.fileName, data)
end

return ScoreManager