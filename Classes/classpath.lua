--[[ CooL( Corona Object-Oriented Lua )
     https://github.com/dejayc/CooL
     Copyright 2011 Dejay Clayton

     All use of this file must comply with the Apache License,
     Version 2.0, under which this file is licensed:

     http://www.apache.org/licenses/LICENSE-2.0 --]]

local _, _, INCLUDE_PATH = string.find( ..., "^(.*%.).-$" )
if ( INCLUDE_PATH == nil ) then INCLUDE_PATH = "" end

return {
    App = INCLUDE_PATH .. "App",
    Class = INCLUDE_PATH .. "Class",
    Data = INCLUDE_PATH .. "Data",
    Display = INCLUDE_PATH .. "Display",
    File = INCLUDE_PATH .. "File",
    PlatformConfig = INCLUDE_PATH .. "PlatformConfig",
}
