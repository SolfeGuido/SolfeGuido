
local lineHeight = 20

return {
    lineSpace = 20,
    imagesPath = 'res/images',
    lineHeight = lineHeight,
    limitLine = 200,
    maxProgressSpeed = 100,
    noteDistance = 50,
    gKey = {
        height = lineHeight * 7,
        xOrigin = 32,
        yOrigin = 132,
        xPosition = 40,
        yPosition = 0,
        image = 'FKey'
    },
    fKey = {
        height = lineHeight * 3,
        xOrigin = 21,
        yOrigin = 21,
        xPosition = 30,
        yPosition = lineHeight * 4,
        image = 'GKey'
    },
    note = {
        height = lineHeight * 4,
        xOrigin = 28,
        yOrigin = 184,
        image = 'note'
    }
}