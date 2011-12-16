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

function CLASS:init( app )
    self.memoized = self.memoized or {}
    self:setApp( app )

    local statusBar = self:getApp():getFrameworkConfig():getStatusBar()

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

function CLASS:debugScreenMetrics()
    io.write "Orientation is now: "
    print( system.orientation )

    io.write "(displayWidth, displayHeight): ("
    io.write( self.getDisplayWidth() )
    io.write ", "
    io.write( self.getDisplayHeight() )
    print ")"

    io.write "display.(contentScaleX, contentScaleY): ("
    io.write( display.contentScaleX )
    io.write ", "
    io.write( display.contentScaleY )
    print ")"

    io.write "(displayScale, dynamicScale): ("
    io.write( self:getDisplayScale() )
    io.write ", "
    io.write( self:getDynamicScale() )
    print ")"

    io.write "imageSuffixesForScale: ("
    io.write( table.concat(
        self:getApp():getPlatformConfig():getImageSuffixesForScale(
            self:getDynamicScale() ), ", " ) )
    print ")"
end

function CLASS:getApp()
    return self.app
end

function CLASS:setApp( app )
    self.app = app
    self:refreshConfig()
end

function CLASS:refreshConfig()
    self.memoized.displayScale =  nil
end

function CLASS.getDisplayWidth()
    return Data.roundNumber(
        display.viewableContentWidth / display.contentScaleX, 0 )
end

function CLASS.getDisplayHeight()
    return Data.roundNumber(
        display.viewableContentHeight / display.contentScaleY, 0 )
end

function CLASS:getDisplayScale()
    local orientation = CLASS.getEffectiveOrientation()

    if ( self.memoized.displayScale ~= nil ) then
        return self.memoized.displayScale
    end

    local scalingAxis = self:getApp():getFrameworkConfig():getScalingAxis()

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

    self.memoized.displayScale = scalingFactor
    return scalingFactor 
end

function CLASS:getDynamicScale()
    return Data.roundNumber( 1 / self:getDisplayScale(), 3 )
end

function CLASS.getEffectiveOrientation()
    if ( ( system.orientation == "landscapeLeft" ) or
         ( system.orientation == "landscapeRight" ) )
    then
        return "landscape"
    else
        return "portrait"
    end
end

return CLASS
