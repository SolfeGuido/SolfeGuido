
local lineHeight = 20

local order = {'C', 'D','E','F','G','A','B'}

local notes = {'A1','B1'}

for i = 2,5 do
    for j = 1, #order do
        notes[#notes+1] = order[j] .. tostring(i)
    end
end

notes[#notes+1] = 'D6'
notes[#notes+1] = 'E6'


local config = {
    color = {
        black = function() return {0, 0, 0, 1} end,
        transparent = function() return {0, 0, 0, 0} end,
        gray = function() return {0.3, 0.3, 0.3, 0.3} end
    },
    userPreferences = {
        sound = {'on', 'off'},
        lang = {'en', 'fr'},
        noteStyle = {'en', 'it'},
        keySelect = {'gKey', 'fKey'},
        difficulty = {'1', '2', '3', '4', 'all'}
    },
    configSave = 'config.lua',
    scoreSave = 'scores.bin',
    lineSpace = 20,
    lineHeight = lineHeight,
    limitLine = 150,
    maxProgressSpeed = 100,
    letterOrder = {'s', 'd', 'f', 'g', 'h', 'j', 'k'},
    itNotes = {'do', 'ré', 'mi', 'fa', 'sol', 'la', 'si'},
    enNotes = {'c', 'd', 'e', 'f', 'g', 'a', 'b'},
    trialTime = 60,
    timeLoss = 2,
    stopWatch = {
        x = 15,
        y = 15,
        size = 20,
        startColor = {0, 0.5, 0},
        endColor = { 0.5, 0 ,0}
    },
    score = {
        x = 50,
        y = 5,
        fontSize = 25
    },
    transition = {
        tween = 0.8,
        spacing = 0.01
    },
    gKey = {
        height = lineHeight * 7,
        xOrigin = 32,
        yOrigin = 132,
        x = 40,
        y = 0,
        image = 'GKey',
        lowestNote = 3,
        firstNote = 12,
        difficulties = {
            ['1'] = {4, 10},
            ['2'] = {11, 17},
            ['3'] = {14, 20},
            ['4'] = {0, 6},
            ['all'] = {0, 20}
        }
    },
    fKey = {
        height = lineHeight * 3,
        xOrigin = 21,
        yOrigin = 23,
        x = 30,
        y = lineHeight * 3,
        image = 'FKey',
        lowestNote = 5,
        difficulties = {
            ['1'] = {10, 16},
            ['2'] = {3, 9},
            ['3'] = {0, 6},
            ['4'] = {14, 20},
            ['all'] = {0, 20}
        }
    },
    note = {
        height = lineHeight * 4,
        xOrigin = 28,
        yOrigin = 184,
        image = 'note';
        padding = 10,
        distance = 50,
        backgroundColor = {0.64, 0.77, 0.91, 0.91},
        fadeAway = 1.5
    }
}

config['notes'] = notes

return config