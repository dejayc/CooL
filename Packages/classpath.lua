--[[ CooL( Corona Object-Oriented Lua )
     https://github.com/dejayc/CooL
     Copyright 2011 Dejay Clayton

     All use of this file must comply with the Apache License,
     Version 2.0, under which this file is licensed:

     http://www.apache.org/licenses/LICENSE-2.0 --]]

--[[
-------------------------------------------------------------------------------
-- Base 'classpath' file that includes CooL classes and defines certain CooL
-- global variables.

module "classpath.lua"
-------------------------------------------------------------------------------
--]]

-- Define CooL globals, and determine current package path
PACKAGE_CLASS_PATTERN = "^.*%.(.-)$"
PACKAGE_PATH_PATTERN = "^(.*%.).-$"

local _, _, packagePath = string.find( ..., PACKAGE_PATH_PATTERN )
if ( packagePath == nil ) then packagePath = "" end

COOL_PACKAGE_PATH = packagePath
COOL_CLASS_PACKAGE = COOL_PACKAGE_PATH .. "BaseClass"

-- Load CooL 'Globals' file
require( packagePath .. "globals" )

-- CooL Classpaths
return {
    BaseApp = packagePath .. "BaseApp",
    BaseClass = COOL_CLASS_PACKAGE,
    BaseConfig = packagePath .. "BaseConfig",
    ClassHelper = packagePath .. "ClassHelper",
    DataHelper = packagePath .. "DataHelper",
    DisplayHelper = packagePath .. "DisplayHelper",
    DisplayManager = packagePath .. "DisplayManager",
    FileHelper = packagePath .. "FileHelper",
    FrameworkConfig = packagePath .. "FrameworkConfig",
    FrameworkDisplay = packagePath .. "FrameworkDisplay",
    PlatformConfig = packagePath .. "PlatformConfig",
    PlatformDisplay = packagePath .. "PlatformDisplay",
    PlatformFileHelper = packagePath .. "PlatformFileHelper",
    SpriteSheet = packagePath .. "SpriteSheet",
    SpriteSheetData = packagePath .. "SpriteSheetData",
}