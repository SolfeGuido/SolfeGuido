local Class = require('lib.class')

local Queue = Class:extend()

---@class Queue
---@field private data table
function Queue:new()
  self.data = {}
end

---@return nil|any
function Queue:shift()
    if #self.data == 0 then return nil end
    local ret = self.data[1]
    table.remove(self.data, 1)
    return ret
end

function Queue:isEmpty()
  return #self.data == 0
end

---@return number
function Queue:size()
    return #self.data
end

---@return any|nil
function Queue:last()
    return self.data[#self.data]
end

---@return nil|any
function Queue:peek()
    return #self.data > 0 and self.data[1] or nil
end

---@param item any
---@return any
function Queue:push(item)
  return table.insert(self.data, item)
end

return Queue