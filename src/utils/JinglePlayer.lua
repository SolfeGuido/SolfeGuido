
local JinglePlayer = {}

function JinglePlayer.play(jingle, timer)
    for _, v in ipairs(jingle.notes) do
        timer:after(v.after + (jingle.shift or 0), function()
            assets.sounds.notes[v.note]:play({volume = v.volume or 1})
        end)
    end
end

return JinglePlayer