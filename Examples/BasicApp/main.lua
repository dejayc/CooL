--[[ CooL( Corona Object-Oriented Lua )
     https://github.com/dejayc/CooL
     Copyright 2011 Dejay Clayton

     All use of this file must comply with the Apache License,
     Version 2.0, under which this file is licensed:

     http://www.apache.org/licenses/LICENSE-2.0 --]]

local CLASSPATH = require( "classpath" )

io.flush()
print( string.format( [[
Please make sure that 'config.lua' is symlinked or copied to '%s'!

This basic app isn't very visual, but debugging print statements will reveal
screen statistics when you rotate the hardware in the Corona simulator.
]],
tostring( CLASSPATH.config.platform ) ) )

local platformConfig = new( CLASSPATH.CooL.PlatformConfig )
platformConfig:init( require( CLASSPATH.config.platform ) )

local frameworkConfig = new( CLASSPATH.CooL.FrameworkConfig )
frameworkConfig:init( require( CLASSPATH.config.framework ) )

local app = new( CLASSPATH.CooL.App )
app:init( platformConfig, frameworkConfig )

local spritePath = "Assets/Sprites"
app:getFrameworkConfig():findImageFileNameForScale(
    "Square4.png", spritePath, nil, app:getDisplay():getDynamicScale())

app:getPlatformConfig():findImageFileNameForScale(
    "Square3.png", spritePath, nil, app:getDisplay():getDynamicScale())

local function createDisplayReadout()
    local textObj = display.newText(
        "Scale: " .. app:getDisplay():getDynamicScale(),
        0, 0, nil, 10);

    return function( event )
        textObj.text = "Scale: " .. app:getDisplay():getDynamicScale()
    end
end

local displayReadout = createDisplayReadout()
Runtime:addEventListener( "orientation", displayReadout )
displayReadout()
