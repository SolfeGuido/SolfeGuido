
local lume = require('lib.lume')

local Pitch = {}

function Pitch.distanceBetween(note1, note2)
    local index = lume.find(assets.NoteName, note1)
    local index2 = lume.find(assets.NoteName, note2)
    local dist = math.abs(index - index2) / 12
    if index > index2 then
        return 1  - dist
    end
    return 1 + dist
end


return Pitch