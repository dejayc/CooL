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

function CLASS:init( statusBar )
    self:setStatusBar( statusBar )
end

function CLASS.getDisplayWidth()
    return Data.roundNumber(
        display.viewableContentWidth / display.contentScaleX, 0 )
end

function CLASS.getDisplayHeight()
    return Data.roundNumber(
        display.viewableContentHeight / display.contentScaleY, 0 )
end

function CLASS:getDisplayScale( scalingAxis, orientation )
    local orientation = CLASS.getEffectiveOrientation()

    local scalingFactor = nil
    local height = CLASS.getDisplayHeight()
    local heightScale = display.contentScaleY
    local width = CLASS.getDisplayWidth()
    local widthScale = display.contentScaleX

    if ( scalingAxis == "minScale" ) then
        if ( heightScale < widthScale ) then
            scalingFactor = widthScale
        else
            scalingFactor = heightScale
        end
    elseif ( scalingAxis == "maxScale" ) then
        if ( heightScale > widthScale ) then
            scalingFactor = widthScale
        else
            scalingFactor = heightScale
        end
    elseif ( scalingAxis == "minResScale" ) then
        if ( height < width ) then
            scalingFactor = heightScale
        else
            scalingFactor = widthScale
        end
    elseif ( scalingAxis == "maxResScale" ) then
        if ( height > width ) then
            scalingFactor = heightScale
        else
            scalingFactor = widthScale
        end
    elseif ( scalingAxis == "widthScale" ) then
        if ( orientation == "landscape" )
        then
            scalingFactor = widthScale
        else
            scalingFactor = heightScale
        end
    elseif ( scalingAxis == "heightScale" ) then
        if ( orientation == "landscape" )
        then
            scalingFactor = heightScale
        else
            scalingFactor = widthScale
        end
    end
    return scalingFactor 
end

function CLASS:getDynamicScale( scalingAxis, orientation )
    return Data.roundNumber(
        1 / self:getDisplayScale( scalingAxis, orientation ), 3 )
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

function CLASS:setStatusBar( statusBar )
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
