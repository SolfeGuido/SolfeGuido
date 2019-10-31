
local lineHeight = 30
local titleSize = 40


local config = {
    titleSize = titleSize,
    selectorSize = 18,
    baseLine = titleSize + lineHeight,
    userPreferences = {
        sound = {'on', 'off'},
        vibrations = {'on', 'off'},
        lang = {'en', 'fr'},
        noteStyle = {'en_note', 'ro_note'},
        keySelect = {'gKey', 'fKey', 'both'},
        difficulty = {'1', '2', '3', '4', 'all'},
        answerType = {'default', 'letters', 'buttons'},
        time = {'30s', '1mn', '2mn', '5mn'}
    },
    configSave = 'config.lua',
    lineSpace = 20,
    lineHeight = lineHeight,
    limitLine = 150,
    maxProgressSpeed = 100,
    letterOrder = {'s', 'd', 'f', 'g', 'h', 'j', 'k'},
    romanNotes = {'do', 'ré', 'mi', 'fa', 'sol', 'la', 'si'},
    englishNotes = {'C', 'D', 'E', 'F', 'G', 'A', 'B'},
    trialTime = 60,
    timeLoss = 2,
    stopWatch = {
        x = 15,
        y = 15,
        size = 20,
    },
    mobileButton = {
        fontSize = 30,
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
    transition = {
        tween = 0.25,
        spacing = 0.01
    },
    gKey = {
        height = 7,
        yOrigin = 2.6,
        icon = 'GKey',
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
    fKey = {
        height = 5,
        yOrigin = 3.5,
        line = 1,
        icon = 'FKey',
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
        height = 4,-- number of 'lines' of height
        yOrigin = 3.475,
        xOrigin = 0.5,
        image = 'note';
        padding = 0.5,
        distance = 0.1,
        fadeAway = 2
    },
    mobile = {
        vibrationTime = 0.1
    }
}

return config