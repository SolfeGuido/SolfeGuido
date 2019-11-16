
--- LIBS
local State = require('src.State')
local lume = require('lib.lume')
local Config = require('src.utils.Config')
local Theme = require('src.utils.Theme')
local ScreenManager = require('lib.ScreenManager')

--- Entities
local Score = require('src.objects.Score')
local Measure = require('src.objects.Measure')
local StopWatch = require('src.objects.Stopwatch')

---@class GamePrepareState : State
local GamePrepareState = State:extend()


function GamePrepareState:new()
    State.new(self)
    self.loadingIcon = love.graphics.newText(assets.IconsFont(Vars.titleSize),assets.IconName.Spinner)
    self.progress = 0
    self.notesQueue = nil
    self.coroutine = nil
    self.measures = nil
    self.scoreText = nil
    self.stopWatch = nil
    self.singleStep = 1
    self.iconRotation = 0
end

function GamePrepareState:init(config)
    self.coroutine = coroutine.create(function()
        local sounds = self:createMeasures()
        local step = 100 / (2 + #sounds + (config.timed and 1 or 0))
        coroutine.yield(step)
        local scoreText = love.graphics.newText(assets.MarckScript(Vars.score.fontSize),"0")
        self.score = Score(nil, {
            x = -scoreText:getWidth(),
            y = Vars.score.y,
            points = 0,
            text =  scoreText,
            color = Theme.transparent:clone()
        })
        coroutine.yield(step)
        if config.timed then
            self.stopWatch = StopWatch(nil, {
                x = -Vars.stopWatch.size,
                y = Vars.stopWatch.y,
                size = Vars.stopWatch.size,
                started = false
            })
            coroutine.yield(step)
        end
        if not assets.sounds.notes then
            assets.sounds.notes  = {}
        end
        for _, v in ipairs(sounds) do
            if not assets.sounds.notes[v] then
                assets.sounds.notes[v] = love.sound.newSoundData('notes/' .. v .. '.ogg')
                coroutine.yield(step)
            end
        end
    end)
end

local spaces = {
    buttons = Vars.mobileButton.fontSize + Vars.mobileButton.padding * 2 + 20,
    piano = Vars.pianoHeight,
    pianoWithNotes = Vars.pianoHeight
}

function GamePrepareState:createMeasures()
    local availableSpace = love.graphics.getHeight() - (spaces[Config.answerType] or 0)
    local sounds = nil
    if Config.keySelect == 'gKey' then
        self.measures = {Measure(nil,{
            keyData = Vars.gKey,
            height = availableSpace
        })}
        sounds = self.measures[1]:getRequiredNotes()
    elseif Config.keySelect == 'fKey' then
        self.measures = {Measure(nil , {
            keyData = Vars.fKey,
            height = availableSpace
        })}
        sounds = self.measures[1]:getRequiredNotes()
    elseif Config.keySelect == 'both' then
        self.measures = {
            Measure(nil, {
                keyData = Vars.gKey,
                height = availableSpace / 2,
                y = 0
            }),
            Measure(nil, {
                keyData = Vars.fKey,
                height = availableSpace  / 2,
                y = availableSpace / 2
            })
        }
        sounds = lume.concat(self.measures[1]:getRequiredNotes(), self.measures[2]:getRequiredNotes())
    else
        error("unknow key")
    end
    return sounds
end

function GamePrepareState:draw()
    -- Do not call state draw, to do not draw the prepared entities

    love.graphics.setBackgroundColor(Theme.background)

    local middle = love.graphics.getHeight() / 2
    local progress = love.graphics.getWidth() * (self.progress / 100)

    love.graphics.setBackgroundColor(Theme.background)
    local font = love.graphics.getFont()
    local text = tostring(math.ceil(self.progress)) .. " %"
    local width = font:getWidth(text)
    local height = font:getHeight(text)
    local txtX = (love.graphics.getWidth() - width) / 2

    love.graphics.setColor(Theme.font)
    love.graphics.print(text, txtX, middle - height)

    love.graphics.setColor(Theme.font)
    love.graphics.setLineWidth(1)
    love.graphics.line(0, middle , progress, middle)
    love.graphics.draw(self.loadingIcon, love.graphics.getWidth() / 2, middle + Vars.titleSize, self.iconRotation, 1, 1, Vars.titleSize / 2, Vars.titleSize / 2)
end

function GamePrepareState:update(dt)
    self.iconRotation = self.iconRotation + dt
    State.update(self, dt)
    if coroutine.status(self.coroutine) ~= "dead" then
        local success, coProgress = coroutine.resume(self.coroutine)
        self.progress = self.progress + (coProgress or 0)
    end
    if self.coroutine and coroutine.status(self.coroutine) == "dead" then
        self.coroutine = nil
        -- Transition to playState
        ScreenManager.switch('PlayState', {
            stopWatch = self.stopWatch,
            measures = self.measures,
            score = self.score
        })
    end
end

return GamePrepareState