
-- LIBS
local State = require('src.State')
local Graphics = require('src.utils.Graphics')
local Theme = require('src.utils.Theme')
local ScreenManager = require('lib.ScreenManager')

---@class MenuState : State
local MenuState = State:extend()

function MenuState:new()
    MenuState.super.new(self)
end

function MenuState:draw()
    Graphics.drawMusicBars()
    MenuState.super.draw(self)
end

function MenuState:update(dt)
    State.update(self, dt)
end

function MenuState:keypressed(key)
    if self:isActive() then
        if key == "escape" then
            return love.event.quit()
        elseif key == "menu" then
            return self:openOptions(self.settingsButton)
        end
    end
    State.keypressed(self, key)
end

function MenuState:openOptions(btn)
    self.timer:tween(Vars.transition.tween, btn, {rotation = btn.rotation - math.pi}, 'linear')
    ScreenManager.push('OptionsState')
end

function MenuState:slideOut(callback)
    self:transition(self.ui:transitionOut(), callback)
end

function MenuState:init()
    local title = love.graphics.newText(assets.fonts.MarckScript(Vars.titleSize), Vars.appName)

    local elements = self:startUI({height = Vars.titleSize, color = function() return Theme.transparent:clone() end})
        :createTransition()
            :add('IconButton', {
                from = 'bottom',
                to = love.graphics.getHeight() - Vars.titleSize - 5,
                x = 5,
                icon = 'Off',
                callback = function() love.event.quit() end
            })
            :add('IconButton', {
                from = 'top',
                to = 5,
                x = 5,
                icon = 'Info',
                size = Vars.mobileButton.fontSize,
                callback = function() self:slideOut(function() ScreenManager.switch('CreditsState') end) end
            })
            :add('IconButton', {
                from = 'right',
                name = 'settingsButton',
                to = love.graphics.getWidth() - Vars.titleSize - 5,
                y = 5,
                icon = 'Cog',
                callback = function(btn) self:openOptions(btn) end
            })
            :add('Title', {
                from = 'top',
                fromPosition = -title:getHeight(),
                to = 0,
                x = love.graphics.getWidth() / 2 - title:getWidth() / 2,
                text = title,
            })
            :add('IconButton', {
                from = 'top',
                fromPosition = -Vars.titleSize - 5,
                to = Vars.baseLine + (Vars.lineHeight - 5) * 1.95,
                framed = true,
                centered = true,
                size = Vars.lineHeight * 2.1,
                padding = 10,
                icon = 'Music',
                callback = function(btn)
                    btn.consumed = false
                    ScreenManager.push('PlaySelectState')
                end
            })
            :add('IconButton', {
                from = 'top',
                fromPosition = -Vars.titleSize * 2,
                to =  Vars.baseLine + Vars.lineHeight * 2.2,
                x = love.graphics.getWidth() / 2 - Vars.titleSize * 2,
                anchor = 0.5,
                framed = true,
                padding = 5,
                height = Vars.lineHeight * 1.8,
                icon = 'BarCharts',
                callback = function(btn)
                    btn.consumed = false
                    self:slideOut(function()
                        ScreenManager.switch('StatisticsState')
                    end)
                end
            })
            :add('IconButton', {
                from = 'top',
                fromPosition = -Vars.titleSize * 2,
                to = Vars.baseLine + Vars.lineHeight * 2.2,
                x =  love.graphics.getWidth() / 2 + Vars.titleSize * 2,
                framed = true,
                padding = 5,
                anchor = 0.5,
                height = Vars.lineHeight * 1.8,
                icon = 'List',
                callback = function()
                    self:slideOut(function()
                        ScreenManager.switch('ScoreboardState')
                    end)
                end
            })
        :build()
    self:transition(elements)
end

return MenuState