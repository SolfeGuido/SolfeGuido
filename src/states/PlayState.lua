
-- LIBS
local ScreenManager = require('lib.ScreenManager')
local Config = require('src.utils.Config')
local ScoreManager = require('src.utils.ScoreManager')
local Theme = require('src.utils.Theme')
local Mobile = require('src.utils.Mobile')

-- Parent
local Scene = require('src.State')

-- Entities
local Measure = require('src.objects.Measure')
local Note = require('src.objects.Note')
local Queue = require('src.utils.Queue')
local StopWatch = require('src.objects.Stopwatch')
local Score = require('src.objects.Score')
local AnswerGiver = require('src.objects.AnswerGiver')


---@class PlayState : State
---@field public entities table
---@field public timer Timer
---@field public noteImage any
---@field private notes Queue
---@field private stopWatch StopWatch
---@field private points number
local PlayState = Scene:extend()

function PlayState:new()
    PlayState.super.new(self)
    self.progress = 0
    self.progressSpeed = Vars.maxProgressSpeed
    self.notes = Queue()
    self.currentMeasure = 1
    self.nextMeasureGeneration = 1
end


function PlayState:init(config)
    self.score = self:insertEntity(config.score)
    self.measures = config.measures

    for _,v in ipairs(self.measures) do self:insertEntity(v) end

    local elements = {{element = self.score, target = {x = Vars.score.x, color = Theme.font}}}

    if config.stopWatch then
        self.stopWatch = self:insertEntity(config.stopWatch)
        self.stopWatch.finishCallback = function() self:finish() end
        elements[#elements + 1] = {element = self.stopWatch, target = {x = Vars.stopWatch.x}}
    end

    self.answerGiver = self:addentity(AnswerGiver, { callback = function(x) self:answerGiven(x) end })

    self.finished = false
    self:transition(elements, function()
        if self.stopWatch then self.stopWatch:start() end
    end)
end

function PlayState:getMeasure()
    return self.measures[self.currentMeasure]
end

function PlayState:switchMeasure()
    if #self.measures == 1 then return end
    self.currentMeasure = 3 - self.currentMeasure
end

function PlayState:close()
    self.notes = nil
    self.measures = nil
    self.stopWatch = nil
    self.answerGiver = nil
    Scene.close(self)
end


function PlayState:finish()
    self.answerGiver:hide()
    self.finished = true
    while not self.notes:isEmpty() do
        self.notes:shift():fadeAway()
    end
    self.timer:after(Vars.note.fadeAway, function()
        local bestScore = ScoreManager.update(Config.keySelect, Config.difficulty, Config.time, self.score.points)
        ScreenManager.push('EndGameState', self.score.points, bestScore)
    end)
end

function PlayState:draw()
    love.graphics.push()

    if not self.notes:isEmpty() then
        local note = self.notes:peek()
        love.graphics.setColor(Theme.stripe)
        love.graphics.rectangle('fill', note.x, self:getMeasure().y , note.width, self:getMeasure().height)
    end

    PlayState.super.draw(self)
    love.graphics.pop()

end

---@param key string
function PlayState:keypressed(key)
    Scene.keypressed(self, key)
    if key == "escape" then
        ScreenManager.push('PauseState')
        return
    end
end


function PlayState:answerGiven(idx)
    if self.notes:isEmpty() then return end
    local measure = self:getMeasure()
    local currentNote = self.notes:peek()
    print(currentNote.note, assets.sounds.notes[currentNote.note])
    TEsound.play(assets.sounds.notes[currentNote.note], nil, 1.0, 1)
    if measure:isCorrect(currentNote.note, idx) then
        self.notes:shift():correct()
        self.score:gainPoint()
    else
        self.notes:shift():wrong()
        Mobile.vibrate(Vars.mobile.vibrationTime)
        if self.stopWatch then
            self.stopWatch:looseTime(Vars.timeLoss)
        end
    end
    self:switchMeasure()
end

function PlayState:getMove()
    return self.progress
end

---Calculate the notes progression
---@param dt number
function PlayState:doProgress(dt)
    local first = self.notes:peek().x
    local normalProg = (dt * self.progressSpeed)
    local dist = first - self:getMeasure().limitLine
    if dist < 1  then
        self.progress = dist
    else
        self.progressSpeed = math.sqrt(dist) * 10
        self.progress = normalProg
    end
end

function PlayState:addNote()
    local note = self.measures[self.nextMeasureGeneration]:getRandomNote()
    local ent = Scene.addentity(self, Note, {
        note = note,
        x = love.graphics.getWidth(),
        measure = self.measures[self.nextMeasureGeneration]
    })
    self.notes:push(ent)
    if #self.measures == 2 then
        self.nextMeasureGeneration = 3 - self.nextMeasureGeneration
    end
end

--- Pops a note if needed
function PlayState:tryPopNote(_)
    if self.finished then return end
    if self.notes:isEmpty() then
        self:addNote()
    else
        local last = self.notes:last()
        if love.graphics.getWidth() - last.x > last.width * 1.1 then
            self:addNote()
        end
    end
end

--- Updates this state
---@param dt number
function PlayState:update(dt)
    if not self.active then return end
    Scene.update(self, dt)
    self:tryPopNote(dt)
    if self.notes:isEmpty() then return end
    self:doProgress(dt)
end

return PlayState