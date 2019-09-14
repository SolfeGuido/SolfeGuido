
local Class = require('lib.class')


---@class Resources
local Resources = Class:extend()

function Resources:new()
    -- load pictures
    self.images = {}
    self:loadImages()
end

function Resources:loadImages()
    local items = love.filesystem.getDirectoryItems(CONST.imagesPath)
    for _,filename in pairs(items) do
        local match = string.match(filename, "(.+)%..+$")
        print("loading " .. match)
        self.images[match] = love.graphics.newImage(CONST.imagesPath .. '/' .. filename)
    end
end

function Resources:getImage(img)

end


return Resources