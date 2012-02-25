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

--- Indicates whether two strings are identical, optionally ignoring case and
-- safely handling nil values.  If either object is not nil and is not a
-- string, returns false.
-- @name compareString
-- @param target The first string to compare.
-- @param compareTo The second string to compare.
-- @param ignoreCase Determines whether case is ignored during comparison.
-- @return True if both strings are nil or are equal; false otherwise.
-- @usage compareString( nil, nil ) -- true
-- @usage compareString( "Hi", "hi" ) -- false
-- @usage compareString( "Hi", "hi", true ) -- true
-- @usage s = {}; compareString( s, s ) -- false
function CLASS.compareString( target, compareTo, ignoreCase )
    if ( target == nil and compareTo == nil ) then return true end

    if ( type( target ) ~= "string" ) then return false end
    if ( type( compareTo ) ~= "string" ) then return false end

    if ( target == compareTo ) then return true end
    if ( not ignoreCase ) then return false end

    return target:upper() == compareTo:upper()
end

--- Returns a shallow or deep copy of the specified table.
-- @name copy
-- @param sourceTable The table to copy.
-- @param copyTables False if the specified table and its resulting copy
-- should share references to child elements that are also tables; True if
-- child tables should be copied recursively.  Defaults to false.
-- @param copyMetatables False if the specified table and its child table
-- elements should share metatables with the resulting copies of the tables;
-- True if metatables should be copied recursively.  Defaults to false.
-- @return A copy of the specified table.
-- @usage table2 = copy( table1 )
-- @usage table2 = copy( table1, true )
-- @see http://lua-users.org/wiki/CopyTable
function CLASS.copy( sourceTable, copyTables, copyMetatables )
    local lookupTable = {}

    local function _copy( toCopy )
        if ( type( toCopy ) ~= "table" ) then
            return toCopy
        end

        if ( lookupTable[ toCopy ] ) then
            return lookupTable[ toCopy ]
        end

        local copied = {}
        lookupTable[ toCopy ] = copied

        if ( copyTables ) then
            for index, value in pairs( toCopy ) do
                copied[ _copy( index) ] = _copy( value )
            end
        else
            for index, value in pairs( toCopy ) do
                copied[ index ] = value
            end
        end

        if ( copyMetatables ) then
            return setmetatable( copied, _copy( getmetatable( toCopy ) ) )
        else
            return setmetatable( copied, getmetatable( toCopy ) )
        end
    end

    return _copy( sourceTable )
end

--- Indicates whether the specified target string ends with the specified
-- suffix string, optionally ignoring case and safely handling nil values.  If
-- either object is not nil and is not a string, returns false.
-- @name endsWith
-- @param target The target string to be examined for whether it ends with the
-- specified suffix string.
-- @param suffix The string to be looked for at the end of the target string.
-- @param ignoreCase Determines whether case is ignored during evaluation.
-- @return True if both strings are nil, or if the specified target string
-- ends with the specified suffix string, or if the specified suffix string is
-- an empty string; false otherwise.
-- @usage endsWith( nil, nil ) -- true
-- @usage endsWith( "Hi there", "Here" ) -- false
-- @usage endsWith( "Hi there", "Here", true ) -- true
-- @usage endsWith( "Hi there", "" ) -- true
-- @usage s = "a"; endsWith( s, s ) -- true
-- @usage s = {}; endsWith( s, s ) -- false
-- @see startsWith
function CLASS.endsWith( target, suffix, ignoreCase )
    if ( target == nil and suffix == nil ) then return true end

    if ( type( target ) ~= "string" ) then return false end
    if ( type( suffix ) ~= "string" ) then return false end

    if ( suffix == "" ) then return true end

    local function _endsWith( target, suffix )
        if ( target == suffix ) then return true end
        return suffix == string.sub( target, -1 * string.len( suffix ) )
    end

    if ( ignoreCase ) then
        if ( target == suffix ) then return true end
        return _endsWith( target:lower(), suffix:lower() )
    else
        return _endsWith( target, suffix )
    end
end

--- Returns the first non-nil value from the specified list of values.
-- @name getNonNil
-- @param ... A list of values to search for the first non-nil value.
-- @return The first non-nil value.
-- @usage getNonNil( nil, 5, nil ) -- 5
-- @usage getNonNil( "Hi", nil, 3 ) -- "Hi"
function CLASS.getNonNil( ... )
    for i = 1, table.getn( arg ) do
        local value = arg[ i ]
        if ( value ~= nil ) then return value end
    end
end

