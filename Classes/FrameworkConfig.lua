--[[ CooL( Corona Object-Oriented Lua )
     https://github.com/dejayc/CooL
     Copyright 2011 Dejay Clayton

     All use of this file must comply with the Apache License,
     Version 2.0, under which this file is licensed:

     http://www.apache.org/licenses/LICENSE-2.0 --]]

local CLASSPATH = require( "classpath" )
local ClassHelper = require( CLASSPATH.CooL.ClassHelper )

local CLASS = ClassHelper.autoextend(
    CLASSPATH.CooL.BaseConfig, ClassHelper.getPackagePath( ... ) )

local defaults = {
    display = {
        scaling = {
            axis = "maxResScale",
        },
        statusBar = "hidden",
    },
}

function CLASS:init( ... )
    self.super.init( self, ... )
    self:setDefaultValues( defaults )
end

function CLASS:getFileLookup()
    return self:getValue( false, "display", "scaling", "fileLookup" )
end

function CLASS:hasFileLookup()
    return self:hasValue( "display", "scaling", "fileLookup" )
end

function CLASS:getScalingAxis( useDefaultIfNil )
    return self:getValue( useDefaultIfNil, "display", "scaling", "axis" )
end

function CLASS:hasScalingAxis()
    return self:hasValue( "display", "scaling", "axis" )
end

function CLASS:getStatusBar()
    return self:getValue( true, "display", "statusBar" )
end

function CLASS:hasStatusBar()
    return self:hasValue( "display", "statusBar" )
end

return CLASS
