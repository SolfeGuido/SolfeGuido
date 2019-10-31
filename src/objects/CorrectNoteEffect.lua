local Entity = require('src.Entity')
local Color = require('src.utils.Color')

---@class CorrectNoteEffect : Entity
local CorrectNoteEffect = Entity:extend()

function CorrectNoteEffect:new(area, options)
    Entity.new(self, area, options)
    self.timer:tween(assets.config.note.fadeAway / 2, self, {
        color = Color.transparent,
        scale = 2.5
    }, 'linear', function()
        self.isDead = true
        self.target = nil
    end)
end

function CorrectNoteEffect:draw()
    love.graphics.setColor(self.color)
    love.graphics.draw(self.image,
        self.target.x + self.xOrigin + self.padding, self.target.y,
        self.rotation, self.scale, self.scale, self.xOrigin, self.yOrigin)
end


return CorrectNoteEffect