
-- LIBS
local ScreenManager = require('lib.ScreenManager')
local Config = require('src.data.Config')
local ScoreManager = require('src.data.ScoreManager')
local StatisticsManager = require('src.data.StatisticsManager')
local Theme = require('src.utils.Theme')
local Mobile = require('src.utils.Mobile')
local IconButton = require('src.objects.IconButton')

-- Parent
local Scene = require('src.State')

-- Entities
local GameStatistics = require('src.objects.GameStatistics')

local AnswerGiver = require('src.objects.AnswerGiver')

--- Main class of the project, when the user plays
--- he's on this state, the user can pause the game
--- at any moment, or give the answers to the current
--- hightlited note
---@class PlayState : State
---@field public entities table
---@field public timer Timer
---@field public noteImage any
---@field private notes CircularQueue
---@field private stopWatch StopWatch
---@field private points number
local PlayState = Scene:extend()

--- Constructor
function PlayState:new()
    PlayState.super.new(self)

    self.progress = 0
    self.progressSpeed = Vars.maxProgressSpeed
    self.currentMeasure = 1
    self.nextMeasureGeneration = 1
    self.barColor = Theme.stripe:clone()
end

--- Creates the widgets, or configures them if already created
--- the majority of the widgets used by the state should have
--- been created by the GamePrepareState, so that nothing has
--- to be constructed in this state
---@param config table
function PlayState:init(config)
    self.score = self:insertEntity(config.score)
    self.measures = config.measures

    for _,v in ipairs(self.measures) do self:insertEntity(v) end

    local elements = {{element = self.score, target = {x = Vars.score.x, color = Theme.font}}}

    if config.stopWatch then
        self.stopWatch = self:insertEntity(config.stopWatch)
        self.stopWatch.finishCallback = function() self:finish() end
        elements[#elements + 1] = {element = self.stopWatch, target = {color = Theme.secondary}}
    end

    self:addHUD(IconButton, {
        icon = assets.IconName['Pause'],
        x = love.graphics.getWidth() - Vars.mobileButton.fontSize * 1.5 - 10,
        y = 0,
        padding = 5,
        size = Vars.mobileButton.fontSize * 1.5,
        callback = function(btn)
            btn.consumed = false
            ScreenManager.push('PauseState')
        end
    })

    self.answerGiver = self:addEntity(AnswerGiver, {callback = function(x) self:answerGiven(x) end })
    self.stats = self:addEntity(GameStatistics)

    self.finished = false
    self:transition(elements, function()
        if self.stopWatch then self.stopWatch:start() end
        self.stats:start()
    end)
end

--- Access to the measure where the
--- current note is highlited
---@return Measure
function PlayState:getMeasure()
    return self.measures[self.currentMeasure]
end

--- When several measure play at the same time
--- changes the current selected measure
function PlayState:switchMeasure()
    if #self.measures == 1 then return end
    self.currentMeasure = 3 - self.currentMeasure
end

--- When the time ran out, fade aways
--- all the notes, and shows the EndGameState
function PlayState:finish()
    self.answerGiver:hide()
    self.stats:stop()
    StatisticsManager.add(self.stats)
    StatisticsManager.save()
    self.finished = true
    for _,v in ipairs(self.measures) do
        v:fadeAwayNotes()
    end
    self.timer:after(Vars.note.fadeAway, function()
        local bestScore = ScoreManager.update(Config.keySelect, Config.difficulty, Config.time, self.score.points)
        ScreenManager.push('EndGameState', self.score.points, bestScore)
    end)
end

--- Inherited method
function PlayState:draw()
    love.graphics.push()

    if self.currentNote then
        local note = self.currentNote
        self.barColor[4] = note.color[4] * Theme.stripe[4]
        love.graphics.setShader(assets.shaders.noteFade)
        love.graphics.setColor(self.barColor)
        love.graphics.rectangle('fill', note.x, self:getMeasure().y , note.width, self:getMeasure().height)
        love.graphics.setShader()
    end

    PlayState.super.draw(self)
    love.graphics.pop()

end

--- Capture the escape event to pause the game
---@param key string
function PlayState:keypressed(key)
    Scene.keypressed(self, key)
    if key == "escape" then
        ScreenManager.push('PauseState')
        return
    end
end

--- Pause the game when the window looses focus
---@param focus boolean
function PlayState:focus(focus)
    if self.active and not focus then
        ScreenManager.push('PauseState')
    end
end

--- Checks that the answer given is correct
--- If it is, shows the positive animation, win a point and so on
--- otherwise, show the note name, and loose time
---@param idx string
function PlayState:answerGiven(idx)
    if not self.currentNote then return end
    local measure = self:getMeasure()
    -- Playing same note whatever happens, need to find something else to do when wrong
    assets.sounds.notes[self.currentNote.note]:play()
    local timeLost = 0
    if measure:isAnswerCorrect(idx) then
        self.stats:correct()
        self.currentNote:correct()
        self.score:gainPoint()
    else
        self.stats:wrong()
        self.currentNote:wrong()
        Mobile.vibrate(Vars.mobile.vibrationTime)
        timeLost = Vars.timeLoss
    end
    measure:removeNextNote()
    self:switchMeasure()
    self.currentNote = self:getMeasure():currentNote()
    -- Loose time later, so that the callback (if called), the playstate is in a correct state
    if timeLost > 0 and self.stopWatch then
        self.stopWatch:looseTime(timeLost)
    end
end

--- Access to the note progression
---@return number
function PlayState:getMove()
    return self.progress
end

---Calculates the notes progression
---@param dt number
function PlayState:doProgress(dt)
    local first = self.currentNote.x
    local normalProg = (dt * self.progressSpeed)
    local dist = first - self:getMeasure().limitLine
    if dist < 1  then
        self.progress = dist
    else
        self.progressSpeed = math.sqrt(dist*3) * 10
        self.progress = normalProg
    end
end

--- Adds a note to the next measure
--- and returns it
---@return Note
function PlayState:addNote()
    local note = self.measures[self.nextMeasureGeneration]:generateRandomNote()
    if #self.measures == 2 then
        self.nextMeasureGeneration = 3 - self.nextMeasureGeneration
    end
    return note
end

--- Pops a note if needed
function PlayState:tryPopNote(_)
    if self.finished then return end
    if not self.currentNote then
        self.currentNote = self:addNote()
        self.lastNote = self.currentNote
    else
        local last = self.lastNote
        if not last or love.graphics.getWidth() - last.x > last.width * Vars.note.distance then
            self.lastNote = self:addNote()
        end
    end
end

--- Updates this state
---@param dt number
function PlayState:update(dt)
    if not self.active then return end
    Scene.update(self, dt)
    self:tryPopNote(dt)
    if self.currentNote then
        if self.currentNote.isDead then
            -- happens at the end of a game
            self.currentNote = nil
        else
            self:doProgress(dt)
        end
    end
end

--- Goodbye playstate
function PlayState:close()
    self.currentNote = nil
    self.lastNote = nil
    self.measures = nil
    self.stopWatch = nil
    self.answerGiver = nil
    Scene.close(self)
end

return PlayState