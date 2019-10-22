
local State = require('src.State')
local Color = require('src.utils.Color')
local Graphics = require('src.utils.Graphics')
local ScreenManager = require('lib.ScreenManager')

--- ENTITIES
local Title = require('src.objects.Title')
local TextButton = require('src.objects.TextButton')
local IconButton = require('src.objects.IconButton')

---@class RootState : State
local RootState = State:extend()


function RootState:new()
    State.new(self)
    self.selectedState = nil
    self.sideEnabled = false
end

function RootState:handleEvent(evName, ...)
    self:callOnEntities(evName, ...)
end

function RootState:init(...)
    self.quitButton = self:addentity(IconButton, {
        x = 0,
        color = Color.transparent:clone(),
        y = love.graphics.getHeight(),
        height = assets.config.titleSize,
        image = "exit",
        callback = function() love.event.quit() end
    })
    self.backButton = self:addentity(IconButton, {
        x = 0,
        y = love.graphics.getHeight(),
        color = Color.transparent:clone(),
        height = assets.config.titleSize,
        image = "exitLeft",
        callback = function() self:pop() end
    })

    self.settingsButton = self:addentity(IconButton, {
        x = love.graphics.getWidth(),
        y = 0,
        color = Color.transparent:clone(),
        height = assets.config.titleSize,
        image = "gear",
        callback = function()
            ScreenManager.push('OptionsState')
        end
    })

    local text = love.graphics.newText(assets.MarckScript(assets.config.titleSize),"Menu")
    self.title = self:addentity(Title, {
        text = text,
        framed = true,
        y = -text:getHeight(),
        color = Color.transparent:clone(),
        x = love.graphics.getWidth() / 2 - text:getWidth() / 2
    })

    self:transition({
        {
            element = self.quitButton,
            target = {color = Color.black, y = love.graphics.getHeight() - assets.config.titleSize}
        },
        {
            element = self.settingsButton,
            target = {color = Color.black, x = love.graphics.getWidth() - assets.config.titleSize}
        },
        {
            element = self.title,
            target = {color = Color.black, y = 0}
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
                text = 'Help',
                callback = self:btnCallBack('Help')
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

    self:changeTitle(tr('Menu'))
    self:switchButtons(self.quitButton, self.backButton)
    self.selectedState = nil
end

function RootState:changeTitle(newTitle)
    local time = assets.config.transition.tween
    self.timer:tween(time, self.title, {y = -assets.config.titleSize - 15}, 'out-expo',function ()
        self.title:setText(newTitle)
        self.title:center()
        self.timer:tween(time, self.title, {y = 0}, 'out-expo')
    end)
end

function RootState:switchButtons(enter, leaves)
    local time = assets.config.transition.tween
    self.timer:tween(time, leaves, {y = love.graphics.getHeight(), color = Color.transparent}, 'out-expo', function()
        leaves.consumed = false
        self.timer:tween(time, enter, {color = Color.black, y = love.graphics.getHeight() - assets.config.titleSize}, 'out-expo')
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