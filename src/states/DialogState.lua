-- LIBS
local State = require('src.State')
local Mobile = require('src.utils.Mobile')
local ScreenManager = require('lib.ScreenManager')
local Theme = require('src.utils.Theme')

-- Entities
local UIFactory = require('src.utils.UIFactory')
local Title = require('src.objects.Title')
local IconButton = require('src.objects.IconButton')
local TextButton = require('src.objects.TextButton')

---@class DialogState : State
local DialogState = State:extend()


function DialogState:new()
    State.new(self)
    self.yBottom = 0
    self.margin = self:getMargin()
    self:redirectMouse('mousemoved', 'mousepressed', 'mousereleased')
    self:redirectTouch('touchmoved', 'touchpressed', 'touchreleased')
end

function DialogState:getMargin()
    -- Change for mobile, create ratio or something
    return Mobile.isMobile and love.graphics.getWidth() / 6 or Vars.limitLine
end

function DialogState:redirectMouse(...)
    for _, evName in ipairs({...}) do
        DialogState[evName] = function(obj, x, y, ...)
            State[evName](obj, x - self.margin, y - self.yBottom +  love.graphics.getHeight(), ...)
        end
    end
end

function DialogState:redirectTouch(...)
    for _,evName in ipairs({...}) do
        DialogState[evName] = function(obj, id, x, y, ...)
            State[evName](obj, id, x - self.margin, y - self.yBottom + love.graphics.getHeight(), ...)
        end
    end
end

function DialogState:keypressed(key)
    if key == "escape" then
        self:slideOut()
    else
        State.keypressed(self, key)
    end
end

function DialogState:slideOut()
    self.timer:tween(Vars.transition.tween, self, {yBottom = -10}, 'out-expo',function()
        ScreenManager.pop()
    end)
end

function DialogState:init(options)
    local iconX = love.graphics.getWidth() - self.margin * 2 - Vars.titleSize / 1.2
    local elements = {
        {
            element = UIFactory.createIconButton(self, {
                icon = 'Times',
                callback = function() self:slideOut() end,
                x = iconX,
                y = -Vars.titleSize,
                size = Vars.titleSize / 1.5,
                color = Theme.transparent:clone()
            }),
            target  = {y = 25, color = Theme.font}
        }
    }
    if options.title then
        local titleText = love.graphics.newText(assets.MarckScript(Vars.titleSize), tr(options.title))
        elements[#elements + 1] = {
                element = self:addentity(Title, {
                text = titleText,
                x = love.graphics.getWidth() /2 - titleText:getWidth() / 2,
                y = -titleText:getHeight() ,
                framed = true,
                color = Theme.transparent:clone()
            }),
            target = {y = 20, color = Theme.font}
        }
    end

    self:transition(elements)
    self.timer:tween(Vars.transition.tween, self, {yBottom = love.graphics.getHeight() - 10}, 'out-expo')
end

function DialogState:draw()
    local width = love.graphics.getWidth() - self.margin * 2

    love.graphics.setScissor(self.margin - 2, 0, width + 5, love.graphics.getHeight())
    love.graphics.push()
    love.graphics.translate(self.margin ,self.yBottom - love.graphics.getHeight())

    love.graphics.setColor(Theme.background)
    love.graphics.rectangle('fill', - 1, 20, width, love.graphics.getHeight() - 20)
    love.graphics.setColor(Theme.font)
    love.graphics.rectangle('line', -1 , 20, width, love.graphics.getHeight() - 20)
    State.draw(self)

    love.graphics.pop()
    love.graphics.setScissor()
end

return DialogState