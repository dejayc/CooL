--[[ CooL( Corona Object-Oriented Lua )
     https://github.com/dejayc/CooL
     Copyright 2011 Dejay Clayton

     All use of this file must comply with the Apache License,
     Version 2.0, under which this file is licensed:

     http://www.apache.org/licenses/LICENSE-2.0 --]]

local BaseLua = require( "Packages.BaseLua.BaseLua" )
local CooL = require( "Packages.CooL.CooL" )

CooL.config = {
    framework = "config-framework",
    platform = "config-platform",
}

local ClassHelper = require( BaseLua.package.ClassHelper )

io.flush()
print( string.format( [[
Please make sure that 'config.lua' is symlinked or copied to '%s'!

This basic app doesn't do much, but demonstrates how various objects within
the framework should be constructed and invoked.
]],
tostring( CooL.config.platform ) ) )

local platformConfig = ClassHelper.new( CooL.package.PlatformConfig )
platformConfig:init( require( CooL.config.platform ) )

local frameworkConfig = ClassHelper.new( CooL.package.FrameworkConfig )
frameworkConfig:init( require( CooL.config.framework ) )

local app = ClassHelper.new( CooL.package.BaseApp )
app:init( platformConfig, frameworkConfig )

local spriteSheetDataPath, spriteSheetDataFile, spriteSheetDataScale =
    app:getDisplayManager():findFileByScale(
        "SwapBlocks-Blocks-1.lua", "Assets/Sprites" )

local spriteSheetImagePath, spriteSheetImageFile, spriteSheetImageScale =
    app:getDisplayManager():findFileByScale(
        "SwapBlocks-Blocks-1.png", "Assets/Sprites" )

--[[
local spriteSheet = ClassHelper.new( CLASSPATH.CooL.SpriteSheet )
spriteSheet:prepare(
    spriteSheetDataPath .. spriteSheetDataFile, 
    spriteSheetImagePath .. spriteSheetImageFile )

spriteSheet:load()
local sprite = spriteSheet:getSprite( "block-blue-1x1" )
--]]
