
-- LIBS
local ScreenManager = require('lib.ScreenManager')
local Graphics = require('src.utils.Graphics')
local Config = require('src.utils.Config')
local ScoreManager = require('src.utils.ScoreManager')

-- Parent
local Scene = require('src.State')

-- Entities
local Key = require('src.objects.Key')
local Note = require('src.objects.Note')
local Queue = require('src.utils.Queue')
local StopWatch = require('src.objects.Stopwatch')
local Score = require('src.objects.Score')


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
    self.progressSpeed = assets.config.maxProgressSpeed
    self.notes = Queue()
    self.key = self:addentity(Key, {}, Config.keySelect == 'gKey' and assets.config.gKey or assets.config.fKey)
    self.stopWatch = self:addentity(StopWatch, {
        x = -assets.config.stopWatch.size,
        y = assets.config.stopWatch.y, size = assets.config.stopWatch.size,
        started = false,
        finishCallback = function()
            self:finish()
        end})

    local scoreText = love.graphics.newText(assets.MarckScript(assets.config.score.fontSize),"0")
    self.score = self:addentity(Score, {
        x = -scoreText:getWidth(),
        y = assets.config.score.y,
        points = 0,
        text =  scoreText,
        color = assets.config.color.transparent()
    })
end

function PlayState:init(...)
    local elements = {
        {element = self.stopWatch, target = {x = assets.config.stopWatch.x, color = {}}},
        {element = self.key, target = {x = self.key.keyData.x, color = assets.config.color.black()}},
        {element = self.score, target = {x = assets.config.score.x, color = assets.config.color.black()}}
    }

    self.finished = false
    self:transition(elements, function()
        self.stopWatch:start()
    end)
end

function PlayState:close()
    Scene.close(self)
    self.notes = nil
end

---@return number
function PlayState:getBaseLine()
    return love.graphics.getHeight() / 3 + 5 * assets.config.lineHeight
end

function PlayState:finish()
    self.finished = true
    while not self.notes:isEmpty() do
        self.notes:shift():fadeAway()
    end
    self.timer:after(assets.config.note.fadeAway, function()
        ScoreManager.update(Config.keySelect, Config.difficulty, self.score.points)
        ScreenManager.push('EndGameState', self.score.points)
    end)
end

function PlayState:draw()
    love.graphics.push()

    love.graphics.setBackgroundColor(1,1,1)

    local width = Note.width()
    if not self.notes:isEmpty() then
        local x = self.notes:peek().x
        love.graphics.setColor(unpack(assets.config.note.backgroundColor))
        love.graphics.rectangle('fill', x, 0, width, love.graphics.getHeight())
    end

    Graphics.drawMusicBars()

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

    if self.notes:isEmpty() then return end
    local currentNote = self.notes:peek()
    TEsound.play(self.key:getSoundFor(currentNote.note))
    if self.key:isCorrect(currentNote.note, key) then
        self.notes:shift():correct()
        self.score:gainPoint()
    else
        self.notes:shift():wrong()
        self.stopWatch:update(assets.config.timeLoss)
    end
end

function PlayState:getMove()
    return self.progress
end

---Calculate the notes progression
---@param dt number
function PlayState:doProgress(dt)
    local first = self.notes:peek().x
    local normalProg = (dt * self.progressSpeed)
    local dist = first - assets.config.limitLine
    if dist < 1  then
        self.progress = dist
    else
        self.progressSpeed = math.sqrt(dist) * 10
        self.progress = normalProg
    end
end

function PlayState:addNote()
    local note = self.key:getRandomNote()
    local ent = Scene.addentity(self, Note, {note = note,  x = love.graphics.getWidth()})
    self.notes:push(ent)
end

--- Pops a note if needed
---@param dt number
function PlayState:tryPopNote(dt)
    if self.finished then return end
    if self.notes:isEmpty() then
        self:addNote()
    else
        local last = self.notes:last().x
        if love.graphics.getWidth() - last >= assets.config.note.distance then
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