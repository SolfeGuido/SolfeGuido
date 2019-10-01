
local json = require('lib.json')
local ScoreManager = {}

local scores = {}

function ScoreManager.init()
    local existing = {}
    if love.filesystem.getInfo(assets.config.score.fileName) then
        local data = love.filesystem.read(assets.config.score.fileName)
        local str = love.data.decompress('string', assets.config.score.dataFormat, data)
        existing = json.decode(str)
    end

    for _, key in ipairs(assets.config.userPreferences.keySelect) do
        scores[key] = {}
        for _, diff in ipairs(assets.config.userPreferences.difficulty) do
            scores[key][diff] = (existing[key] or {})[diff] or 0
        end
    end
end

function ScoreManager.get(key, difficulty)
    return scores[key][difficulty] or 0
end

function ScoreManager.update(key, difficulty, score)
    if score > scores[key][difficulty] then
        scores[key][difficulty] = score
        ScoreManager.save()
    end
end

function ScoreManager.save()
    local str = json.encode(scores)
    local data = love.data.compress('data',assets.config.score.dataFormat, str)
    love.filesystem.write(assets.config.score.fileName, data)
end

return ScoreManager