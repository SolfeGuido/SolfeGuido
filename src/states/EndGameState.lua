
-- LIBS
local State = require('src.states.State')
local ScreenManager = require('lib.ScreenManager')

--- Entities
local Title = require('src.objects.Title')
local Button = require('src.objects.button')

---@class EndGameState : State
local EndGameState = State:extend()


function EndGameState:new()
    State.new(self)
end

function EndGameState:init(score)
    self.color = {1, 1, 1, 0}
    self.timer:tween(0.2, self, {color = {1, 1, 1, 0.8}}, 'linear', function() self:addButtons(score) end)
end

function EndGameState:addButtons(score)
    local buttons = {
        {'Restart', function()
            ScreenManager.switch('PlayState')
        end},
        {'Menu', function()
            --smooth transition to menu ???
            ScreenManager.switch('MenuState')
        end}
    }

    local titleText = love.graphics.newText(assets.MarckScript(40), "Finished")
    local scoreText = love.graphics.newText(assets.MarckScript(assets.config.lineHeight), "Score : " .. tostring(score))

    local middle = love.graphics.getHeight() / 3


    local elements = {
        {
            element = self:addentity(Title, {
                text = titleText,
                color = assets.config.color.transparent(),
                y = 0,
                x = -titleText:getWidth()
            }),
            target = {x = 5, color = assets.config.color.black()}
        },
        {
            element = self:addentity(Title, {
                text = scoreText,
                y = middle,
                x = -scoreText:getWidth(),
                color = assets.config.color.transparent()
            }),
            target = {
                x = assets.config.limitLine - scoreText:getWidth() - 10,
                color = assets.config.color.black()
            }
        }
    }

    middle = middle + assets.config.lineHeight
    local font = assets.MarckScript(assets.config.lineHeight)

    for _,v in pairs(buttons) do
        local text = love.graphics.newText(font, v[1])
        elements[#elements+1] = {
            element = self:addentity(Button, {
                x = -text:getWidth(),
                y = middle,
                text = text,
                callback = v[2],
                color = assets.config.color.transparent()
            }),
            target = {
                x = assets.config.limitLine - text:getWidth() - 10,
                color = assets.config.color.black()
            }
        }
        middle = middle + assets.config.lineHeight
    end

    self:transition(elements)
end

function EndGameState:draw()
    love.graphics.setColor(self.color)
    love.graphics.rectangle('fill', 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

    State.draw(self)
end

function EndGameState:update(dt)
    State.update(self, dt)
end

function EndGameState:popBack()
    --Smooth transition to menu ?
end

function EndGameState:restart()

end

return EndGameState