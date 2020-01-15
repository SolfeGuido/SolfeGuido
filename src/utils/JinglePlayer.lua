
local JinglePlayer = {}

function JinglePlayer.play(jingle, timer)
    for _, v in ipairs(jingle) do
        timer:after(v.after, function()
            assets.notes[v.note]:play()
        end)
    end
end

return JinglePlayer