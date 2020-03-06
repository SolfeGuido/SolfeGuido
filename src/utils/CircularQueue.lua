local class = require('lib.class')

--- This circular queue is like an object pool,
--- when created, it fills up its talbe with
--- the data generated, when adding a new element,
--- the queue is incremented and the entity at the given
--- cell is reset, this queue is used for the notes
--- allowing to allocate the notes only once, and reuse
--- them during a game
---@class CircularQueue
---@field private _data table
---@field private _head number
---@field private _queue number
local CircularQueue = class:extend()

--- Constructor, initializes an array
--- of the given size, and fills it up
--- with entities provided by the generator
---@param generator function
---@param size number
function CircularQueue:new(generator, size)
    self._data = {}
    for _ = 1, size do
        self._data[#self._data+1] = generator()
    end
    self._head = 1
    self._queue = 1
end

--- Access to the first element of the queue that is initialized
--- when uninitialized, returns nil
---@return any|nil
function CircularQueue:peek()
    if self:isEmpty() then return nil end
    return self._data[self._head]
end

--- Access to the last element that is ini of the queue
--- when unitialized, returns nil
---@return any|nil
function CircularQueue:last()
    if self:isEmpty() then return nil end
    if self._queue == 1 then
        return self._data[#self._data]
    end
    return self._data[self._queue-1]
end

--- Adds a new element to the queue,
--- resets it with the given function
---@param reseter function
---@return any
function CircularQueue:push(reseter)
    local target = self._data[self._queue]
    reseter(target)
    self._queue = self._queue + 1
    if self._queue > #self._data then self._queue = 1 end
    return target
end

--- Removes the first element of the list
--- and circles if needed
function CircularQueue:shift()
    local target = self._data[self._head]
    self._head = self._head + 1
    if self._head > #self._data then self._head = 1 end
    return target
end

--- When the head and the queue point to the same
--- index, that means the queue is empty
---@return boolean
function CircularQueue:isEmpty()
    return self._head == self._queue
end

return CircularQueue