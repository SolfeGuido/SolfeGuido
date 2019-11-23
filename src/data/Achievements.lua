local lume = require('lib.lume')


local Achievements = {}

local allAchievements = nil

local function initNewAchievements(list)
    for _,v in ipairs(list) do
        v.completed = false
        v.id = lume.uuid()
    end
    return list
end

local function mergeAchievements(existing, potentialNws)
    for _,v in ipairs(potentialNws) do
        
    end
end

function Achievements.init()
    -- Check for achievement file in saves
    -- If does not exist, create a new one with all the datas
    local list = assets.AchievementList
    if love.filesystem.getInfo(Vars.achievements.fileName) then
        local rawData = love.filesystem.read(Vars.achievements.fileName)
        local str = love.data.decompress('string', Vars.statistics.dataFormat, rawData)
        local achievements = lume.deserialize(str)
        allAchievements = mergeAchievements(achievements, list)
    else
        allAchievements = initNewAchievements(list)
    end
end

function Achievements.save()

end

function Achievements.getAll()
    return allAchievements
end


return Achievements