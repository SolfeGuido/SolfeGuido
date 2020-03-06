
--- It's in the name: it plays jingles
local JinglePlayer = {}

--- Queues all the notes of the given
--- array, in the given timer, can be used
--- for ... i don't know, a simple jingle
--- for example
---@param jingle table
---@param timer Timer
function JinglePlayer.play(jingle, timer)
    for _, v in ipairs(jingle.notes) do
        timer:after(v.after + (jingle.shift or 0), function()
            assets.sounds.notes[v.note]:play({volume = v.volume or 1})
        end)
    end
end

return JinglePlayer