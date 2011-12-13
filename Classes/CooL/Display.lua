--[[ CooL( Corona Object-Oriented Lua )
     https://github.com/dejayc/CooL
     Copyright 2011 Dejay Clayton

     All use of this file must comply with the Apache License,
     Version 2.0, under which this file is licensed:

     http://www.apache.org/licenses/LICENSE-2.0 --]]

local CLASSPATH = require( "classpath" )
local Class = require( CLASSPATH.CooL.Class )
local Config = require( CLASSPATH.CooL.Config )
local Data = require( CLASSPATH.CooL.Data )

local Display = Class:extend( { className = "Display" } )

function Display:init( config )
    self.memoized = self.memoized or {}
    self:setConfig( config )

    local statusBar = self:getConfig():getStatusBar()

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

function Display:debugScreenMetrics()
    io.write "Orientation is now: "
    print( system.orientation )

    io.write "(displayWidth, displayHeight): ("
    io.write( self:getDisplayWidth() )
    io.write ", "
    io.write( self:getDisplayHeight() )
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

    io.write "dynamicImageSuffix: ("
    io.write( table.concat( self:getDynamicImageSuffixes(), "," ) )
    print ")"
end

function Display:getConfig()
    return self.config
end

function Display:setConfig( config )
    self.config = config
    self:refreshConfig()
end

function Display:refreshConfig()
    self.memoized.displayScale = {}
    self.memoized.dynamicImageSuffix = {}
end

function Display:getDisplayHeight()
    return Data.roundNumber(
        display.viewableContentHeight / display.contentScaleY, 0 )
end

function Display:getDisplayWidth()
    return Data.roundNumber(
        display.viewableContentWidth / display.contentScaleX, 0 )
end

function Display:getDisplayScale()
    local orientation = self:getEffectiveOrientation()

    if ( self.memoized.displayScale[ orientation ] ~= nil ) then
        return self.memoized.displayScale [ orientation ]
    end

    local scalingAxis = self:getConfig():getScalingAxis()

    local scalingFactor = 1
    local height = self:getDisplayHeight()
    local heightScale = display.contentScaleY
    local width = self:getDisplayWidth()
    local widthScale = display.contentScaleX

    if ( scalingAxis == "maxResScale" ) then
        if ( height > width ) then
            scalingFactor = heightScale
        else
            scalingFactor = widthScale
        end
    elseif ( scalingAxis == "minResScale" ) then
        if ( height < width ) then
            scalingFactor = heightScale
        else
            scalingFactor = widthScale
        end
    elseif ( scalingAxis == "maxScale" ) then
        if ( heightScale > widthScale ) then
            scalingFactor = widthScale
        else
            scalingFactor = heightScale
        end
    elseif ( scalingAxis == "minScale" ) then
        if ( heightScale < widthScale ) then
            scalingFactor = widthScale
        else
            scalingFactor = heightScale
        end
    elseif ( scalingAxis == "screenWidth" ) then
        if ( orientation == "landscape" )
        then
            scalingFactor = widthScale
        else
            scalingFactor = heightScale
        end
    elseif ( scalingAxis == "screenHeight" ) then
        if ( orientation == "landscape" )
        then
            scalingFactor = heightScale
        else
            scalingFactor = widthScale
        end
    end

    self.memoized.displayScale[ orientation ] = scalingFactor
    return scalingFactor 
end

function Display:getDynamicScale()
    return Data.roundNumber( 1 / self:getDisplayScale(), 3 )
end

function Display:getDynamicImageSuffixes ( scale )
    scale = scale or self:getDynamicScale()

    if ( self.memoized.dynamicImageSuffix [ scale ] ~= nil )
    then
        return self.memoized.dynamicImageSuffix [ scale ]
    end

    local imageSuffixesSorted = self:getConfig():getImageSuffixesSorted()
    local imageSuffixes = {}

    if ( imageSuffixesSorted ~= nil ) then
        if ( scale >= 1 ) then
            for _, entry in ipairs( imageSuffixesSorted ) do
                if ( entry.scale > scale ) then break end

                if ( entry.scale >= 1 ) then
                    table.insert( imageSuffixes, 1, entry.suffix )
                end
            end
        else
            for _, entry in ipairs( imageSuffixesSorted ) do
                if ( entry.scale > 1 ) then break end

                if ( entry.scale >= scale ) then
                    table.insert( imageSuffixes, entry.suffix )
                end
            end
        end
    end

    self.memoized.dynamicImageSuffix [ scale ] = imageSuffixes
    return imageSuffixes
end

function Display:getEffectiveOrientation()
    if ( ( system.orientation == "landscapeLeft" ) or
         ( system.orientation == "landscapeRight" ) )
    then
        return "landscape"
    else
        return "portrait"
    end
end

return Display
