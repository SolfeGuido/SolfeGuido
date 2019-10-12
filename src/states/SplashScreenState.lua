
local State = require('src.State')
local Config = require('src.utils.Config')
local ScoreManager = require('src.utils.ScoreManager')
local i18n = require('lib.i18n')
local ScreeManager = require('lib.ScreenManager')

---@class SplashScreenState : State
local SplashScreenState = State:extend()


function SplashScreenState:new()
    State.new(self)
    self.coroutine = nil
    self.totalLoading = 0
    self.color = {0, 0, 0, 1}
end

function SplashScreenState:draw()
    State.draw(self)
    love.graphics.setBackgroundColor(1, 1, 1, 1)
    love.graphics.setColor(self.color)
    local middle = math.floor(love.graphics.getHeight() / 2)
    local progress = love.graphics.getWidth() * (self.totalLoading / 100)
    love.graphics.line(0, middle , progress, middle)
end

function SplashScreenState:update(dt)
    State.update(self, dt)
    if not self.coroutine then
        self.coroutine = coroutine.create(function()
            math.randomseed(os.time())
            _G['assets'] = require('lib.cargo').init('res', 97)
            Config.parse()
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
    else
        if self.coroutine ~= "done" then
            local success, progress = coroutine.resume(self.coroutine)
            if success then
                self.totalLoading = self.totalLoading + (progress or 0)
            end
            if coroutine.status(self.coroutine) == "dead" then
                self.coroutine = "done"
                self.timer:tween(assets.config.transition.tween, self, { color = {0, 0, 0, 0}}, 'out-expo', function()
                    ScreeManager.switch('MenuState')
                end)
            end
        end
    end
end

return SplashScreenState