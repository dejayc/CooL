--[[ CooL( Corona Object-Oriented Lua )
     https://github.com/dejayc/CooL
     Copyright 2011 Dejay Clayton

     All use of this file must comply with the Apache License,
     Version 2.0, under which this file is licensed:

     http://www.apache.org/licenses/LICENSE-2.0 --]]

function cast( name, ... )
    return require( name ):cast( ... )
end

function new( name, ... )
    return require( name ):new( ... )
end

function extend( name, ... )
    return require( name ):extend( ... )
end
