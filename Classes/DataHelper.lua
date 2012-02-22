--[[ CooL( Corona Object-Oriented Lua )
     https://github.com/dejayc/CooL
     Copyright 2011 Dejay Clayton

     All use of this file must comply with the Apache License,
     Version 2.0, under which this file is licensed:

     http://www.apache.org/licenses/LICENSE-2.0 --]]

--[[
-------------------------------------------------------------------------------
-- Convenience functions for performing data manipulation.

module "DataHelper"
-------------------------------------------------------------------------------
--]]

local CLASSPATH = require( "classpath" )

local CLASS = {}

--- Description.
-- @name .compareString
-- @param target
-- @param compareTo
-- @param ignoreCase
-- @return description.
-- @usage example
-- @see .class
function CLASS.compareString( target, compareTo, ignoreCase )
    if ( target == compareTo ) then return true end
    if ( not ignoreCase ) then return false end
    if ( target == nil or compareTo == nil ) then return false end
    return target:upper() == compareTo:upper()
end

-- Thanks to http://stackoverflow.com/a/664611/111948
-- Thanks to http://lua-users.org/wiki/CopyTable
--- Description.
-- @name .copy
-- @param object
-- @return description.
-- @usage example
-- @see .class
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
--- Description.
-- @name .copyDeep
-- @param targetTable
-- @return description.
-- @usage example
-- @see .class
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

--- Description.
-- @name .endsWith
-- @param target
-- @param suffix
-- @param ignoreCase
-- @return description.
-- @usage example
-- @see .class
function CLASS.endsWith( target, suffix, ignoreCase )
    if ( target == nil or suffix == nil ) then return false end
    if ( suffix == "" or target == suffix ) then return true end

    if ( ignoreCase ) then
        return suffix:lower() == string.sub(
            target, -1 * string.len( suffix ) ):lower()
    else
        return suffix == string.sub( target, -1 * string.len( suffix ) )
    end
end

--- Description.
-- @name .getDefault
-- @param target
-- @param default
-- @return description.
-- @usage example
-- @see .class
function CLASS.getDefault( target, default )
    if ( target ~= nil ) then return target end
    return default
end

--- Description.
-- @name .getDefaultIf
-- @param target
-- @param default
-- @param _if
-- @return description.
-- @usage example
-- @see .class
function CLASS.getDefaultIf( target, default, _if )
    if ( not _if ) then return target end
    return Data.getDefault( target, default )
end

--- Description.
-- @name .getNumericKeysSorted
-- @param targetTable
-- @return description.
-- @usage example
-- @see .class
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

--- Description.
-- @name .hasValue
-- @param value
-- @return description.
-- @usage example
-- @see .class
function CLASS.hasValue( value )
    return value ~= nil and value ~= ""
end

--- Description.
-- @name .isNonEmptyTable
-- @param targetTable
-- @return description.
-- @usage example
-- @see .class
function CLASS.isNonEmptyTable( targetTable )
    return
        type( targetTable ) == "table" and
        table.getn( targetTable ) > 0
end

--- Description.
-- @name .ite
-- @param _if
-- @param _then
-- @param _else
-- @return description.
-- @usage example
-- @see .class
function CLASS.ite( _if, _then, _else )
    if ( _if ) then return _then end
    return _else
end

-- Thanks to http://lua-users.org/wiki/FuncTables
--- Description.
-- @name .memoize
-- @param fn
-- @param fnKey
-- @return description.
-- @usage example
-- @see .class
function CLASS.memoize( fn, fnKey )
    fnKey = fnKey or function ( ... )
        local key = ""
        for i = 1, table.getn( arg ) do
            key = key .. "[" .. tostring( arg[ i ] ) .. "]"
        end
        return key 
    end

    local object = {
        __call  = function( targetTable, ... )
            local key = fnKey( ... )
            local values = targetTable.__memoized[ key ]

            if ( values == nil ) then
                values = CLASS.pack( fn( ... ) )
                targetTable.__memoized[ key ] = values
            end

            if ( table.getn( values ) > 0 ) then
                return unpack( values )
            end

            return nil
        end,
        __forget = function( self ) self.__memoized = {} end,
        __memoized = {},
        __mode = "v",
    }

    return setmetatable( object, object )
end

--- Description.
-- @name .pack
-- @param ...
-- @return description.
-- @usage example
-- @see .class
function CLASS.pack( ... )
    return arg
end

-- Thanks to http://lua-users.org/wiki/SimpleRound
--- Description.
-- @name .roundNumber
-- @param num
-- @param idp
-- @return description.
-- @usage example
-- @see .class
function CLASS.roundNumber( num, idp )
    local mult = 10^( idp or 0 )
    return math.floor( num * mult + 0.5 ) / mult
end

--- Description.
-- @name .selectByNestedIndex
-- @param targetTable
-- @param ...
-- @return description.
-- @usage example
-- @see .class
function CLASS.selectByNestedIndex( targetTable, ... )
    if ( targetTable == nil ) then return nil end

    local objRef = targetTable

    for argIndex, argValue in ipairs( arg ) do
        objRef = objRef[ argValue ]
        if ( objRef == nil ) then return nil end
    end

    return objRef
end

--- Description.
-- @name .startsWith
-- @param target
-- @param prefix
-- @ignoreCase
-- @return description.
-- @usage example
-- @see .class
function CLASS.startsWith( target, prefix, ignoreCase )
    if ( target == nil or prefix == nil ) then return false end
    if ( prefix == "" or target == prefix ) then return true end

    if ( ignoreCase ) then
        return prefix:lower() == string.sub(
            target, 1, string.len( prefix ) ):lower()
    else
        return prefix == string.sub( target, 1, string.len( prefix ) )
    end
end

--- Description.
-- @name .updateByNestedIndex
-- @param value
-- @param targetTable
-- @param ...
-- @return description.
-- @usage example
-- @see .class
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
