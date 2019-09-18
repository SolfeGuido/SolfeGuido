
local Key = require('src.objects.key')

---@class GKey : Key
--- G Key specifications
local GKey =  Key:extend()

function GKey:new(area, id, config)
    Key.new(self, area, id, assets.config.gKey)
end

return GKey