local CLASSPATH = require( "classpath" )
local Class = require( CLASSPATH.LuaLib.Class )

local App = Class:extend( { className = "App" } )

function App:init( appConfig )
    self.appConfig = appConfig
    self:initDisplay()
end

function App:inspectConfigForHideStatusBar()
    local objRef = self.appConfig
    if ( not objRef ) then return false end

    objRef = objRef.LuaLib
    if ( not objRef ) then return false end

    objRef = objRef.appConfig
    if ( not objRef ) then return false end

    objRef = objRef.display
    if ( not objRef ) then return false end

    objRef = objRef.hideStatusBar
    return objRef
end

function App:initDisplay()
    local appConfig = self.appConfig
    if ( self:inspectConfigForHideStatusBar() )
    then
        display.setStatusBar( display.HiddenStatusBar )
    end
end

function App:getAppConfig()
    return self.appConfig
end

return App
