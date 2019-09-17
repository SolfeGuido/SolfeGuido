
local Key = require('src.objects.key')

local FKey =  Key:extend()

function FKey:new(area, id)
    Key.new(self, area, id, assets.config.fKey)
end


return FKey