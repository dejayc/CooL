--[[ CooL( Corona Object-Oriented Lua )
     https://github.com/dejayc/CooL
     Copyright 2011 Dejay Clayton

     All use of this file must comply with the Apache License,
     Version 2.0, under which this file is licensed:

     http://www.apache.org/licenses/LICENSE-2.0 --]]

local CLASSPATH = require( "classpath" )

local Data = {}

-- Thanks to http://stackoverflow.com/a/664611/111948
-- Thanks to http://lua-users.org/wiki/CopyTable
function Data.copy( object )
    if ( type( object ) ~= "table" ) then
        return object
    end

    local copy = {}
    for index, value in pairs( object ) do
        copy[ index ] = value
    end

    return setmetatable( copy, getmetatable( object ) )
end

-- Thanks to http://lua-users.org/wiki/CopyTable
function Data.copyDeep( table )
    local lookupTable = {}

    local function _copy( object )
        if ( type( object ) ~= "table" ) then
            return object
        end

        if ( lookupTable[ object ] ) then
            return lookupTable[ object ]
        end

        local copy = {}
        lookupTable[ object ] = copy

        for index, value in pairs( object ) do
            copy[ _copy( index) ] = _copy( value )
        end

        return setmetatable( copy, getmetatable( object ) )
    end

    return _copy( object )
end

function Data.getDefault( target, default )
    if ( target ~= nil ) then return target end
    return default
end

function Data.getDefaultIf( target, default, _if )
    if ( not _if ) then return target end
    return Data.getDefault( target, default )
end

function Data.ite( _if, _then, _else )
    if ( _if ) then return _then end
    return _else
end

-- Thanks to http://lua-users.org/wiki/SimpleRound
function Data.roundNumber( num, idp )
    local mult = 10^( idp or 0 )
    return math.floor( num * mult + 0.5 ) / mult
end

function Data.selectByNestedIndex( targetTable, ... )
    if ( targetTable == nil ) then return nil end

    local objRef = targetTable

    for i, v in ipairs( arg ) do
        objRef = objRef [ v ]
        if ( objRef == nill ) then return nill end
    end

    return objRef
end

-- Thanks to http://lua-users.org/wiki/FuncTables
function Data.memoize( fn, self )
    fn = fn or function( x ) return nil end

    if ( self == nil ) then
    return setmetatable( {},
    {
        __index = function( table, key )
            key = key or ""
            local value = fn( key )
            table[ key ] = value
            return value
        end,
        __call  = function( table, key )
            return table[ key ]
        end
    } )
    end

    return setmetatable( {},
    {
        __index = function( table, key )
            key = key or ""
            local value = fn( self, key )
            table[ key ] = value
            return value
        end,
        __call  = function( table, self, key )
            key = key or ""
            return table[ key ]
        end
    } )
end

return Data