--- Returns a new table consisting of the sorted numeric key values of the
-- specified table.  Useful for iterating through a mixed table that contains
-- associative array entries in addition to traditional numeric array entries.
-- @name getNumericKeysSorted
-- @param target The target table to search for numeric key values.
-- @return The sorted numeric key values of the specified table.
-- @usage getNumericKeysSorted (
--   { 3 = "a", 1 = "b", "hi" = "bye", 2 = "c" } ) -- { 1, 2, 3 }
-- @usage for index, value in ipairs( getNumericKeysSorted ( mixedTable ) ) do
function CLASS.getNumericKeysSorted( target )
    local sorted = {}
    for index, value in pairs( target ) do
        if ( type( index ) == "number" ) then
            table.insert( sorted, index )
        end
    end

    table.sort( sorted )
    return sorted
end

--- Indicates whether the specified target value is not nil and is not an
-- empty string.
-- @name hasValue
-- @param value The target value to evaluate.
-- @return True if the specified target value is not nil and is not an empty
-- string; otherwise, false.
-- @usage hasValue( nil ) -- false
-- @usage hasValue( 5 ) -- true
-- @usage hasValue( "" ) -- false
-- @usage hasValue( " " ) -- true
function CLASS.hasValue( value )
    return value ~= nil and value ~= ""
end

--- Returns the specified target value if the specified boolean test parameter
-- is true; otherwise, returns the specified default value.
-- @name ifThenElse
-- @param _if The boolean test parameter that determines whether the target
-- value or default value is to be returned; true if the target value is to be
-- returned, false if the default value is to be returned.
-- @param _then The target value to be returned if the specified boolean test
-- parameter is true.
-- @param _else The default value to be returned if the specified boolean
-- test parameter is false.
-- @return The specified target value if the specified boolean test parameter
-- is true; otherwise, the specified default value.
-- @usage ifThenElse( true, 1, 0 ) -- 1
-- @usage x = 3; y = 9; ifThenElse( x > y, x, y ) -- 9
function CLASS.ifThenElse( _if, _then, _else )
    if ( _if ) then return _then end
    return _else
end

--- Indicates whether the specified parameter is a table that contains at
-- least one element.
-- @name isNonEmptyTable
-- @param target The target parameter to evaluate.
-- @return True if the specified parameter is a table that contains at least
-- one element; otherwise, false.
-- @usage isNonEmptyTable( nil ) -- false
-- @usage isNonEmptyTable( "Hi" ) -- false
-- @usage isNonEmptyTable( { } ) -- false
-- @usage isNonEmptyTable( { "" } ) -- true
function CLASS.isNonEmptyTable( target )
    return
        type( target ) == "table" and
        table.getn( target ) > 0
end

