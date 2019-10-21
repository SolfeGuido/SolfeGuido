
local State = require('src.State')
local Color = require('src.utils.Color')
local Graphics = require('src.utils.Graphics')
local ScreeManager = require('lib.ScreenManager')

--- ENTITIES
local Title = require('src.objects.Title')
local IconButton = require('src.objects.IconButton')

---@class RootState : State
local RootState = State:extend()


function RootState:new()
    State.new(self)
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
        image = "exit", -- todo change the icon
        callback = function() ScreeManager.pop() end
    })

    self.settingsButton = self:addentity(IconButton, {
        x = love.graphics.getWidth(),
        y = 0,
        color = Color.transparent:clone(),
        height = assets.config.titleSize,
        image = "gear",
        callback = function() ScreeManager.push('OptionsState') end
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
                statePush = 'Credits'
            }
        }
    })
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