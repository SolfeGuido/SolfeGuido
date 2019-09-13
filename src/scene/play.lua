
local Scene = require('src.scene')
local Draft = require('lib.draft')
local Note = require('src.objects.note')

---@class PlayScene : Scene
---@field public entities table
---@field public timer Timer
---@field public noteImage any
local PlayScene = Scene:extend()

---@param self PlayScene
function PlayScene:new()
    PlayScene.super.new(self)
    self.noteImage = love.graphics.newImage('res/note.png')
    self.gKeyImage = love.graphics.newImage('res/sol.png')
    self.fKeyImage = love.graphics.newImage('res/fa.png')
    assert(self.noteImage, 'Failed to load image')
    Scene.addentity(self, Note, 1, self.noteImage)
    self.progress = 0
    self.limitLine = 200
end


---@param self PlayScene
function PlayScene:draw()
    love.graphics.push()
    love.graphics.setColor(1,1,1)
    love.graphics.rectangle('fill', 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

    local middle = love.graphics.getHeight() / 3
    love.graphics.draw(self.gKeyImage, 0, middle - 5, 0, 0.8)
    love.graphics.setColor(0.1,0.1,0.3)
    love.graphics.line(self.limitLine , 0, self.limitLine, love.graphics.getHeight())
    love.graphics.setColor(0,0,0)
    for i = 1,5 do
        local ypos = middle + 20 * i
        love.graphics.setLineWidth(1)
        love.graphics.line(0, ypos, love.graphics.getWidth(), ypos)
    end

    love.graphics.push()
    love.graphics.translate(-self.progress, 0)
    PlayScene.super.draw(self)
    love.graphics.pop()

    love.graphics.pop()

end

function PlayScene:update(dt)
    Scene.update(self, dt)
    self.progress = self.progress + (dt *  50)
    -- if math.random() == 1 then
    --     self.notes[#self.notes+1] = Note(self, 20, 100)
    -- end
end

return PlayScene