--- Returns a memoized version of the specified function, using an optionally
-- specified index function to create a memoization index from the parameters
-- that are passed to invocations of the memoized function.  The memoized
-- function will expose a "__forget" method that can be used to clear all
-- memoized results.
-- @name memoize
-- @param fn The function to memoize
-- @param fnIndex An optional function to create a memoization index from the
-- parameters that are passed to invocations of the memoized function.
-- @return The memoized version of the specified function.
-- @usage inc = memoize( function( a ) print( a ); return a + 1 end )
-- @usage inc( 5 ) -- Executes function, printing "5" and returning "6"
-- @usage inc( 5 ) -- Returns memoized result "6" without executing function
-- @usage inc:__forget() -- Clears all memoized results.
-- @usage inc( 5 ) -- Executes function again, printing "5" and returning "6"
-- @usage sub = memoize( function( a, b ) return a - b end )
-- @usage sub( 3, 1 ) -- Executes function and returns 2
-- @usage sub( 1, 3 ) -- Parameters are in different order, so no memoized
--   result is found.  Executes function and returns -2
-- @usage add = memoize(
--   function( a, b ) return a + b end,
--   function( a, b ) return a + b end )
-- @usage add( 1, 3 ) -- Executes function and returns 4
-- @usage add( 3, 1 ) -- Since the specified memoization index function
--   indexes the parameters irrespective of order, returns the memoized
--   result without executing the function again.
-- @see http://lua-users.org/wiki/FuncTables
function CLASS.memoize( fn, fnIndex )
    fnIndex = fnIndex or function ( ... )
        local key = ""
        for i = 1, table.getn( arg ) do
            key = key .. "[" .. tostring( arg[ i ] ) .. "]"
        end
        return key 
    end

    local object = {
        __call  = function( targetTable, ... )
            local key = fnIndex( ... )
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

--- Returns a table that contains all of the passed parameters.
-- @name pack
-- @param ... A list of optional parameters with which to populate the
-- returned table.
-- @return A table that contains all of the passed parameters.
-- @usage pack ( 1, 2, 3 ) -- { 1, 2, 3 }
-- @usage pack ( 1, nil, 2, 3 ) -- { 1, nil, 2, 3 }
function CLASS.pack( ... )
    return arg
end

--- Returns the simply rounded representation of the specified number.
-- @name roundNumber
-- @param number The number to round.
-- @param decimalPlaces The number of decimal places to which to round
-- the specified number.  Defaults to 0.
-- @return The simply rounded representation of the specified number.
-- @usage roundNumber( 98.4 ) -- 98
-- @usage roundNumber( 98.6 ) -- 99
-- @usage roundNumber( 98.625, 1 ) -- 98.6
-- @usage roundNumber( 98.625, 2 ) -- 98.63
-- @see http://lua-users.org/wiki/SimpleRound
function CLASS.roundNumber( number, decimalPlaces )
    local multiplier = 10^( incrementalDecimalPlaces or 0 )
    return math.floor( number * multiplier + 0.5 ) / multiplier
end

--- Returns the specified named element of the specified table, traversing
-- nested table elements as necessary.  If the specified table is nil, or
-- lacks the specified named element, returns nil.
-- @name selectByNestedIndex
-- @param target The target table to search for the specified named element.
-- @param ... A list of element names, with each name representing a step
-- deeper into the hierarchy of nested table elements.
-- @return The specified named element of the specified table, if available;
-- otherwise, nil.
-- @usage selectByNestedIndex( { "hi" = { "bye" = 9 } }, "hi", "bye" ) -- 9
-- @usage selectByNestedIndex(
--   { "hi" = { "bye" = 9 } }, "hi" ) -- { "bye" = 9 }
-- @usage selectByNestedIndex(
--   { "hi" = { "bye" = 9 } }, "hi", "there" ) -- nil
-- @usage selectByNestedIndex( nil, "hi", "bye" ) -- nil
-- @see updateByNestedIndex
function CLASS.selectByNestedIndex( target, ... )
    if ( target == nil ) then return nil end

    local objRef = target

    for index, value in ipairs( arg ) do
        objRef = objRef[ value ]
        if ( objRef == nil ) then return nil end
    end

    return objRef
end

--- Indicates whether the specified target string starts with the specified
-- prefix string, optionally ignoring case and safely handling nil values.  If
-- either object is not nil and is not a string, returns false.
-- @name startsWith
-- @param target The target string to be examined for whether it starts with
-- the specified suffix string.
-- @param prefix The string to be looked for at the start of the target
-- string.
-- @param ignoreCase Determines whether case is ignored during evaluation.
-- @return True if both strings are nil, or if the specified target string
-- starts with the specified prefix string, or if the specified prefix string
-- is an empty string; false otherwise.
-- @usage startsWith( nil, nil ) -- true
-- @usage startsWith( "Hi there", "HI" ) -- false
-- @usage startsWith( "Hi there", "HI", true ) -- true
-- @usage startsWith( "Hi there", "" ) -- true
-- @usage s = "a"; startsWith( s, s ) -- true
-- @usage s = {}; startsWith( s, s ) -- false
-- @see endsWith
function CLASS.startsWith( target, prefix, ignoreCase )
    if ( target == nil and prefix == nil ) then return true end

    if ( type( target ) ~= "string" ) then return false end
    if ( type( prefix ) ~= "string" ) then return false end

    if ( prefix == "" ) then return true end

    local function _startsWith( target, prefix )
        if ( target == prefix ) then return true end
        return prefix == string.sub( target, 1, string.len( prefix ) )
    end

    if ( ignoreCase ) then
        if ( target == prefix ) then return true end
        return _startsWith( target:lower(), preix:lower() )
    else
        return _startsWith( target, prefix )
    end
end

--- Updates the specified named element of the specified table to the
-- specified value and returns it, traversing and creating nested table
-- elements as necessary.  If the specified table is nil, returns nil.
-- @name updateByNestedIndex
-- @param value The value to which to set the specified named element in the
-- specified table.
-- @param target The target table to search for the specified named element.
-- @param ... A list of element names, with each name representing a step
-- deeper into the hierarchy of nested table elements.
-- @return The specified named element of the specified table, if the table is
-- not nil; otherwise, nil.
-- @usage updateByNestedIndex(
--   9, { "hi" = { "bye" = 0 } }, "hi", "bye" ) -- { "bye" = 9 }
-- @usage updateByNestedIndex(
--   9, { "hi" }, "hi", "bye" ) -- { "hi" = { "bye" = 9 } }
-- @usage updateByNestedIndex(
--   { "bye" = 9}, { "hi" }, "hi" ) -- { "hi" = { "bye" = 9 } }
-- @usage updateByNestedIndex( 9, { "hi" } ) --  { "hi" }
-- @usage updateByNestedIndex( nil, "hi", "bye" ) -- nil
-- @see selectByNestedIndex
function CLASS.updateByNestedIndex( value, target, ... )
    if ( target == nil ) then return nil end

    local objRef = target
    local pathDepth = table.getn( arg )

    for index, indexName in ipairs( arg ) do
        if ( index == pathDepth ) then
            objRef[ indexName ] = value
            break
        end
        if ( objRef[ indexName ] == nil ) then
            objRef[ indexName ] = {}
        end
        objRef = objRef[ indexName ]
    end

    return objRef
end

return CLASS
