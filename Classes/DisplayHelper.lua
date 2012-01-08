--[[ CooL( Corona Object-Oriented Lua )
     https://github.com/dejayc/CooL
     Copyright 2011 Dejay Clayton

     All use of this file must comply with the Apache License,
     Version 2.0, under which this file is licensed:

     http://www.apache.org/licenses/LICENSE-2.0 --]]

local CLASSPATH = require( "classpath" )
local DataHelper = require( CLASSPATH.CooL.DataHelper )
local FileHelper = require( CLASSPATH.CooL.FileHelper )

local CLASS = {}

function CLASS.getDisplayHeight()
    return DataHelper.roundNumber(
        display.viewableContentHeight / display.contentScaleY, 0 )
end

function CLASS.getDisplayWidth()
    return DataHelper.roundNumber(
        display.viewableContentWidth / display.contentScaleX, 0 )
end

function CLASS.getDisplayScale()
    local heightScale = display.contentScaleY
    local widthScale = display.contentScaleX

    if ( heightScale > widthScale ) then
        return heightScale
    else
        return widthScale
    end
end

function CLASS.getDynamicScale()
    return DataHelper.roundNumber( 1 / CLASS.getDisplayScale(), 3 )
end

function CLASS.getEffectiveOrientation( orientation )
    orientation = orientation or system.orientation

    if ( ( orientation == "landscapeLeft" ) or
         ( orientation == "landscapeRight" ) )
    then
        return "landscape"
    else
        return "portrait"
    end
end

function CLASS.getImageBoundingBox( image )
    xBound = ( image.width * image.xScale ) / 2
    yBound = ( image.height * image.yScale ) / 2

    return {
        -xBound, -yBound,
        xBound, -yBound,
        xBound, yBound,
        -xBound, yBound
    }
end

function CLASS.isImageScaled( image )
    return image.xScale ~= 1 or image.yScale ~= 1
end

function CLASS.setStatusBar( statusBar )
    if ( statusBar == "hidden" )
    then
        display.setStatusBar( display.HiddenStatusBar )
    elseif ( statusBar == "translucent" )
    then
        display.setStatusBar( display.TranslucentStatusBar )
    elseif ( statusBar == "dark" )
    then
        display.setStatusBar( display.DarkStatusBar )
    else
        display.setStatusBar( display.DefaultStatusBar )
    end
end

return CLASS
