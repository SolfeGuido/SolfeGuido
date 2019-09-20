
local Scene = require('src.states.State')
local Note = require('src.objects.note')
local Queue = require('src.utils.queue')
local GKey = require('src.objects.gkey')
local FKey = require('src.objects.fkey')
local StopWatch = require('src.objects.stopwatch')

---@class PlayState : Scene
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
    self.notes:push(Scene.addentity(self, Note, {note = math.random(1, 20), x = love.graphics.getWidth() }))
    self.key = self:addentity(GKey, {})
    self.stopWatch = self:addentity(StopWatch, {x = 15, y = 15, size = 20, finishCallback = function()
        self:finish()
    end})
    self.points = 0
end

---@return number
function PlayState:getBaseLine()
    return love.graphics.getHeight() / 3 + 5 * assets.config.lineHeight
end

function PlayState:finish()
    while not self.notes:isEmpty() do
        self.notes:shift():dispose()
    end 
end

function PlayState:draw()
    love.graphics.push()

    love.graphics.setColor(1,1,1)
    love.graphics.rectangle('fill', 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

    local width = Note.width()
    if not self.notes:isEmpty() then
        local x = self.notes:peek().x
        love.graphics.setColor(unpack(assets.config.note.backgroundColor))
        love.graphics.rectangle('fill', x, 0, width, love.graphics.getHeight())
    end

    local middle = love.graphics.getHeight() / 3
    love.graphics.setColor(0.1,0.1,0.3)
    love.graphics.line(assets.config.limitLine, 0, assets.config.limitLine, love.graphics.getHeight())
    love.graphics.setColor(0,0,0)
    love.graphics.print(tostring(self.points) , 50, 10)
    for i = 1,5 do
        local ypos = middle + assets.config.lineHeight * i
        love.graphics.setLineWidth(1)
        love.graphics.line(0, ypos, love.graphics.getWidth(), ypos)
    end

    PlayState.super.draw(self)
    love.graphics.pop()

end

---@param key string
function PlayState:keypressed(key)
    Scene.keypressed(self, key)
    if self.notes:isEmpty() then return end
    local currentNote = self.notes:peek()
    if self.key:isCorrect(currentNote.note, key) then
        self.notes:shift():correct()
        self.points = self.points + 1
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
    if self.paused then return end
    Scene.update(self, dt)
    if self.notes:isEmpty() then return end
    self:doProgress(dt)
    self:tryPopNote(dt)
end

return PlayState