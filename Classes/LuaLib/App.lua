local CLASSPATH = require( "classpath" )
local Class = require( CLASSPATH.LuaLib.Class )
local Data = require( CLASSPATH.LuaLib.Data )

local App = Class:extend( { className = "App" } )

local defaultScalingAxis = "screenResMax"
local defaultScalingThreshold = 100

function App:init( appConfig )
    self.appConfig = appConfig
    self:initDisplay()
    self:onOrientationChange()
end

function App:getConfigSettingForScalingAxis()
    return Data.selectByNestedIndex( self,
        "appConfig", "LuaLib", "appConfig", "display", "scaling", "axis" )
end

function App:getConfigSettingForScalingThreshold()
    return Data.selectByNestedIndex( self,
        "appConfig", "LuaLib", "appConfig", "display", "scaling", "threshold" )
end

function App:getConfigSettingForStatusBar()
    return Data.selectByNestedIndex( self,
        "appConfig", "LuaLib", "appConfig", "display", "statusBar" )
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

function App:onOrientationChange( event )
    io.write "Changing orientation to: "
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

    local scalingFactor, scalingMode = self:getDisplayScale()

    io.write "Scaling mode: "
    print( scalingMode )

    io.write "(displayScale, dynamicScale): ("
    io.write( scalingFactor )
    io.write ", "
    io.write( 1 / scalingFactor )
    print ")"
end

function App:getAppConfig()
    return self.appConfig
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
    local scalingAxis = self:getConfigSettingForScalingAxis()
    if ( scalingAxis == nil ) then
        scalingAxis = defaultScalingAxis
    end

    local scalingThreshold = self:getConfigSettingForScalingThreshold()
    if ( scalingThreshold == nil ) then
        scalingThreshold = defaultScalingThreshold
    end

    local scalingMode = scalingAxis
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
            scalingMode = scalingAxis ..
                " [" .. system.orientation .. " = landscape]"
            scalingFactor = heightScale
        else
            scalingMode = scalingAxis ..
                " [" .. system.orientation .. " = portrait]"
            scalingFactor = widthScale
        end
    elseif ( scalingAxis == "screenWidth" ) then
        if ( ( system.orientation == "landscapeLeft" ) or
             ( system.orientation == "landscapeRight" ) )
        then
            scalingMode = scalingAxis ..
                " [" .. system.orientation .. " = landscape]"
            scalingFactor = widthScale
        else
            scalingMode = scalingAxis ..
                " [" .. system.orientation .. " = portrait]"
            scalingFactor = heightScale
        end
    end

    return scalingFactor, scalingMode
end

function App:getDynamicScale()
    local scalingFactor, scalingMode = self:getDisplayScale()
    return 1 / scalingFactor, scalingMode
end

function App:getDynamicScaleSuffix()
    return
end

return App
