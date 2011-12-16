--[[ CooL( Corona Object-Oriented Lua )
     https://github.com/dejayc/CooL
     Copyright 2011 Dejay Clayton

     All use of this file must comply with the Apache License,
     Version 2.0, under which this file is licensed:

     http://www.apache.org/licenses/LICENSE-2.0 --]]

local CLASSPATH = require( "classpath" )
local Data = require( CLASSPATH.CooL.Data )

local CLASS = autoclass( packagePath( ... ) )

function CLASS:init( values )
    self:setValues( values )
end

function CLASS:getValues()
    return self.values
end

function CLASS:setValues( values )
    self.values = values
end

function CLASS:getValue( ... )
    return Data.selectByNestedIndex( self:getValues(), ... )
end

return CLASS
