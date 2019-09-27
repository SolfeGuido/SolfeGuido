
local lineHeight = 20

return {
    color = {
        black = function() return {0, 0, 0, 1} end,
        transparent = function() return {0, 0, 0, 0} end
    },
    userPreferences = {
        sound = {'on', 'off'},
        lang = {'en', 'fr'},
        noteStyle = {'en', 'it'},
        keySelect = {'gKey', 'fKey'}
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
        lowestNote = 3
    },
    fKey = {
        height = lineHeight * 3,
        xOrigin = 21,
        yOrigin = 23,
        x = 30,
        y = lineHeight * 3,
        image = 'FKey',
        lowestNote = 5
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