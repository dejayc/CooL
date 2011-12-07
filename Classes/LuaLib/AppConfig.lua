local CLASSPATH = require( "classpath" )
local Class = require( CLASSPATH.LuaLib.Class )
local Data = require( CLASSPATH.LuaLib.Data )

local Config = Class:extend( { className = "Config" } )

local defaultScalingAxis = "screenResMax"

function Config:init( configSettings )
    self:setConfigSettings( configSettings )
end

function Config:getScalingAxis()
    return Data.selectByNestedIndex( self:getConfigSettings(),
        "LuaLib", "application", "display", "scaling", "axis" )
end

function Config:getDefaultScalingAxis()
    return defaultScalingAxis
end

function Config:getStatusBar()
    return Data.selectByNestedIndex( self:getConfigSettings(),
        "LuaLib", "application", "display", "statusBar" )
end

function Config:getConfigSettings()
    return self.configSettings
end

function Config:setConfigSettings( configSettings )
    self.configSettings = configSettings
end

return Config
