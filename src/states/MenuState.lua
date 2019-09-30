
-- LIBS
local State = require('src.states.State')
local Graphics = require('src.Graphics')
local Config = require('src.Config')

-- ENTITES
local Button = require('src.objects.button')
local Title = require('src.objects.Title')
local MultiSelector = require('src.objects.MultiSelector')

---@class MenuState : State
local MenuState = State:extend()

function MenuState:new()
    MenuState.super.new(self)
end

function MenuState:init(...)
    local buttons = {
        {'Play', 'PlayState'},
        {'Score', 'ScoreState'},
        {'Options','OptionsState'},
        {'Help', 'HelpState'},
        {'Credits', 'CreditsState'},
        {'Quit', function() love.event.quit() end}
    }

    local titleText = love.graphics.newText(assets.MarckScript(40), "Menu")

    local elements = {
        {
            element = self:addentity(Title, {
                text = titleText,
                color = assets.config.color.transparent(),
                y = 0,
                x = -titleText:getWidth()
            }),
            target = {x = 30, color = assets.config.color.black()}
        }
    }

    local btnFont = assets.MarckScript(assets.config.lineHeight)
    local middle = love.graphics.getHeight() / 3
    local btn = nil
    for _,v in pairs(buttons) do
        btn, middle = self:createButton(middle, btnFont, unpack(v))
        elements[#elements+1] = {element = btn, target = {x = 30, color = assets.config.color.black()}}
    end

    local selectors = {
        {'Key', 'keySelect'},
        {'Difficulty', 'difficulty'}
    }

    local font = assets.MarckScript(assets.config.lineHeight)
    middle = love.graphics.getHeight() / 3

    for _,v in pairs(selectors) do
        local text = love.graphics.newText(font, v[1])
        local confName = v[2]
        local ent = self:addentity(MultiSelector, {
            text = text,
            x = love.graphics.getWidth(),
            y = middle,
            selected = Config[confName],
            choices = assets.config.userPreferences[confName],
            color = assets.config.color.transparent(),
            callback = function(value) Config.update(confName, value) end
        })
        elements[#elements+1] = {
            element = ent,
            target = {
                color = assets.config.color.black(),
                x = assets.config.limitLine + 20
            }
        }
        middle = middle + assets.config.lineHeight
    end


    self:transition(elements)
end

function MenuState:createButton(middle, btnFont, butonText, callback)
    local cb = callback
    if type(cb) == 'string' then
        cb = function() self:switchState(callback) end
    end
    assert(type(cb) == 'function', 'Call back must be function or string')


    local text = love.graphics.newText(btnFont, butonText)
    local btn = self:addentity(Button, {x = -text:getWidth(), y = middle, text = text, callback = cb})
    return btn, assets.config.lineHeight + middle
end


function MenuState:draw()
    love.graphics.setBackgroundColor(1,1,1)
    MenuState.super.draw(self)
    Graphics.drawMusicBars()
    love.graphics.setLineWidth(1)
    love.graphics.setColor(assets.config.color.black())
    love.graphics.line(assets.config.limitLine, 0, assets.config.limitLine, love.graphics.getHeight())
end

function MenuState:update(dt)
    MenuState.super.update(self, dt)
end

return MenuState