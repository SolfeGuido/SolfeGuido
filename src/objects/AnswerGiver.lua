
local Entity = require('src.Entity')
local Config = require('src.utils.Config')
local lume = require('lib.lume')

local MobileButton = require('src.objects.MobileButton')

---@class AnswerGiver : Entity
local AnswerGiver = Entity:extend()


function AnswerGiver:new(area, options)
    Entity.new(self, area, options)
    self:addFunction(Config.answerType)
end

function AnswerGiver:addFunction(config)
    if config == "default" then
        self:addKeyAnswers(assets.config.letterOrder)
    elseif config == "letters" then
        self:addKeyAnswers(assets.config.enNotes)
    elseif config == "buttons" then
        self:addButtons()
    end
end

function AnswerGiver:addKeyAnswers(keys)
    function self:keypressed(key)
        local idx = lume.find(keys, key)
        if idx and self.callback then
            self.callback(idx)
        end
    end
end


function AnswerGiver:addButtons()
    local size = assets.config.mobileButton.fontSize
    local font = assets.MarckScript(size)
    local letters = Config.noteStyle == "en" and assets.config.englishNotes or assets.config.romanNotes

    local padding = assets.config.mobileButton.padding
    local widths = math.floor((love.graphics.getWidth() / #letters) - padding)
    local totalSize = 0
    local elements = {}
    for i,v in ipairs(letters) do
        local text = love.graphics.newText(font, v)
        totalSize = totalSize + text:getWidth() + padding * 3
        local y = love.graphics.getHeight() - text:getHeight() - padding * 3
        elements[#elements+1] = {
            element = self.area:addentity(MobileButton, {
                x = -text:getWidth() * (#letters - i),
                y = y,
                width = widths,
                text = text,
                callback = function() if self.callback then self.callback(i) end end
            })
        }
    end
    local xTarget = 5
    for _,v in pairs(elements) do
        v.target = {x = xTarget}
        xTarget = xTarget + widths + padding
    end
    self.area:transition(elements)
end

return AnswerGiver