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
    return Data.roundNumber (
        display.viewableContentHeight / display.contentScaleY, 2 )
end

function Display:getDisplayWidth()
    return Data.roundNumber (
        display.viewableContentWidth / display.contentScaleX, 2 )
end

function Display:getDisplayScale()
    if ( self.memoized.displayScale [ system.orientation ] ~= nil ) then
        return self.memoized.displayScale [ system.orientation ]
    end

    local scalingAxis = self:getConfig():getScalingAxis()
    if ( scalingAxis == nil ) then
        scalingAxis = self:getConfig():getDefaultScalingAxis()
    end

    local scalingFactor = 1
    local height = self:getDisplayHeight()
    local heightScale = display.contentScaleY
    local width = self:getDisplayWidth()
    local widthScale = display.contentScaleX

    if ( scalingAxis == "screenResMax" ) then
        if ( height > width ) then
            scalingFactor = heightScale
        else
            scalingFactor = widthScale
        end
    elseif ( scalingAxis == "screenResMin" ) then
        if ( height < width ) then
            scalingFactor = heightScale
        else
            scalingFactor = widthScale
        end
    elseif ( scalingAxis == "contentScaleMax" ) then
        if ( heightScale > widthScale ) then
            scalingFactor = widthScale
        else
            scalingFactor = heightScale
        end
    elseif ( scalingAxis == "contentScaleMin" ) then
        if ( heightScale < widthScale ) then
            scalingFactor = widthScale
        else
            scalingFactor = heightScale
        end
    elseif ( scalingAxis == "contentHeight" ) then
        scalingFactor = heightScale
    elseif ( scalingAxis == "contentWidth" ) then
        scalingFactor = widthScale
    elseif ( scalingAxis == "screenHeight" ) then
        if ( ( system.orientation == "landscapeLeft" ) or
             ( system.orientation == "landscapeRight" ) )
        then
            scalingFactor = heightScale
        else
            scalingFactor = widthScale
        end
    elseif ( scalingAxis == "screenWidth" ) then
        if ( ( system.orientation == "landscapeLeft" ) or
             ( system.orientation == "landscapeRight" ) )
        then
            scalingFactor = widthScale
        else
            scalingFactor = heightScale
        end
    end

    self.memoized.displayScale [ system.orientation ] = scalingFactor
    return scalingFactor 
end

function Display:getDynamicScale()
    return 1 / self:getDisplayScale()
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

return Display
