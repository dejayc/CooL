--[[ CooL( Corona Object-Oriented Lua )
     https://github.com/dejayc/CooL
     Copyright 2011 Dejay Clayton

     All use of this file must comply with the Apache License,
     Version 2.0, under which this file is licensed:

     http://www.apache.org/licenses/LICENSE-2.0 --]]

local CLASSPATH = require( "classpath" )

local FrameworkConfig = autoextend( CLASSPATH.CooL.Config, packagePath ( ... ) )

local defaultScalingAxis = "maxResScale"

function FrameworkConfig:getScalingAxis( useDefaultIfNil )
    local scalingAxis = self:getValue( "display", "scaling", "axis" )

    if ( scalingAxis == nil and
         ( useDefaultIfNil or useDefaultIfNil == nil ) )
    then
        scalingAxis = self:getDefaultScalingAxis()
    end

    return scalingAxis
end

function FrameworkConfig:getDefaultScalingAxis()
    return defaultScalingAxis
end

function FrameworkConfig:getStatusBar()
    return self:getValue( "display", "statusBar" )
end

return FrameworkConfig
