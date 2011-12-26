--[[ CooL( Corona Object-Oriented Lua )
     https://github.com/dejayc/CooL
     Copyright 2011 Dejay Clayton

     All use of this file must comply with the Apache License,
     Version 2.0, under which this file is licensed:

     http://www.apache.org/licenses/LICENSE-2.0 --]]

local CLASSPATH = require( "classpath" )
local Data = require( CLASSPATH.CooL.Data )
local File = require( CLASSPATH.CooL.File )

local CLASS = autoclass( packagePath( ... ) )

function CLASS:init()
end

function CLASS.getDisplayWidth()
    return Data.roundNumber(
        display.viewableContentWidth / display.contentScaleX, 0 )
end

function CLASS.getDisplayHeight()
    return Data.roundNumber(
        display.viewableContentHeight / display.contentScaleY, 0 )
end

-- Abstract, must be defined in subclasses in order to work
function CLASS:getDisplayScale()
    error( "Illegal call to abstract function 'Display:getDisplayScale'" )
end

function CLASS:getDynamicScale( ... )
    return Data.roundNumber( 1 / self:getDisplayScale( ... ), 3 )
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

-- Abstract, must be defined in subclasses in order to work
function CLASS:findImage()
    error( "Illegal call to abstract function 'Display:findImageForScale'" )
end

function CLASS:getImage(
    imageFileName, imageRootPath, xPos, yPos, coronaPathType
)
    local imagePath, imageScale = self:findImage(
        imageFileName, imageRootPath, coronaPathType )

    if ( imagePath ~= nil ) then
        local image = display.newImage( imagePath, xPos, yPos )
        image.xScale = 1 / imageScale
        image.yScale = 1 / imageScale
        return image
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
