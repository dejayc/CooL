--[[ CooL( Corona Object-Oriented Lua )
     https://github.com/dejayc/CooL
     Copyright 2011 Dejay Clayton

     All use of this file must comply with the Apache License,
     Version 2.0, under which this file is licensed:

     http://www.apache.org/licenses/LICENSE-2.0 --]]

function cast( target, ... )
    if ( type( target ) == "string" ) then target = require( target ) end
    return target:cast( ... )
end

function class( ... )
    return require( COOL_CLASS_PACKAGE ):extend( ... )
end

function className( packagePath )
    local _, _, name = string.find( packagePath, PACKAGE_CLASS_PATTERN )
    if ( name == nil ) then name = packagePath end
    return name
end

function extend( target, ... )
    if ( type( target ) == "string" ) then target = require( target ) end
    return target:extend( ... )
end

function new( target, ... )
    if ( type( target ) == "string" ) then target = require( target ) end
    return target:new( ... )
end

function packageName( packagePath )
    local _, _, name = string.find( packagePath, PACKAGE_PATH_PATTERN )
    return name
end
