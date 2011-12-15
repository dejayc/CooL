--[[ CooL( Corona Object-Oriented Lua )
     https://github.com/dejayc/CooL
     Copyright 2011 Dejay Clayton

     All use of this file must comply with the Apache License,
     Version 2.0, under which this file is licensed:

     http://www.apache.org/licenses/LICENSE-2.0 --]]

local CLASSPATH = require( "classpath" )
local Data = require( CLASSPATH.CooL.Data )

local Config = class( { className = "Config" } )

function Config:init( values )
    self:setValues( values )
end

function Config:getValues()
    return self.values
end

function Config:setValues( values )
    self.values = values
end

function Config:getValue( ... )
    return Data.selectByNestedIndex( self.getValues(), ... )
end

return Config
