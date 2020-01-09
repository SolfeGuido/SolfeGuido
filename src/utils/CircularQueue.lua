local class = require('lib.class')

local CircularQueue = class:extend()


function CircularQueue:new(generator, size)
    self._data = {}
    for _ = 1, size do
        self._data[#self._data+1] = generator()
    end
    self._head = 1
    self._queue = 1
end

function CircularQueue:peek()
    if self:isEmpty() then return nil end
    return self._data[self._head]
end

function CircularQueue:last()
    if self:isEmpty() then return nil end
    if self._queue == 1 then
        return self._data[#self._data]
    end
    return self._data[self._queue-1]
end

function CircularQueue:push(reseter)
    local target = self._data[self._queue]
    reseter(target)
    self._queue = self._queue + 1
    if self._queue > #self._data then self._queue = 1 end
    return target
end

function CircularQueue:shift()
    local target = self._data[self._head]
    self._head = self._head + 1
    if self._head > #self._data then self._head = 1 end
    return target
end

function CircularQueue:isEmpty()
    return self._head == self._queue
end

return CircularQueue