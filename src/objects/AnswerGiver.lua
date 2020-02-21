
local EntityContainer = require('src.objects.EntityContainer')
local Config = require('src.data.Config')
local PianoKey = require('src.objects.PianoKey')
local Theme = require('src.utils.Theme')

local MobileButton = require('src.objects.MobileButton')

---@class AnswerGiver : EntityContainer
--- class used by the game, to create the correct buttons
--- depending on the user's configuration
--- can create piano keys (with or without notes name)
--- or simple buttons with the note name on it
--- And depending on the user's configuration, note name
--- can be 'a,b,c' or 'do,ré,mi', ...
--- The answer giver only needs a callback function
--- to call whenever one button is pressed,
--- indicating that an answer has been given
local AnswerGiver = EntityContainer:extend()

---constructor
function AnswerGiver:new(container, options)
    EntityContainer.new(self, container, options)
    self:addFunction(Config.answerType)
end

--- Hides all the buttons contained by
--- this answergiver
function AnswerGiver:hide()
    for _, button in ipairs(self._entities) do
        self.timer:tween(Vars.transition.tween, button, {y = love.graphics.getHeight() + 20}, 'out-expo')
    end
end

--- Adds the right buttons
--- based on the given configuration
--- can be one of "piano", "pianoWithNotes" or "buttons"
---@param config string
function AnswerGiver:addFunction(config)
    if config == "piano" then
        self:addPianoKeys(false)
    elseif config == "pianoWithNotes" then
        self:addPianoKeys(true)
    elseif config == "buttons" then
        self:addButtons()
    end
end


--- Creates the piano keys, also add the black keys, but these
--- are not used for now
---@param showNote boolean if the piano should have note name on it
function AnswerGiver:addPianoKeys(showNote)
    local totalWidth = love.graphics.getWidth()
    local whiteKeyWidth = totalWidth / 7
    local height = Vars.pianoHeight
    local yPos = love.graphics.getHeight() - height

    local font = assets.fonts.Oswald(Vars.mobileButton.fontSize)
    for i = 1, 7 do
        self:addEntity(PianoKey, {
            x = (i-1) * whiteKeyWidth,
            y = yPos,
            height = height,
            width = whiteKeyWidth,
            callback = function(btn)
                btn.consumed = false
                if self.callback then self.callback( Vars.englishNotes[i]) end
            end,
            text = showNote and love.graphics.newText(font,Vars[Config.noteStyle][i]) or nil
        })
    end
    local blackKeys = {
        3 *whiteKeyWidth / 4,
        7 * whiteKeyWidth / 4,
        15 * whiteKeyWidth / 4,
        19 * whiteKeyWidth / 4,
        23 * whiteKeyWidth / 4
    }
    for _,v in ipairs(blackKeys) do
        self:addEntity(PianoKey, {
            x = v,
            y = yPos,
            height = 3 * height / 4,
            width = whiteKeyWidth / 2,
            backgroundColor = Theme.font:clone()
        })
    end
end

--- Adds the simple buttons
function AnswerGiver:addButtons()
    local size = Vars.mobileButton.fontSize
    local font = assets.fonts.Oswald(size)
    local letters = Vars[Config.noteStyle]

    local padding = Vars.mobileButton.padding
    local widths = math.floor((love.graphics.getWidth() / #letters) - padding)
    local totalSize = 0
    for i,v in ipairs(letters) do
        local text = love.graphics.newText(font, v)
        totalSize = totalSize + text:getWidth() + padding * 3
        local y = love.graphics.getHeight() - text:getHeight() - padding * 3
        self:addEntity(MobileButton, {
            x = 5 + (widths + padding) * (i-1),
            y = y,
            width = widths,
            text = text,
            callback = function() if self.callback then self.callback( Vars.englishNotes[i]) end end
        })
    end
end

return AnswerGiver