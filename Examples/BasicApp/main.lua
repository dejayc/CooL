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

This basic app doesn't do much, but demonstrates how various objects within
the framework should be constructed and invoked.
]],
tostring( CLASSPATH.config.platform ) ) )

local platformConfig = new( CLASSPATH.CooL.PlatformConfig )
platformConfig:init( require( CLASSPATH.config.platform ) )

local frameworkConfig = new( CLASSPATH.CooL.FrameworkConfig )
frameworkConfig:init( require( CLASSPATH.config.framework ) )

local app = new( CLASSPATH.CooL.App )
app:init( platformConfig, frameworkConfig )

printf( "frameworkDisplay:displayScale [%s]",
    tostring( app:getFrameworkDisplay():getDisplayScale() ) )
printf( "platformDisplay:displayScale [%s]",
    tostring( app:getPlatformDisplay():getDisplayScale() ) )

local spriteDir = "Assets/Sprites"
local imageFile = "Square2.png"

printf( "frameworkDisplay:findImageFileNameForScale [%s]",
    tostring( app:getFrameworkDisplay():findImageFileNameForScale(
        imageFile, spriteDir ) ) )
printf( "platformDisplay:findImageFileNameForScale [%s]",
    tostring( app:getPlatformDisplay():findImageFileNameForScale(
        imageFile, spriteDir ) ) )

local function debugScreenMetrics()
    io.write "Orientation is now: "
    print( system.orientation )

    io.write "(displayWidth, displayHeight): ("
    io.write( app:getDisplay():getDisplayWidth() )
    io.write ", "
    io.write( app:getDisplay():getDisplayHeight() )
    print ")"

    io.write "display.(contentScaleX, contentScaleY): ("
    io.write( display.contentScaleX )
    io.write ", "
    io.write( display.contentScaleY )
    print ")"

    io.write "(displayScale, dynamicScale): ("
    io.write( app:getDisplay():getDisplayScale(
        frameworkConfig:getScalingAxis() ) )
    io.write ", "
    io.write( app:getDisplay():getDynamicScale(
        frameworkConfig:getScalingAxis() ) )
    print ")"

    io.write "imageSuffixesForScale: ("
    io.write( table.concat(
        app:getPlatformConfig():getImageSuffixesForScale(
            app:getDisplay():getDynamicScale(
                frameworkConfig:getScalingAxis() ) ), ", " ) )
    print ")"
end

local function createDisplayReadout()
    local textObj = display.newText(
        "Scale: " .. app:getFrameworkDisplay():getDynamicScale(),
        0, 0, nil, 10);

    return function( event )
        textObj.text = "Scale: " .. app:getFrameworkDisplay():
            getDynamicScale()
    end
end

local displayReadout = createDisplayReadout()
Runtime:addEventListener( "orientation", displayReadout )
displayReadout()
