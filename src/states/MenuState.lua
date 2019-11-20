
-- LIBS
local State = require('src.State')
local UIFactory = require('src.utils.UIFactory')
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
    btn.consumed = false
    self.timer:tween(Vars.transition.tween, btn, {rotation = btn.rotation - math.pi}, 'linear')
    ScreenManager.push('OptionsState')
end

function MenuState:slideOut(callback)
    self:transition({
        {
            element = self.title,
            target = {color = Theme.transparent, y = - Vars.titleSize * 2}
        },
        {
            element = self.powerButton,
            target = {color = Theme.transparent, y = love.graphics.getHeight()}
        },
        {
            element = self.settingsButton,
            target = {color = Theme.transparent, x = love.graphics.getWidth()}
        },
        {
            element = self.playButton,
            target = {color = Theme.transparent, y = love.graphics.getHeight()}
        },
        {
            element = self.achievementsButton,
            target = {color = Theme.transparent, y = love.graphics.getHeight()}
        },
        {
            element = self.scoresButton,
            target = {color = Theme.transparent, y = love.graphics.getHeight()}
        }
    }, callback)
end

function MenuState:init(...)
    local title = love.graphics.newText(assets.MarckScript(Vars.titleSize), Vars.appName)

    self:transition({
        {
            element = UIFactory.createIconButton(self, {
                name = 'powerButton',
                x = 5,
                color = Theme.transparent:clone(),
                y = love.graphics.getHeight(),
                height = Vars.titleSize,
                icon = 'Off',
                callback = function() love.event.quit() end
            }),
            target = {color = Theme.font, y = love.graphics.getHeight() - Vars.titleSize - 5}
        },
        {
            element = UIFactory.createIconButton(self, {
                name = 'settingsButton',
                x = love.graphics.getWidth(),
                y = 5,
                color = Theme.transparent:clone(),
                height = Vars.titleSize,
                icon = 'Cog',
                callback = function(btn)
                    self:openOptions(btn)
                end
            }),
            target = {color = Theme.font, x = love.graphics.getWidth() - Vars.titleSize - 5}
        },
        {
            element = UIFactory.createTitle(self, {
                name = 'title',
                text = title,
                y = -title:getHeight(),
                color = Theme.transparent:clone(),
                x = love.graphics.getWidth() / 2 - title:getWidth() / 2
            }),
            target = {color = Theme.font, y = 0}
        },
        {
            element = UIFactory.createIconButton(self, {
                name = 'playButton',
                icon = 'Music',
                y = -Vars.titleSize - 5,
                padding = 10,
                size = Vars.titleSize * 1.5,
                framed = true,
                centered = true,
                color = Theme.transparent:clone(),
                callback = function(btn)
                    btn.consumed = false
                    ScreenManager.push('PlaySelectState')
                end
            }),
            target = {color = Theme.font, y = love.graphics.getHeight() / 2 - Vars.titleSize - 15}
        },
        {
            element = UIFactory.createIconButton(self, {
                name = 'achievementsButton',
                anchor = 0.5,
                padding = 5,
                icon = 'Trophy',
                y = -Vars.titleSize * 2,
                framed = true,
                x = love.graphics.getWidth() / 2 - Vars.titleSize * 2,
                color = Theme.transparent:clone()
            }),
            target = {color = Theme.font, y = love.graphics.getHeight() / 2 - Vars.titleSize +5}
        },
        {
            element = UIFactory.createIconButton(self, {
                name = 'scoresButton',
                padding = 5,
                anchor = 0.5,
                icon = 'List',
                y = -Vars.titleSize * 2,
                framed = true,
                x = love.graphics.getWidth() / 2 + Vars.titleSize * 2,
                color = Theme.transparent:clone(),
                callback = function()
                    self:slideOut(function()
                        ScreenManager.switch('ScoreState')
                    end)
                end
            }),
            target = {color = Theme.font, y = love.graphics.getHeight() / 2 - Vars.titleSize + 5}
        }
    })
end

return MenuState