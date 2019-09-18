
local lineHeight = 20

return {
    lineSpace = 20,
    lineHeight = lineHeight,
    limitLine = 150,
    maxProgressSpeed = 100,
    letterOrder = {'s', 'd', 'f', 'g', 'h', 'j', 'k'},
    trialTime = 60,
    timer = {
        startColor = {0, 1, 0},
        endColor = {1, 0 ,0}
    },
    gKey = {
        height = lineHeight * 7,
        xOrigin = 32,
        yOrigin = 132,
        xPosition = 40,
        yPosition = 0,
        image = 'GKey',
        lowestNote = 3
    },
    fKey = {
        height = lineHeight * 3,
        xOrigin = 21,
        yOrigin = 23,
        xPosition = 30,
        yPosition = lineHeight * 3,
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