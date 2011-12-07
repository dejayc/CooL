local CLASSPATH = require( "classpath" )
local Class = require( CLASSPATH.LuaLib.Class )
local Data = require( CLASSPATH.LuaLib.Data )

local App = Class:extend( { className = "App" } )

local defaultScalingAxis = "screenResMax"

function App:init( appConfig )
    self:setAppConfig( appConfig )
    self:initState()
    self:initDisplay()
end

function App:initState()
    io.flush()
end

function App:initDisplay()
    local statusBar = self:getConfigSettingForStatusBar()

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

    Runtime:addEventListener( "orientation",
        function( event ) self:onOrientationChange( event ) end
    )
end

function App:debugScreenMetrics()
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

function App:onOrientationChange( event )
    -- TODO: Remove
    self:debugScreenMetrics()
end

function App:getAppConfig()
    return self.appConfig
end

function App:setAppConfig( appConfig )
    self.appConfig = appConfig
    self.memoized = self.memoized or {}
    self.memoized.displayScale = {}
end

function App:getConfigSettingForScalingAxis( self )
    return Data.selectByNestedIndex( self,
        "appConfig", "LuaLib", "appConfig", "display", "scaling", "axis" )
end

function App:getConfigSettingForStatusBar()
    return Data.selectByNestedIndex( self,
        "appConfig", "LuaLib", "appConfig", "display", "statusBar" )
end

function App:getDisplayHeight()
    return Data.roundNumber (
        display.viewableContentHeight / display.contentScaleY, 2 )
end

function App:getDisplayWidth()
    return Data.roundNumber (
        display.viewableContentWidth / display.contentScaleX, 2 )
end

function App:getDisplayScale()
    if ( self.memoized.displayScale [ system.orientation ] ~= nil ) then
        return self.memoized.displayScale [ system.orientation ]
    end

    local scalingAxis = self:getConfigSettingForScalingAxis()
    if ( scalingAxis == nil ) then
        scalingAxis = defaultScalingAxis
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

function App:getDynamicScale()
    return 1 / self:getDisplayScale()
end

function App:getDynamicScaleSuffix()
    return
end

return App
