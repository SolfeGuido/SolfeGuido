
local lume = require('lib.lume')

local Pitch = {}

function Pitch.distanceBetween(note1, note2)
    local index = lume.find(assets.NoteName, note1)
    local index2 = lume.find(assets.NoteName, note2)
    return index - index2
end

function Pitch.semiToneEquivalent(distance)
    if distance < 0 then
        return 1 - (-distance) / 12
    end
    return 1 + distance / 12
end


return Pitch