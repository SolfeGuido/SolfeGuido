
-- LIBS
local DialogState = require('src.states.DialogState')
local ScreenManager = require('lib.ScreenManager')
local Theme = require('src.utils.Theme')
local UIFactory = require('src.utils.UIFactory')
local ParticleSystem = require('src.utils.ParticleSystem')
local JinglePlayer = require('src.utils.JinglePlayer')
local lume = require('lib.lume')

---@class EndGameState : State
local EndGameState = DialogState:extend()

local colors = {
    {lume.color('#011627')},
    {lume.color('#2EC4B6')},
    {lume.color('#E71D36')},
    {lume.color('#FF9F1C')}
}

function EndGameState:new()
    DialogState.new(self)
    self:setWidth(Vars.titleSize * 10)
    self.particles = ParticleSystem.noteBurstParticles(Theme.white)
end

function EndGameState:close()
    self.particles:release()
    self.particles = nil
end

function EndGameState:update(dt)
    DialogState.update(self, dt)
    self.particles:update(dt)
end

function EndGameState:draw()
    love.graphics.setColor(Theme.correct)
    love.graphics.draw(self.particles, love.graphics.getWidth() * 0.5, love.graphics.getHeight() * 0.5)
    if self.isBestScore then
        love.graphics.setColor(colors[1])
        love.graphics.draw(self.particles, 0, 0)
        love.graphics.setColor(colors[2])
        love.graphics.draw(self.particles, 0, love.graphics.getHeight())
        love.graphics.setColor(colors[3])
        love.graphics.draw(self.particles, love.graphics.getWidth(), 0)
        love.graphics.setColor(colors[4])
        love.graphics.draw(self.particles, love.graphics.getWidth(), love.graphics.getHeight())
    end
    DialogState.draw(self)
end

function EndGameState:validate()
    ScreenManager.switch('PlayState')
end

function EndGameState:slideOut()
    ScreenManager.switch('MenuState')
end

function EndGameState:init(score, best)
    self.isBestScore = best
    if self.isBestScore then
        colors = lume.shuffle(colors)
        JinglePlayer.play(assets.jingles.winner, self.timer)
    else
        JinglePlayer.play(assets.jingles.endgame, self.timer)
    end
    local title = best and 'best_score' or 'score'
    local text = love.graphics.newText(assets.fonts.MarckScript(Vars.titleSize), tr(title, {score = score}))
    local dialogMiddle = (love.graphics.getWidth() - self.margin * 2) / 2
    local middle = dialogMiddle - text:getWidth() / 2
    local yStart = 50
    local padding = 10
    self:transition({
        {
            element = UIFactory.createTitle(self, {
                text = text,
                y = 2,
                x = middle,
                color = Theme.transparent:clone()
            }),
            target = {color = Theme.font}
        },
        {
            element = UIFactory.createTextButton(self, {
                text = 'Restart',
                icon = 'Reload',
                fontName = 'Oswald',
                x = dialogMiddle,
                centerText = true,
                padding = padding,
                framed = true,
                y = yStart + Vars.mobileButton.fontSize + padding * 4,
                fontSize = Vars.mobileButton.fontSize,
                color = Theme.transparent:clone(),
                callback = function()
                    ScreenManager.push('CircleCloseState', 'open', 'GamePrepareState')
                end
            }),
            target = {color = Theme.font}
        },
        {
            element = UIFactory.createTextButton(self, {
                text= 'Menu',
                fontName = 'Oswald',
                icon = 'Home',
                x = dialogMiddle,
                centerText = true,
                framed = true,
                y = yStart + Vars.mobileButton.fontSize * 2 + padding * 8,
                fontSize = Vars.mobileButton.fontSize,
                padding = padding,
                color = Theme.transparent:clone(),
                callback = function()
                    -- Transition ?
                    ScreenManager.switch('MenuState')
                end
            }),
            target = {color = Theme.font}
        },
        {
            element = UIFactory.createTextButton(self, {
                text = 'Scoreboard',
                icon = 'List',
                fontName = 'Oswald',
                x = dialogMiddle,
                centerText = true,
                framed = true,
                y = yStart,
                fontSize = Vars.mobileButton.fontSize,
                padding = padding,
                color = Theme.transparent:clone(),
                callback = function()
                    -- Transition ?
                    ScreenManager.switch('ScoreboardState')
                end
            }),
            target = {color = Theme.font}
        }
    })
    self.height =  yStart + Vars.mobileButton.fontSize * 6 + padding * 6
    DialogState.init(self)
    self.particles:emit(200)
    self.particles:pause()
end

return EndGameState