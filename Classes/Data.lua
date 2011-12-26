--[[ CooL( Corona Object-Oriented Lua )
     https://github.com/dejayc/CooL
     Copyright 2011 Dejay Clayton

     All use of this file must comply with the Apache License,
     Version 2.0, under which this file is licensed:

     http://www.apache.org/licenses/LICENSE-2.0 --]]

local CLASSPATH = require( "classpath" )

local CLASS = {}

-- Thanks to http://stackoverflow.com/a/664611/111948
-- Thanks to http://lua-users.org/wiki/CopyTable
function CLASS.copy( object )
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
function CLASS.copyDeep( targetTable )
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

    return _copy( targetTable )
end

function CLASS.getDefault( target, default )
    if ( target ~= nil ) then return target end
    return default
end

function CLASS.getDefaultIf( target, default, _if )
    if ( not _if ) then return target end
    return Data.getDefault( target, default )
end

function CLASS.getNumericKeysSorted( targetTable )
    local sorted = {}
    for index, value in pairs( targetTable ) do
        if ( type( index ) == "number" ) then
            table.insert( sorted, index )
        end
    end

    table.sort( sorted )
    return sorted
end

function CLASS.isNonEmptyTable( targetTable )
    return
        type( targetTable ) == "table" and
        table.getn( targetTable ) > 0
end

function CLASS.ite( _if, _then, _else )
    if ( _if ) then return _then end
    return _else
end

-- Thanks to http://lua-users.org/wiki/FuncTables
function CLASS.memoize( fn, self )
    fn = fn or function( x ) return nil end

    if ( self == nil ) then
    return setmetatable( {},
    {
        __index = function( targetTable, key )
            key = key or ""
            local value = fn( key )
            targetTable[ key ] = value
            return value
        end,
        __call  = function( targetTable, key )
            return targetTable[ key ]
        end
    } )
    end

    return setmetatable( {},
    {
        __index = function( targetTable, key )
            key = key or ""
            local value = fn( self, key )
            targetTable[ key ] = value
            return value
        end,
        __call  = function( targetTable, self, key )
            key = key or ""
            return targetTable[ key ]
        end
    } )
end

-- Thanks to http://lua-users.org/wiki/SimpleRound
function CLASS.roundNumber( num, idp )
    local mult = 10^( idp or 0 )
    return math.floor( num * mult + 0.5 ) / mult
end

function CLASS.selectByNestedIndex( targetTable, ... )
    if ( targetTable == nil ) then return nil end

    local objRef = targetTable

    for argIndex, argValue in ipairs( arg ) do
        objRef = objRef[ argValue ]
        if ( objRef == nil ) then return nil end
    end

    return objRef
end

function CLASS.updateByNestedIndex( value, targetTable, ... )
    if ( targetTable == nil ) then return nil end

    local objRef = targetTable
    local pathDepth = table.getn( arg )

    for argIndex, argValue in ipairs( arg ) do
        if ( argIndex == pathDepth ) then
            objRef[ argValue ] = value
            break
        end
        if ( objRef[ argValue ] == nil ) then
            objRef[ argValue ] = {}
        end
        objRef = objRef[ argValue ]
    end

    return objRef
end

return CLASS
