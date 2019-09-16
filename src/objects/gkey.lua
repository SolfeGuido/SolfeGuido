
local Key = require('src.objects.key')

local GKey =  Key:extend()

function GKey:new(area, id, config)
    Key.new(self, area, id, CONST.gKey)
end


return GKey