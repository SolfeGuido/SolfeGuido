
local middle = love.graphics.getHeight() / 2
local lineHeight = 30

local titleSize = 40


return {
    appName = 'SolfeGuido',
    titleSize = titleSize,
    baseLine = middle - (lineHeight * 3),
    userPreferences = {
        sound = {'on', 'off'},
        vibrations = {'on', 'off'},
        lang = {'en', 'fr'},
        noteStyle = {'englishNotes', 'romanNotes', 'latinNotes'},
        keySelect = {'gClef', 'fClef', 'both'},
        difficulty = {'1', '2', '3', '4', 'all'},
        answerType = {'buttons', 'piano', 'pianoWithNotes'},
        time = {'30s', '1mn', '2mn', '5mn'},
        theme = {'light', 'dark'},
        gameMode = {'timed', 'zen'}
    },
    configSave = 'config.json',
    lineSpace = 20,
    lineHeight = lineHeight,
    limitLine = 150,
    maxProgressSpeed = 100,
    romanNotes = {'do', 'ré', 'mi', 'fa', 'sol', 'la', 'si'},
    latinNotes = {'do', 're', 'mi', 'fa', 'sol', 'la', 'si'},
    englishNotes = {'C', 'D', 'E', 'F', 'G', 'A', 'B'},
    trialTime = 60,
    timeLoss = 2,
    stopWatch = {
        x = 15,
        y = 15,
        size = 20,
    },
    mobileButton = {
        fontSize = 20,
        padding = 10
    },
    score = {
        dataFormat = 'zlib',
        containerType = 'data',
        fileName = 'scores.bin',
        x = 50,
        y = 5,
        fontSize = 25
    },
    logs = {
        logFile = 'solfeguido.log',
        maxSize = 5 * 1024 * 1024,
        logZip = 'solfeguidolog.zip'
    },
    statistics = {
        dataFormat = 'zlib',
        containerType = 'data',
        fileName = 'statistics.bin'
    },
    achievements = {
        dataFormat = 'zlib',
        containerType = 'data',
        fileName = 'achievements.bin',
    },
    transition = {
        tween = 0.3,
        state = 1,
        spacing = 0.05
    },
    gClef = {
        height = 7,
        yOrigin = 2.6,
        icon = 'GClef',
        line = 4,
        lowestNote = 'F3',
        firstNote = 12,
        difficulties = {
            ['1'] =     {'C4', 'D4', 'E4', 'F4', 'G4', 'A4', 'B4'},
            ['2'] =     {'C5', 'D5', 'E5', 'F5', 'G5', 'A5', 'B5'},
            ['3'] =     {'F5', 'G5', 'A5', 'B5', 'C6', 'D6', 'E6'},
            ['4'] =     {'F3', 'G3', 'A3', 'B3', 'C4', 'D4', 'E4'},
            ['all'] =   {'F3', 'G3', 'A3', 'B3', 'C4', 'D4', 'E4', 'F4', 'G4', 'A4', 'B4', 'C5', 'D5', 'E5', 'F5', 'G5', 'A5', 'B5', 'C6', 'D6', 'E6'}
        }
    },
    fClef = {
        height = 5,
        yOrigin = 3.5,
        line = 1,
        icon = 'FClef',
        lowestNote = 'A1',
        difficulties = {
            ['1'] =     {'D3', 'E3', 'F3', 'G3', 'A3', 'B3', 'C4'},
            ['2'] =     {'E2', 'F2', 'G2', 'A2', 'B2', 'C3', 'D3'},
            ['3'] =     {'A1', 'B1', 'C2', 'D2', 'E2', 'F2', 'G2'},
            ['4'] =     {'A3', 'B3', 'C4', 'D4', 'E4', 'F4', 'G4'},
            ['all'] =   {'A1', 'B1', 'C2', 'D2', 'E2', 'F2', 'G2', 'A2', 'B2', 'C3', 'D3',  'E3', 'F3', 'G3', 'A3', 'B3', 'C4', 'D4', 'E4', 'F4', 'G4'}
        }
    },
    note = {
        height = 4.1,-- number of 'lines' of height
        yOrigin = 3.6,-- lower values = higher note position (and lower for reversed note)
        xOrigin = 0.5,
        image = 'note';
        padding = 0.5,
        distance = 1.3,
        fadeAway = 2,
        wrongRepeat = 1,
        wrongSpace = 0.3
    },
    mobile = {
        vibrationTime = 0.1
    },
    pianoHeight = 100
}