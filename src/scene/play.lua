
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
    assert(self.noteImage, 'Failed to load image')
    Scene.addentity(self, Note, 20, 100, self.noteImage)
end


---@param self PlayScene
function PlayScene:draw()
    love.graphics.push()
    love.graphics.setColor(1,1,1)
    love.graphics.rectangle('fill', 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

    love.graphics.setPointSize(100)
    local middle = love.graphics.getHeight() / 3
    love.graphics.setColor(0,0,0)
    for i = 1,5 do
        local ypos = middle + 20 * i
        love.graphics.setLineWidth(1)
        love.graphics.line(0, ypos, love.graphics.getWidth(), ypos)
    end

    love.graphics.pop()

    PlayScene.super.draw(self)
end

function PlayScene:update(dt)
    Scene.update(self, dt)

    -- if math.random() == 1 then
    --     self.notes[#self.notes+1] = Note(self, 20, 100)
    -- end
end

return PlayScene