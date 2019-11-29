
local State = require('src.State')
local Graphics = require('src.utils.Graphics')
local UIFactory = require('src.utils.UIFactory')
local Theme = require('src.utils.Theme')
local ScreenManager = require('lib.ScreenManager')

---@class CreditsState : State
local CreditsState = State:extend()

function CreditsState:keypressed(key)
    if key == "escape" then
        self:slideOut()
    else
        State.keypressed(self, key)
    end
end

function CreditsState:draw()
    Graphics.drawMusicBars()
    State.draw(self)
end

function CreditsState:slideOut(callback)
    callback = callback or function() ScreenManager.switch('MenuState') end
    self:transition({
        {
            element = self.title,
            target = {color = Theme.transparent, y = -Vars.titleSize}
        },
        {
            element = self.homeButton,
            target = {color = Theme.transparent, y = love.graphics.getHeight()}
        },
        {
            element = self.madeWithTitle,
            target = {color = Theme.transparent, x = -self.madeWithTitle:width() - 5}
        },
        {
            element = self.soundsTitle,
            target = {color = Theme.transparent, x = -self.soundsTitle:width() - 5}
        },
        {
            element = self.iconsTitle,
            target = {color = Theme.transparent, x = -self.iconsTitle:width() - 5}
        },
        {
            element = self.byTitle,
            target = {color = Theme.transparent, x = -self.byTitle:width() - 5}
        },
        {
            element = self.loveImage,
            target = {color = Theme.transparent, x = love.graphics.getWidth()}
        },
        {
            element = self.loveTitle,
            target = {color = Theme.transparent, x = love.graphics.getWidth()}
        },
        {
            element = self.azariasTitle,
            target = {color = Theme.transparent, x = love.graphics.getWidth()}
        },
        {
            element = self.iowaTitle,
            target = {color = Theme.transparent, x = love.graphics.getWidth()}
        },
        {
            element = self.iconMoonTitle,
            target = {color = Theme.transparent, x = love.graphics.getWidth()}
        }
    }, callback)
end

function CreditsState:init()
    local fontSize = 2 * Vars.lineHeight / 3
    self:transition({
        {
            element = UIFactory.createTitle(self, {
                centered = true,
                name = 'title',
                text = 'Credits',
                x = 0,
                y = -Vars.titleSize,
                color = Theme.transparent:clone()
            }),
            target = {color = Theme.font, y = 5}
        },
        {
            element = UIFactory.createIconButton(self, {
                icon = 'Home',
                name = 'homeButton',
                x = 5,
                y = love.graphics.getHeight(),
                color = Theme.transparent:clone(),
                callback = function()
                    self:slideOut()
                end
            }),
            target = {color = Theme.font, y = love.graphics.getHeight() -Vars.titleSize - 5}
        },
        {
            element = UIFactory.createTitle(self, {
                text = 'Made with',
                fontName = 'Oswald',
                name =  'madeWithTitle',
                x = -100,
                y = Vars.baseLine + Vars.lineHeight,
                fontSize = fontSize
            }),
            target = {color = Theme.font, x = Vars.limitLine - self.madeWithTitle:width() - 5}
        },
        {
            element = UIFactory.createTitle(self, {
                text = 'By',
                fontName = 'Oswald',
                name = 'byTitle',
                x = -100,
                y = Vars.baseLine + Vars.lineHeight * 2,
                fontSize = fontSize
            }),
            target = {color = Theme.font, x = Vars.limitLine - self.byTitle:width() - 5}
        },
        {
            element = UIFactory.createTitle(self, {
                text = 'Icons',
                fontName = 'Oswald',
                name = 'iconsTitle',
                x = -100,
                y = Vars.baseLine + Vars.lineHeight * 3,
                fontSize = fontSize
            }),
            target = {color = Theme.font, x = Vars.limitLine - self.iconsTitle:width() - 5}
        },
        {
            element = UIFactory.createTitle(self, {
                text = 'Sounds',
                fontName = 'Oswald',
                name = 'soundsTitle',
                x = -100,
                y = Vars.baseLine + Vars.lineHeight * 4,
                fontSize = fontSize
            }),
            target = {color = Theme.font, x = Vars.limitLine - self.soundsTitle:width() - 5}
        },
        {
            element = UIFactory.createTitle(self, {
                text = 'Azarias',
                fontName = 'Oswald',
                name = 'azariasTitle',
                x = love.graphics.getWidth(),
                fontSize = fontSize,
                y = Vars.baseLine + Vars.lineHeight * 2
            }),
            target = {color = Theme.font, x = Vars.limitLine + 5}
        },
        {
            element = UIFactory.createTitle(self, {
                text = 'IconMoonApp',
                fontName = 'Oswald',
                name = 'iconMoonTitle',
                x = love.graphics.getWidth(),
                fontSize = fontSize,
                y = Vars.baseLine + Vars.lineHeight * 3
            }),
            target = {color = Theme.font, x = Vars.limitLine + 5}
        },
        {
            element = UIFactory.createTitle(self, {
                text = 'University of Iowa',
                fontName = 'Oswald',
                name = 'iowaTitle',
                x = love.graphics.getWidth(),
                y = Vars.baseLine + Vars.lineHeight * 4,
                fontSize = fontSize
            }),
            target = {color = Theme.font, x = Vars.limitLine + 5}
        },
        {
            element = UIFactory.createImage(self, {
                image = assets.images.loveIcon,
                name = 'loveImage',
                x = love.graphics.getWidth() + Vars.lineHeight,
                y = Vars.baseLine + Vars.lineHeight * 1.5,
                size = Vars.lineHeight - 5,
            }),
            target = {color = Theme.white, x = Vars.limitLine + Vars.lineHeight / 2}
        },
        {
            element = UIFactory.createTitle(self, {
                text = 'Löve2d',
                fontName = 'Oswald',
                name = 'loveTitle',
                x = love.graphics.getWidth(),
                y = Vars.baseLine + Vars.lineHeight,
                fontSize = fontSize
            }),
            target = {color = Theme.font, x = Vars.limitLine + Vars.lineHeight}
        }
    })
end


return CreditsState