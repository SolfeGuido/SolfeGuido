
local State = require('src.State')
local Config = require('src.utils.Config')
local ScoreManager = require('src.utils.ScoreManager')
local i18n = require('lib.i18n')
local ScreeManager = require('lib.ScreenManager')
local Mobile = require('src.utils.Mobile')

local Line = require('src.objects.Line')

---@class SplashScreenState : State
local SplashScreenState = State:extend()

local allStates = {
    PlayState = require('src.states.PlayState'),
    MenuState = require('src.states.MenuState'),
    PauseState = require('src.states.PauseState'),
    OptionsState  = require('src.states.OptionsState'),
    ScoreState = require('src.states.ScoreState'),
    CreditsState = require('src.states.CreditsState'),
    EndGameState = require('src.states.EndGameState'),
    HelpState = require('src.states.HelpState')
}

function SplashScreenState:new()
    State.new(self)
    self.coroutine = nil
    self.totalLoading = 0
end

function SplashScreenState:draw()
    State.draw(self)
    love.graphics.setBackgroundColor(1, 1, 1, 1)
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.setLineWidth(1)
    local middle = 160
    local progress = love.graphics.getWidth() * (self.totalLoading / 100)
    love.graphics.line(0, middle , progress, middle)
end

function SplashScreenState:createCoroutine()
    return coroutine.create(function()
        math.randomseed(os.time())
        _G['assets'] = require('lib.cargo').init('res', 97)
        Config.parse()
        Mobile.configure()
        coroutine.yield(1)
        ScoreManager.init()
        coroutine.yield(1)
        i18n.load(assets.lang)
        i18n.setLocale(Config.lang or 'en')
        _G['tr'] = function(data)
            return i18n.translate(string.lower(data), {default = data})
        end
        -- Create the two main fonts
        assets.MarckScript(assets.config.lineHeight)
        assets.MarckScript(40)
        coroutine.yield(1)
    end)
end

function SplashScreenState:updateCoroutine()
    local success, progress = coroutine.resume(self.coroutine)
    if success then
        self.totalLoading = self.totalLoading + (progress or 0)
    end
    if coroutine.status(self.coroutine) == "dead" then
        self.coroutine = "done"
        self:displayLines()
    end
end

function SplashScreenState:update(dt)
    State.update(self, dt)
    if not self.coroutine then
        self.coroutine = self:createCoroutine()
    elseif self.coroutine ~= "done" then
        self:updateCoroutine()
    end
end

function SplashScreenState:displayLines()
    local middle = assets.config.baseLine
    for i = 1,4 do
        local ypos = middle + assets.config.lineHeight * i
        local line = self:addentity(Line, {
            x = 0,
            y = ypos,
            width = 0,
        })
        self.timer:tween(assets.config.transition.tween, line, {width = love.graphics.getWidth()}, 'out-expo')
    end

    local line = self:addentity(Line, {
        x = assets.config.limitLine,
        y = 0,
        height = 0,
    })
    self.timer:tween(assets.config.transition.tween, line, {height = love.graphics.getHeight()}, 'out-expo', function()
        -- Load all states this time
        ScreeManager.init(allStates, 'MenuState')
    end)
end

return SplashScreenState