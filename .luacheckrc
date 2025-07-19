std = "love+lua53+luajit"
read_globals = { "Vars", "assets", "tr", "love.arg", "love.graphics.isActive" }
-- TODO: Remove this when luacheck has support for love 12
globals = { "SOUNDTAG", "love.handlers", "love.graphics.newTextBatch" }
ignore = { "212/self" }
include_files = { "src" }

