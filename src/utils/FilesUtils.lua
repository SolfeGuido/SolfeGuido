local lume = require('lib.lume')

local FilesUtils = {}

---@param fileName string
---@param compressionType string
---@return table|nil table if file was found and correctly read, nil otherwise
function FilesUtils.readCompressedData(fileName, compressionType)
    if love.filesystem.getInfo(fileName) then
        return lume.deserialize(love.data.decompress('string', compressionType, love.filesystem.read(fileName)))
    end
    return nil
end

---@param fileName string
---@param compressionType string
---@param data table
---@return boolean,string success and error message if necessary
function FilesUtils.writeCompressedData(fileName, compressionType, data)
    return love.filesystem.write(fileName, love.data.compress('data', compressionType, lume.serialize(data)))
end

return FilesUtils