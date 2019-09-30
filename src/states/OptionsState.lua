
--- LIBS
local State = require('src.states.State')
local Graphics = require('src.Graphics')
local Config = require('src.Config')

--- ENTITIES
local Title =  require('src.objects.Title')
local MultiSelector = require('src.objects.MultiSelector')
local Button = require('src.objects.button')

---@class OptionsState : State
local OptionsState = State:extend()


function OptionsState:new()
    State.new(self)
end

function OptionsState:draw()
    State.draw(self)
    Graphics.drawMusicBars()
end

function OptionsState:init(...)
    self:createUI({
        {
            {
                text = 'Options',
                type = 'Title',
                fontSize = 40,
                y = 0
            },{
                text = 'Key',
                type = 'MultiSelector',
                config = 'keySelect'
            },{
                text = 'Notes',
                type = 'MultiSelector',
                config = 'noteStyle'
            }, {
                text = 'Sound',
                type = 'MultiSelector',
                config = 'sound'
            }, {
                text = 'Language',
                type = 'MultiSelector',
                config = 'lang'
            },  {
                text = 'Difficulty',
                type = 'MultiSelector',
                config = 'difficulty'
            }, {
                text = 'Back',
                type = 'Button',
                callback = function() self:back() end
            }
        }
    })
end

function OptionsState:update(dt)
    State.update(self, dt)
end

function OptionsState:keypressed(key)
    if key == 'escape' then
        self:back()
        return
    end
end

function OptionsState:back()
    Config.save()
    self:switchState('MenuState')
end

return OptionsState