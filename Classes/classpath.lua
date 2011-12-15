--[[ CooL( Corona Object-Oriented Lua )
     https://github.com/dejayc/CooL
     Copyright 2011 Dejay Clayton

     All use of this file must comply with the Apache License,
     Version 2.0, under which this file is licensed:

     http://www.apache.org/licenses/LICENSE-2.0 --]]

local _, _, THIS_PACKAGE_PREFIX = string.find( ..., "^(.*%.).-$" )
if ( THIS_PACKAGE_PREFIX == nil ) then THIS_PACKAGE_PREFIX = "" end

-- Globals
COOL_PACKAGE_PREFIX = THIS_PACKAGE_PREFIX
COOL_CLASS_PACKAGE = COOL_PACKAGE_PREFIX .. "Class"
require( THIS_PACKAGE_PREFIX .. "globals" )

-- CooL Classpaths
return {
    App = THIS_PACKAGE_PREFIX .. "App",
    Class = COOL_CLASS_PACKAGE,
    Config = THIS_PACKAGE_PREFIX .. "Config",
    Data = THIS_PACKAGE_PREFIX .. "Data",
    Display = THIS_PACKAGE_PREFIX .. "Display",
    File = THIS_PACKAGE_PREFIX .. "File",
    FrameworkConfig = THIS_PACKAGE_PREFIX .. "FrameworkConfig",
    PlatformConfig = THIS_PACKAGE_PREFIX .. "PlatformConfig",
}
