-- cargo v0.1.1
-- https://github.com/bjornbytes/cargo
-- MIT License
-- Modified and udpated By Azarias

local cargo = {}

local function merge(target, source, ...)
  if not target or not source then return target end
  for k, v in pairs(source) do target[k] = v end
  return merge(target, ...)
end

local la, lf, lg = love.audio, love.filesystem, love.graphics

local function makeSound(path)
  local info = lf.getInfo(path, 'file')
  return la.newSource(path, (info and info.size and info.size < 5e5) and 'static' or 'stream')
end

local function makeFont(path)
  -- Using a cache because the font are used all around the app, no need to released them at any moment
  local cache = {}
  return function(size)
    if cache[size] then return cache[size] end
    local ft =  lg.newFont(path, size)
    cache[size] = ft
    return ft
  end
end

local function loadFile(path)
  return lf.load(path)()
end

cargo.loaders = {
  lua = lf and loadFile,
  png = lg and lg.newImage,
  jpg = lg and lg.newImage,
  dds = lg and lg.newImage,
  ogv = lg and lg.newVideo,
  glsl = lg and lg.newShader,
  mp3 = la and makeSound,
  wav = la and love.sound.newSoundData,
  ogg = la and love.sound.newSoundData,
  txt = lf and lf.read,
  xml = lf and lf.read,
  ttf = lg and makeFont,
  otf = lg and makeFont,
  fnt = lg and lg.newFont
}

function cargo.init(path, parts)
  local loaders = cargo.loaders

  local total = {}

  local start = lf.getDirectoryItems(path, 'directory')
  if not start or #start == 0 then return total end
  local yields = parts / #start
  for _,v in ipairs(start) do
    local vPath = path .. '/' .. v
    local fInfo = lf.getInfo(vPath)
    if fInfo.type == 'file' then
      local fName, extension = string.match(v, '(.+)%.([^.]+)$')
      total[fName] = loaders[extension](vPath)
      coroutine.yield(yields)
    elseif fInfo.type == 'directory' then
      total[v] = cargo.init(vPath, yields)
    end
  end

  return total
end

return cargo