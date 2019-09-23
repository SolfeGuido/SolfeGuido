
local Key = require('src.objects.key')

---@class FKey : Key
--- F key specifications
local FKey =  Key:extend()

function FKey:new(area, id, config)
    Key.new(self, area, id, config, assets.config.fKey)
end


return FKey