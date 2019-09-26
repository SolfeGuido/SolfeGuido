
local State = require('src.states.State')
local ScreenManager = require('lib.ScreenManager')

-- Entities
local Button = require('src.objects.button')

---@class PauseState : State
local PauseState = State:extend()


function PauseState:new()
    State.new(self)
end

function PauseState:init(...)
    self.color = {1, 1, 1, 0}
    self.timer:tween(0.2, self, {color = {1, 1, 1, 0.8}}, 'linear', function()
        self:addButtons()
    end)
end

function PauseState:addButtons()
    local buttons = {
        {'Resume', function() self:popBack() end},
        {'Exit', function()
            --smooth transition to menu ???
            ScreenManager.switch('MenuState')
        end}
    }

    local elements = {}

    local middle = love.graphics.getHeight() / 3
    local font = assets.MarckScript(assets.config.lineHeight)

    for _,v in pairs(buttons) do
        local text = love.graphics.newText(font, v[1])
        elements[#elements+1] = {
            element = self:addentity(Button, {
                x = -text:getWidth(),
                y = middle,
                text = text,
                callback = v[2],
                color = assets.config.color.transparent
            }),
            target = {
                x = assets.config.limitLine - text:getWidth() - 10,
                color = assets.config.color.black
            }
        }
        middle = middle + assets.config.lineHeight
    end

    self:transition(elements)
end

function PauseState:draw()
    love.graphics.setColor(self.color)
    love.graphics.rectangle('fill', 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    State.draw(self)
end

function PauseState:update(dt)
    State.update(self, dt)
end

function PauseState:popBack()
    self:slideEntitiesOut()
    self.timer:tween(assets.config.transition.tween, self, {color = {1, 1, 1, 0}}, 'linear', function()
        ScreenManager.pop()
    end)
end

function PauseState:keypressed(key)
    if key == "escape" then
        self:popBack()
    end
end


return PauseState