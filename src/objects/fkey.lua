
local Key = require('src.objects.key')

---@class FKey : Key
--- F key specifications
local FKey =  Key:extend()

function FKey:new(area, config)
    Key.new(self, area, config, assets.config.fKey)
end


return FKey