
local State = require('src.State')
local Config = require('src.utils.Config')
local ScoreManager = require('src.utils.ScoreManager')
local i18n = require('lib.i18n')
local ScreeManager = require('lib.ScreenManager')
local Color = require('src.utils.Color')
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
    RootState = require('src.states.RootState'),
    PlaySelectState = require('src.states.PlaySelectState')
}

function SplashScreenState:new()
    State.new(self)
    self.coroutine = nil
    self.totalLoading = 0
    self.color = Color.black:clone()
end

function SplashScreenState:draw()
    State.draw(self)
    local middle = 160
    local progress = love.graphics.getWidth() * (self.totalLoading / 100)

    love.graphics.setBackgroundColor(Color.white)
    local font = love.graphics.getFont()
    local text = tostring(math.ceil(self.totalLoading)) .. " %"
    local width = font:getWidth(text)
    local height = font:getHeight(text)
    local txtX = (love.graphics.getWidth() - width) / 2

    love.graphics.setColor(self.color)
    love.graphics.print(text, txtX, middle - height)

    love.graphics.setColor(Color.black)
    love.graphics.setLineWidth(1)
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
        -- Create the two main fonts
        assets.MarckScript(assets.config.lineHeight)
        assets.MarckScript(assets.config.titleSize)
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
        -- Not working on windows exe when in coroutine
        _G['tr'] = function(data)
            return i18n.translate(string.lower(data), {default = data})
        end
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
    self.timer:tween(assets.config.transition.tween, self, {color = Color.transparent}, 'linear')
    local middle = assets.config.baseLine
    for i = 1,5 do
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
        y = middle + assets.config.lineHeight,
        height = 0,
    })
    local hTarget = assets.config.lineHeight * 4
    self.timer:tween(assets.config.transition.tween, line, {height = hTarget}, 'out-expo', function()
        -- Load all states this time
        ScreeManager.init(allStates, 'RootState')
    end)
end

return SplashScreenState