OS_PATH_SEP = package.config:sub( 1, 1 )

local CooL = "Classes" .. OS_PATH_SEP .. "CooL" .. OS_PATH_SEP

return {
    App = CooL .. "App",
    Config = CooL .. "AppConfig",
    Class = CooL .. "Class",
    Data = CooL .. "Data",
    Display = CooL .. "Display",
}
