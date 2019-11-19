

---@class Color
---@field public clone function
local Color = {}

local order = {
    r = 1, g = 2, b = 3, a = 4
}

---@param r number between 0 and 1
---@param g number between 0 and 1
---@param b number between 0 and 1
---@param a number between 0 and 1
function Color:new(r, g, b, a)
    self.r = r or 1
    self.g = g or 1
    self.b = b or 1
    self.a = a or 1
end

---@return Color the cloned version of the color
function Color:clone()
    return Color(unpack(self))
end

function Color:__newindex(k, v)
    if order[k] then
        rawset(self, order[k], v)
    else
        rawset(self, k, v)
    end
end

---@param k string
---@return number
function Color:__index(k)
    if type(k) == "string" and k:match('^[rgba][rgba]?[rgba]?[rgba]?$') then
        local values = {}
        for i = 1, #k do
            local name = k:sub(i,i)
            if order[name] then
                values[#values+1] = rawget(self, order[name])
            end
        end
        return #values == 1 and values[1] or values
    end
    return rawget(Color, k)
end

---@param r number between 0 and 255
---@param g number between 0 and 255
---@param b number between 0 and 255
---@param a number between 0 and 255
---@return Color a new Color made with the given colors
Color.fromBytes = function(r,g,b,a)
    return Color(love.math.colorFromBytes(r, g, b, a))
end


return setmetatable(Color, {
    __call = function(table, ...)
        local color = setmetatable({}, table)
        table.new(color, ...)
        return color
    end}
)