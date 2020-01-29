local Entity = require('src.Entity')
local Theme = require('src.utils.Theme')

---@class CorrectNoteEffect : Entity
local CorrectNoteEffect = Entity:extend()

function CorrectNoteEffect:new(container, options)
    Entity.new(self, container, options)
    self.timer:tween(Vars.note.fadeAway, self, {
        color = Theme.transparent,
        scale = 2.5
    }, 'linear', function()
        self.isDead = true
        self.target = nil
    end)
end

function CorrectNoteEffect:draw()
    love.graphics.setShader(assets.shaders.noteFade)
    love.graphics.setColor(self.color)
    love.graphics.draw(self.image,
        self.target.x + self.xOrigin + self.padding, self.target.y,
        self.rotation, self.scale, self.scale, self.xOrigin, self.yOrigin)
    love.graphics.setShader()
end


return CorrectNoteEffect