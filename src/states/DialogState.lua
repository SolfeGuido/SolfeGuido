-- LIBS
local State = require('src.State')
local Mobile = require('src.utils.Mobile')
local ScreenManager = require('lib.ScreenManager')
local Theme = require('src.utils.Theme')

-- Entities
local Title = require('src.objects.Title')
local IconButton = require('src.objects.IconButton')
local TextButton = require('src.objects.TextButton')

---@class DialogState : State
local DialogState = State:extend()


function DialogState:new()
    State.new(self)
    self.yBottom = 0
    self.margin = self:getMargin()
end

function DialogState:validate() end

function DialogState:getMargin()
    -- Change for mobile, create ratio or something
    return Mobile.isMobile and love.graphics.getWidth() / 6 or Vars.limitLine
end

function DialogState:keypressed(key)
    if key == "escape" then
        self:slideOut()
    else
        State.keypressed(self, key)
    end
end

function DialogState:slideOut()
    self:slideEntitiesOut()
    self.timer:tween(Vars.transition.tween, self, {yBottom = 0}, 'out-expo',function()
        ScreenManager.pop()
    end)
end

function DialogState:init(options)
    local iconX = love.graphics.getWidth() - self.margin - Vars.titleSize - 5
    local elements = {
        {
            element = self:addentity(IconButton, {
                icon = assets.IconName.Times,
                callback = function() self:slideOut() end,
                x = iconX,
                y = -Vars.titleSize,
                color = Theme.transparent:clone()
            }),
            target  = {y = 5, color = Theme.font}
        },
        {
            element = self:addentity(TextButton, {
                icon = options.validateIcon or assets.IconName.Play,
                callback = function() self:validate() end,
                x = 0,
                framed = true,
                centered = true,
                y = love.graphics.getHeight(),
                color = Theme.transparent:clone(),
                text = love.graphics.newText(assets.MarckScript(Vars.lineHeight), tr(options.validate or 'Validate'))
            }),
            target = {y = love.graphics.getHeight() - Vars.titleSize * 2, color = Theme.font}
        }
    }
    if options.title then
        local titleText = love.graphics.newText(assets.MarckScript(Vars.titleSize), tr(options.title))
        elements[#elements + 1] = {
                element = self:addentity(Title, {
                text = titleText,
                x = love.graphics.getWidth() /2 - titleText:getWidth() / 2,
                y = - titleText:getHeight(),
                framed = true,
                color = Theme.transparent:clone()
            }),
            target = {y = 0, color = Theme.font}
        }
    end

    self:transition(elements)
    self.timer:tween(Vars.transition.tween, self, {yBottom = love.graphics.getHeight()}, 'out-expo')
end

function DialogState:draw()
    local width = love.graphics.getWidth() - self.margin * 2

    love.graphics.setScissor(self.margin - 2, 0, width + 5, love.graphics.getHeight())
    love.graphics.push()
    love.graphics.translate(0,self.yBottom - love.graphics.getHeight())

    love.graphics.setColor(Theme.background)
    love.graphics.rectangle('fill', self.margin - 1, 0, width, love.graphics.getHeight() + 2)
    love.graphics.setColor(Theme.font)
    love.graphics.rectangle('line', self.margin - 1, 0, width, love.graphics.getHeight() + 2)
    State.draw(self)

    love.graphics.pop()
    love.graphics.setScissor()
end

return DialogState