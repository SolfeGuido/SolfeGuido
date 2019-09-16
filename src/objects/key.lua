
local Entity = require('src.entity')

local Key = Entity:extend()


function Key:new(area, id, config)
    Entity.new(self, area, id)
    self.config = config
    self.image = Resources.getImage(self.config.image)
end

function Key:draw()

end

return Key