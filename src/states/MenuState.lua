
-- LIBS
local State = require('src.State')
local UIFactory = require('src.utils.UIFactory')
local Graphics = require('src.utils.Graphics')
local Theme = require('src.utils.Theme')
local ScreenManager = require('lib.ScreenManager')
local lume = require('lib.lume')

local ParticleSystem = require('src.utils.ParticleSystem')

---@class MenuState : State
local MenuState = State:extend()

function MenuState:new()
    MenuState.super.new(self)
    self.particleSystem = ParticleSystem.noteBurstParticles(Theme.white:clone())
    self.particleSystem:pause()
    self.colorOrders = {
        {0.5, 1, 0.5, 1},
        {1, 0.5, 1, 1},
        {1, 0, 1, 1},
        {1, 0.5, 0.5, 1}
    }
end

function MenuState:draw()
    Graphics.drawMusicBars()
    MenuState.super.draw(self)
    love.graphics.setColor(self.colorOrders[1])
    love.graphics.draw(self.particleSystem, love.graphics.getWidth(), love.graphics.getHeight())
    love.graphics.setColor(self.colorOrders[2])
    love.graphics.draw(self.particleSystem, love.graphics.getWidth(), 0)
    love.graphics.setColor(self.colorOrders[3])
    love.graphics.draw(self.particleSystem, 0, 0)
    love.graphics.setColor(self.colorOrders[4])
    love.graphics.draw(self.particleSystem, 0, love.graphics.getHeight())
end

function MenuState:update(dt)
    State.update(self, dt)
    self.particleSystem:update(dt)
end

function MenuState:keypressed(key)
    if self:isActive() then
        if key == "escape" then
            return love.event.quit()
        elseif key == "menu" then
            return self:openOptions(self.settingsButton)
        elseif key == "space" then
            self.colorOrders = lume.shuffle(self.colorOrders)
            self.particleSystem:start()
            self.particleSystem:emit(200)
            self.particleSystem:pause()
        end
    end
    State.keypressed(self, key)
end

function MenuState:openOptions(btn)
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
        },
        {
            element = self.creditsButton,
            target = {color = Theme.transparent, y = -Vars.titleSize}
        }
    }, callback)
end

function MenuState:init(...)
    local title = love.graphics.newText(assets.fonts.MarckScript(Vars.titleSize), Vars.appName)

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
                name = 'creditsButton',
                x = 5,
                size = Vars.mobileButton.fontSize,
                color = Theme.transparent:clone(),
                y = -Vars.titleSize,
                height = Vars.titleSize,
                icon = 'Info',
                callback = function()
                    self:slideOut(function()
                        ScreenManager.switch('CreditsState')
                    end)
                end
            }),
            target = {color = Theme.font, y = 5}
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
                icon = 'BarCharts',
                y = -Vars.titleSize * 2,
                framed = true,
                x = love.graphics.getWidth() / 2 - Vars.titleSize * 2,
                color = Theme.transparent:clone(),
                callback = function(btn)
                    btn.consumed = false
                    self:slideOut(function()
                        ScreenManager.switch('StatisticsState')
                    end)
                end
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
                        ScreenManager.switch('ScoreboardState')
                    end)
                end
            }),
            target = {color = Theme.font, y = love.graphics.getHeight() / 2 - Vars.titleSize + 5}
        }
    })
end

return MenuState