
--- LIBS
local State = require('src.State')
local lume = require('lib.lume')
local Config = require('src.data.Config')
local Theme = require('src.utils.Theme')
local ScreenManager = require('lib.ScreenManager')
local Logger = require('lib.logger')

--- Entities
local Score = require('src.objects.Score')
local Measure = require('src.objects.Measure')
local StopWatch = require('src.objects.Stopwatch')

---@class GamePrepareState : State
local GamePrepareState = State:extend()


function GamePrepareState:new()
    State.new(self)
    self.color = Theme.font:clone()
    self.notesQueue = nil
    self.coroutine = nil
    self.measures = nil
    self.scoreText = nil
    self.stopWatch = nil

    local middle = love.graphics.getHeight() / 2
    local font = love.graphics.getFont()
    self.text = tr('loading')
    local width = font:getWidth(self.text)
    local height = font:getHeight(self.text)
    self.textX = (love.graphics.getWidth() - width) / 2
    self.textY = middle - (height / 2)
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
        Logger.error('Unknown key : ' .. Config.keySelect)
        -- Show error dialog ?
        ScreenManager.switch('MenuState')
    end
    return sounds
end

function GamePrepareState:draw()
    -- Do not call state draw, to do not draw the prepared entities
    love.graphics.setBackgroundColor(Theme.background)
    love.graphics.setColor(self.color)
    love.graphics.print(self.text, self.textX, self.textY)
end

function GamePrepareState:update(dt)
    State.update(self, dt)
    if self.coroutine == nil then
        self.coroutine = coroutine.create(function()
            local timed = Config.gameMode == 'timed'
            local sounds = self:createMeasures()
            local step = 100 / (2 + #sounds + (timed and 1 or 0))
            coroutine.yield(step)
            local scoreText = love.graphics.newText(assets.fonts.MarckScript(Vars.score.fontSize),"0")
            self.score = Score(nil, {
                x = -scoreText:getWidth(),
                y = Vars.score.y,
                points = 0,
                text =  scoreText,
                color = Theme.transparent:clone()
            })
            coroutine.yield(step)
            if timed then
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
    if self.coroutine and coroutine.status(self.coroutine) ~= "dead" then
        local success, coProgress = coroutine.resume(self.coroutine)
        if not success then
            Logger.error(coProgress)
            -- Show error dialog ?
            ScreenManager.switch('MenuState')
        end
    end
    if self.coroutine and coroutine.status(self.coroutine) == "dead" then
        self.coroutine = false
        self.timer:tween(Vars.transition.tween, self, {color = Theme.background}, 'out-expo', function()
                -- Transition to playState
                ScreenManager.switch('PlayState', {
                    stopWatch = self.stopWatch,
                    measures = self.measures,
                    score = self.score
                })
                ScreenManager.push('CircleCloseState')
        end)
    end
end

return GamePrepareState