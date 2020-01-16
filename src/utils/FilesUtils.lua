local json = require('lib.json')

local FilesUtils = {}

---@param fileName string
---@param compressionType string
---@return table|nil table if file was found and correctly read, nil otherwise
function FilesUtils.readCompressedData(fileName, compressionType, default)
    if love.filesystem.getInfo(fileName, 'file') then
        return json.decode(love.data.decompress('string', compressionType, love.filesystem.read(fileName)))
    end
    return default
end

---@param fileName string
---@param compressionType string
---@param data table
---@return boolean,string success and error message if necessary
function FilesUtils.writeCompressedData(fileName, compressionType, data)
    local success, message = love.filesystem.write(
        fileName, love.data.compress(
                    'data',
                    compressionType,
                    json.encode(data)
                )
    )
    if not success then error(message) end
end

---@param fileName string
---@return table|nil read data if any, nil otherwise
function FilesUtils.readData(fileName, default)
    if love.filesystem.getInfo(fileName, 'file') then
        return json.decode(love.filesystem.read(fileName))
    end
    return default
end

---@param fileName string
---@param data table
---@return boolean, string success and error message if necessary
function FilesUtils.writeData(fileName, data)
    local success, message = love.filesystem.write(fileName, json.encode(data))
    if not success then error(message) end
end

return FilesUtils