local CLASSPATH = require( "classpath" )
local Class = require( CLASSPATH.LuaLib.Class )
local Data = require( CLASSPATH.LuaLib.Data )
local Display = require( CLASSPATH.LuaLib.Display )

local App = Class:extend( { className = "App" } )

local defaultScalingAxis = "screenResMax"

function App:init( appConfig )
    io.flush()

    self:setAppConfig( appConfig )
    self:setDisplay( Display:new() )
    self:getDisplay():init( self )

    Runtime:addEventListener( "orientation",
        function( event ) self:onOrientationChange( event ) end
    )
end

function App:onOrientationChange( event )
    -- TODO: Remove
    self.getDisplay():debugScreenMetrics()
end

function App:getAppConfig()
    return self.appConfig
end

function App:setAppConfig( appConfig )
    self.appConfig = appConfig

    if (self:getDisplay() ~= nil ) then
        self:getDisplay():refreshAppConfig()
    end
end

function App:getConfigSettingForScalingAxis( self )
    return Data.selectByNestedIndex( self,
        "appConfig", "LuaLib", "application", "display", "scaling", "axis" )
end

function App:getConfigSettingDefaultForScalingAxis( self )
    return defaultScalingAxis
end

function App:getConfigSettingForStatusBar()
    return Data.selectByNestedIndex( self,
        "appConfig", "LuaLib", "application", "display", "statusBar" )
end

function App:getDisplay()
    return self.display
end

function App:setDisplay( display )
    self.display = display
end

return App
