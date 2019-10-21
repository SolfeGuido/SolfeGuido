
local State = require('src.State')
local Color = require('src.utils.Color')
local Graphics = require('src.utils.Graphics')
local ScreenManager = require('lib.ScreenManager')

--- ENTITIES
local Title = require('src.objects.Title')
local IconButton = require('src.objects.IconButton')

---@class RootState : State
local RootState = State:extend()


function RootState:new()
    State.new(self)
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
        image = "exitLeft", -- todo change the icon
        callback = function() ScreenManager.publish('pop') end
    })

    self.settingsButton = self:addentity(IconButton, {
        x = love.graphics.getWidth(),
        y = 0,
        color = Color.transparent:clone(),
        height = assets.config.titleSize,
        image = "gear",
        callback = function() ScreenManager.push('OptionsState') end
    })

    local text = love.graphics.newText(assets.MarckScript(assets.config.titleSize),"Menu")
    self.title = self:addentity(Title, {
        text = text,
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
    })

    self:createUI({
        {
            {
                type = 'TextButton',
                text = 'Play',
                statePush = 'PlayState'
            },
            {
                type = 'TextButton',
                text = 'Score',
                statePush = 'ScoreState'
            }, {
                type = 'TextButton',
                text = 'Help',
                statePush = 'HelpState'
            }, {
                type = 'TextButton',
                text = 'Credits',
                callback = function() self:switchTo('Credits') end
            }
        }
    })
end

function RootState:receive(event, ...)
    self:handleEvent(event, ...)
end

function RootState:switchTo(state)
    local time = assets.config.transition.tween
    self.timer:tween(time, self.title, {y = -assets.config.titleSize - 15}, 'out-expo',function ()
        self.title:setText(state)
        self.title:center()
        self.timer:tween(time, self.title, {y = 0}, 'out-expo')
    end)
    self.timer:tween(time, self.quitButton, {y = love.graphics.getHeight(), color = Color.transparent}, 'out-expo', function()
        self.timer:tween(time, self.backButton, {color = Color.black, y = love.graphics.getHeight() - assets.config.titleSize}, 'out-expo')
end)
    ScreenManager.push(state .. 'State')
end

function RootState:draw()
    State.draw(self)
    Graphics.drawMusicBars()
    love.graphics.rectangle('line', self.title.x - 5, self.title.y - 5, self.title:width() + 10, self.title:height() + 5)
end

function RootState:update(dt)
    State.update(self, dt)
end

return RootState