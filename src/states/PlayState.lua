
local Scene = require('src.states.State')
local Note = require('src.objects.note')
local Queue = require('src.utils.queue')

---@class PlayScene : Scene
---@field public entities table
---@field public timer Timer
---@field public noteImage any
---@field private notes Queue
local PlayScene = Scene:extend()

function PlayScene:new()
    PlayScene.super.new(self)
    self.gKeyImage = assets.images.GKey
    self.progress = 0
    self.progressSpeed = assets.config.maxProgressSpeed
    self.notes = Queue()
    self.notes:push(Scene.addentity(self, Note, {note = 0, x = love.graphics.getWidth() }))
end

function PlayScene:getBaseLine()
    return love.graphics.getHeight() / 3 + 5 * assets.config.lineHeight
end


---@param self PlayScene
function PlayScene:draw()
    love.graphics.push()
    love.graphics.setColor(1,1,1)
    love.graphics.rectangle('fill', 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

    local middle = love.graphics.getHeight() / 3
    love.graphics.draw(self.gKeyImage, 0, middle - 5, 0, 0.8)
    love.graphics.setColor(0.1,0.1,0.3)
    love.graphics.line(assets.config.limitLine, 0, assets.config.limitLine, love.graphics.getHeight())
    love.graphics.setColor(0,0,0)
    for i = 1,5 do
        local ypos = middle + assets.config.lineHeight * i
        love.graphics.setLineWidth(1)
        love.graphics.line(0, ypos, love.graphics.getWidth(), ypos)
    end

    PlayScene.super.draw(self)

    love.graphics.pop()

end

function PlayScene:keypressed(key)
    Scene.keypressed(self, key)
    self.notes:shift():dispose()
    print(self.notes:size())
end

function PlayScene:getMove()
    return self.progress
end

function PlayScene:doProgress(dt)
    local first = self.notes:peek().x
    local normalProg = (dt * self.progressSpeed)
    local dist = first - assets.config.limitLine
    if dist < 1  then
        self.progress = dist
    else
        self.progressSpeed = math.sqrt(dist) * 5
        self.progress = normalProg
    end
end

function PlayScene:tryPopNote(dt)
    local last = self.notes:last().x
    if love.graphics.getWidth() - last >= assets.config.noteDistance then
        local note = math.random(1,20)
        local ent = Scene.addentity(self, Note, {note = note,  x = love.graphics.getWidth()})
        self.notes:push(ent)
    end
end

function PlayScene:update(dt)
    if self.paused then return end
    Scene.update(self, dt)
    self:doProgress(dt)
    self:tryPopNote(dt)
end

return PlayScene