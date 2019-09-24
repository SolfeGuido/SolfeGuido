
local Key = require('src.objects.key')

---@class GKey : Key
--- G Key specifications
local GKey =  Key:extend()

function GKey:new(area, config)
    Key.new(self, area, config, assets.config.gKey)
end

return GKey