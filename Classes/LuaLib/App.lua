local CLASSPATH = require( "classpath" )
local Class = require( CLASSPATH.LuaLib.Class )

local App = Class:extend( { className = "App" } )

function App:init( appConfig )
    self.appConfig = appConfig
    self:initDisplay()
end

function App:getConfigSettingForStatusBar()
    local objRef = self.appConfig
    if ( not objRef ) then return false end

    objRef = objRef.LuaLib
    if ( not objRef ) then return false end

    objRef = objRef.appConfig
    if ( not objRef ) then return false end

    objRef = objRef.display
    if ( not objRef ) then return false end

    objRef = objRef.statusBar
    return objRef
end

function App:initDisplay()
    local statusBar = self:getConfigSettingForStatusBar()
    io.write "statusBar is: "
    print( statusBar )

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

return App
