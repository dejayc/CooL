local CLASSPATH = require( "classpath" )
local Class = require( CLASSPATH.LuaLib.Class )
local Data = require( CLASSPATH.LuaLib.Data )

local App = Class:extend( { className = "App" } )

function App:init( appConfig )
    self.appConfig = appConfig
    self:initDisplay()
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
end

function App:getAppConfig()
    return self.appConfig
end

function App:getDisplayHeight()
    return display.viewableContentHeight / display.contentScaleY
end

function App:getDisplayWidth()
    return display.viewableContentWidth / display.contentScaleX
end

return App
