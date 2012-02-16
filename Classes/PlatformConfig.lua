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

function CLASS:init( ... )
    self.super.init( self, ... )
end

function CLASS:getImageSuffix()
    return self:getValue( false, "content", "imageSuffix" )
end

function CLASS:hasImageSuffix()
    return self:hasValue( "content", "imageSuffix" )
end

return CLASS
