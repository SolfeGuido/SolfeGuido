
return {
    {
        title = '30s Finisher',
        icon = 'Flag',
        text = 'Finish a 30s game',
        target = {
            time = '30s'
        }
    },
    {
        title = '1mn finisher',
        icon = 'Flag',
        text = 'Finish a 1mn game',
        target = {
            time = '1mn'
        }
    },
    {
        title = '2mn finisher',
        icon = 'Flag',
        text = 'Finish a 2mn game',
        target = {
            time = '2mn'
        }
    },
    {
        title = '5mn finisher',
        icon = 'Flag',
        text = 'Finish a 5mn game',
        target = {
            time = '5mn'
        }
    },
    {
        title = '30s perfect',
        icon = 'Target',
        text = 'Finish a 30s game without errors',
        target = {
            time = '30s',
            wrontNotes = 0,
            correctNotes = { 'GT', 1}
        }
    },
    {
        title = '10 or nothing',
        icon = 'FullStar',
        text = 'Score 10 points in a 30 seconds game',
        target = {
            time = '30s',
            correctNotes = {'GEQ', 10}
        }
    },
    {
        title = 'Small points',
        icon = 'Clock',
        text = 'Score a total of 100 points',
        target = {
            totalCorrectNotes = {'GEQ', 100}
        }
    }
}