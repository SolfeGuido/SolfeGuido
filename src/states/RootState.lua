
local State = require('src.State')
local Theme = require('src.utils.Theme')
local Graphics = require('src.utils.Graphics')
local ScreenManager = require('lib.ScreenManager')
local Mobile = require('src.utils.Mobile')

--- ENTITIES
local Title = require('src.objects.Title')
local IconButton = require('src.objects.IconButton')

---@class RootState : State
local RootState = State:extend()


function RootState:new()
    State.new(self)
    self.selectedState = nil
    self.sideEnabled = false
end

function RootState:handleEvent(evName, arg1, ...)
    if evName == "keypressed" and arg1 == "escape" then
        self:pop()
    else
        State[evName](self, arg1, ...)
    end
end

function RootState:keypressed(key)
    if key == "escape" and Mobile.isMobile then
        love.event.quit()
    else
        State.keypressed(self, key)
    end
end

function RootState:init(...)
    self.quitButton = self:addentity(IconButton, {
        x = 5,
        color = Theme.transparent:clone(),
        y = love.graphics.getHeight(),
        height = Vars.titleSize,
        icon = assets.IconName.Off,
        callback = function() love.event.quit() end
    })
    self.backButton = self:addentity(IconButton, {
        x = 5,
        y = love.graphics.getHeight(),
        color = Theme.transparent:clone(),
        height = Vars.titleSize,
        icon = assets.IconName.Home,
        callback = function() self:pop() end
    })

    self.settingsButton = self:addentity(IconButton, {
        x = love.graphics.getWidth(),
        y = 5,
        color = Theme.transparent:clone(),
        height = Vars.titleSize,
        icon = assets.IconName.Cog,
        callback = function(btn)
            self.timer:tween(Vars.transition.tween, btn, {rotation = btn.rotation - math.pi}, 'linear')
            ScreenManager.push('OptionsState')
        end
    })

    local text = love.graphics.newText(assets.MarckScript(Vars.titleSize), Vars.appName)
    self.title = self:addentity(Title, {
        text = text,
        framed = true,
        y = -text:getHeight(),
        color = Theme.transparent:clone(),
        x = love.graphics.getWidth() / 2 - text:getWidth() / 2
    })

    self:transition({
        {
            element = self.quitButton,
            target = {color = Theme.font, y = love.graphics.getHeight() - Vars.titleSize - 5}
        },
        {
            element = self.settingsButton,
            target = {color = Theme.font, x = love.graphics.getWidth() - Vars.titleSize - 5}
        },
        {
            element = self.title,
            target = {color = Theme.font, y = 0}
        }
    }, function() self.sideEnabled = true end)

    self:createUI({
        {
            {
                type = 'TextButton',
                text = 'Play',
                callback = self:btnCallBack('Play', 'MenuState')
            },
            {
                type = 'TextButton',
                text = 'Score',
                callback = self:btnCallBack('Score')
            }, {
                type = 'TextButton',
                text = 'Credits',
                callback = self:btnCallBack('Credits')
            }
        }
    })
end

function RootState:btnCallBack(title, statename)
    return function(btn)
        self:switchTo(title, statename or (title .. 'State'), btn)
    end
end

function RootState:receive(event, ...)
    if event ~= "pop" then
        self:handleEvent(event, ...)
    end
end

function RootState:switchTo(title, statename, btn)
    local readyCallback = function() ScreenManager.push(statename) end
    if self.selectedState then
        ScreenManager.publish('pop', readyCallback)
        self.selectedState:setConsumed(false)
    else
        self:switchButtons(self.backButton, self.quitButton)
        readyCallback()
    end
    self.selectedState = btn
    self:changeTitle(tr(title))
end

function RootState:pop()
    if self.selectedState then
        ScreenManager.publish('pop')
        self.selectedState:setConsumed(false)
    end

    self:changeTitle(Vars.appName)
    self:switchButtons(self.quitButton, self.backButton)
    self.selectedState = nil
end

function RootState:changeTitle(newTitle)
    local time = Vars.transition.tween
    self.timer:tween(time, self.title, {y = -Vars.titleSize - 15}, 'out-expo',function ()
        self.title:setText(newTitle)
        self.title:center()
        self.timer:tween(time, self.title, {y = 0}, 'out-expo')
    end)
end

function RootState:switchButtons(enter, leaves)
    local time = Vars.transition.tween
    self.timer:tween(time, leaves, {y = love.graphics.getHeight(), color = Theme.transparent}, 'out-expo', function()
        leaves.consumed = false
        self.timer:tween(time, enter, {color = Theme.font, y = love.graphics.getHeight() - Vars.titleSize - 5}, 'out-expo')
    end)
end

function RootState:draw()
    State.draw(self)
    Graphics.drawMusicBars()
end

function RootState:update(dt)
    State.update(self, dt)
end

return RootState