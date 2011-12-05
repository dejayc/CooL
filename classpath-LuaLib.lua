OS_PATH_SEP = package.config:sub( 1, 1 )

local LuaLib = "Classes" .. OS_PATH_SEP .. "LuaLib" .. OS_PATH_SEP

return {
    App = LuaLib .. "App",
    Class = LuaLib .. "Class",
    Data = LuaLib .. "Data",
}
