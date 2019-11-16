
-- LIBS
local State = require('src.State')
local UIFactory = require('src.utils.UIFactory')
local Graphics = require('src.utils.Graphics')
local Theme = require('src.utils.Theme')

---@class MenuState : State
local MenuState = State:extend()

function MenuState:new()
    MenuState.super.new(self)
end

function MenuState:draw()
    Graphics.drawMusicBars()
    MenuState.super.draw(self)
end

function MenuState:init(...)
    self:transition({
        {
            element = UIFactory.createIconButton(self, {
                x = 5,
                color = Theme.transparent:clone(),
                y = love.graphics.getHeight(),
                height = Vars.titleSize,
                icon = assets.IconName.Off,
                callback = function() love.event.quit() end
            }),
            target = {color = Theme.font, y = love.graphics.getHeight() - Vars.titleSize - 5}
        }
    })
end

return MenuState