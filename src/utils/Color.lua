

---@class Color
---@field public clone function
local Color = {}

local order = {
    r = 1, g = 2, b = 3, a = 4
}

function Color:new(r, g, b, a)
    self.r = r or 1
    self.g = g or 1
    self.b = b or 1
    self.a = a or 1
end

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

function Color:__index(k)
    if order[k] then
        return rawget(self, order[k])
    else
        return rawget(Color, k)
    end
end


Color = setmetatable(Color, {
    __call = function(table, ...)
        local color = setmetatable({}, table)
        color:new(...)
        return color
    end
})


---@type Color
Color.black = Color(0, 0, 0, 1)
---@type Color
Color.white = Color()
---@type Color
Color.transparent = Color(0, 0, 0, 0)
---@type Color
Color.stripe = Color(0.64, 0.77, 0.91, 0.91)
---@type Color
Color.watchStart = Color(0, 0.5, 0)
---@type Color
Color.watchEnd = Color(0.5, 0 ,0)

Color.gray = function(gray)
    return Color(gray, gray, gray, 1)
end

return Color