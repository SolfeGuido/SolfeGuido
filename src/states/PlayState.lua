
-- LIBS
local ScreenManager = require('lib.ScreenManager')
local Graphics = require('src.Graphics')

-- Parent
local Scene = require('src.states.State')

-- Entities
local Note = require('src.objects.note')
local Queue = require('src.utils.queue')
local GKey = require('src.objects.gkey')
local FKey = require('src.objects.fkey')
local StopWatch = require('src.objects.stopwatch')
local Line = require('src.objects.Line')
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
    self.key = self:addentity(GKey, {})
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
        color = assets.config.color.transparent
    })
end

function PlayState:init(...)
    local line = self:addentity(Line, {
            x = -1,
            y = 0,
            height = love.graphics.getHeight(),
            color = assets.config.color.transparent,
            lineWidth = 0
    })
    local elements = {
        {element = self.stopWatch, target = {x = assets.config.stopWatch.x, color = {}}},
        {element = self.key, target = {x = self.key.keyData.x, color = assets.config.color.black}},
        {element = line, target = {x = assets.config.limitLine, color = assets.config.color.black, lineWidth = 1}},
        {element = self.score, target = {x = assets.config.score.x, color = assets.config.color.black}}
    }

    self:transition(elements, function()
        self.notes:push(Scene.addentity(self, Note, {note = math.random(1, 20), x = love.graphics.getWidth() }))
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
    while not self.notes:isEmpty() do
        self.notes:shift():dispose()
    end
    -- Push EndState
    --love.window.showMessageBox("Finished", "Your score : " .. tostring(self.points))
    -- go to menu
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

--- Pops a note if needed
---@param dt number
function PlayState:tryPopNote(dt)
    local last = self.notes:last().x
    if love.graphics.getWidth() - last >= assets.config.note.distance then
        local note = math.random(1,20)
        local ent = Scene.addentity(self, Note, {note = note,  x = love.graphics.getWidth()})
        self.notes:push(ent)
    end
end

--- Updates this state
---@param dt number
function PlayState:update(dt)
    if not self.active then return end
    Scene.update(self, dt)
    if self.notes:isEmpty() then return end
    self:doProgress(dt)
    self:tryPopNote(dt)
end

return PlayState