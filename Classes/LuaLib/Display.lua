local CLASSPATH = require( "classpath" )
local Class = require( CLASSPATH.LuaLib.Class )
local Config = require( CLASSPATH.LuaLib.Config )
local Data = require( CLASSPATH.LuaLib.Data )

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

function Display:getDynamicImageSuffix()
    local dynamicScale = self:getDynamicScale()

    if ( self.memoized.dynamicImageSuffix [ dynamicScale ] ~= nil )
    then
        return self.memoized.dynamicImageSuffix [ dynamicScale ]
    end

    local imageSuffixes = self:getConfig():getImageSuffix()
    local imageSuffix = ""

    self.memoized.dynamicImageSuffix [ dynamicScale ] = imageSuffix 
    return imageSuffix
end

return Display
