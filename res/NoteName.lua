local order = {'C', 'C#', 'D', 'D#','E','F', 'F#','G', 'G#','A', 'A#','B'}

local notes = {}
for i = 1,7 do
    for j = 1, #order do
        notes[#notes+1] = order[j] .. tostring(i)
    end
end


return notes