
--- LIBS
local State = require('src.State')
local Graphics = require('src.utils.Graphics')
local Config = require('src.utils.Config')

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
                fontSize = 40,
                y = 0,
                x = 5
            },{
                text = 'Key',
                type = 'MultiSelector',
                config = 'keySelect'
            }, {
                text = 'Sound',
                type = 'MultiSelector',
                config = 'sound'
            }, {
                text = 'Difficulty',
                type = 'MultiSelector',
                config = 'difficulty'
            }, {type = 'Space'}, {
                text = 'Back',
                type = 'Button',
                callback = function() self:back() end
            }
        },
        {
            {
                text = 'Notes',
                type = 'MultiSelector',
                config = 'noteStyle'
            },
            {
                text = 'Language',
                type = 'MultiSelector',
                config = 'lang'
            },
            {
                text = 'Answer',
                type = 'MultiSelector',
                config = 'answerType',
                mobile = false
            }
        }
    })
end

function OptionsState:back()
    Config.save()
    self:switchState('MenuState')
end

return OptionsState