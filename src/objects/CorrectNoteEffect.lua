local Entity = require('src.Entity')
local Theme = require('src.utils.Theme')

---@class CorrectNoteEffect : Entity
--- Simple effect that pops on the screen
--- when the user chooses the correct answer
--- this effect is the note scaling up
--- and fading away at the same time
local CorrectNoteEffect = Entity:extend()

--- Constructor
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

--- Inherited method
function CorrectNoteEffect:draw()
    love.graphics.setColor(self.color)
    love.graphics.draw(self.image,
        self.target.x + self.xOrigin + self.padding, self.target.y,
        self.rotation, self.scale, self.scale, self.xOrigin, self.yOrigin)
end


return CorrectNoteEffect