--[[ CooL( Corona Object-Oriented Lua )
     https://github.com/dejayc/CooL
     Copyright 2011 Dejay Clayton

     All use of this file must comply with the Apache License,
     Version 2.0, under which this file is licensed:

     http://www.apache.org/licenses/LICENSE-2.0 --]]

--[[
-------------------------------------------------------------------------------
-- Global convenience functions and variables.

module "globals"
-------------------------------------------------------------------------------
--]]

--- Prints the provided parameters via 'print', formatted according to the
-- specified format, following the formatting convention of 'string.format'.
-- Automatically prints an end-of-line character following the string.
-- @param format The 'string.format' formatting convention to apply to the
-- provided parameters.
-- @param ... Optional parameters to format according to the specified format.
-- @usage printf( "Hello, %s!", "world" )
function printf( format, ... )
    print( string.format( format, ... ) )
end

--- Writes the provided parameters via 'io.write', formatted according to the
-- specified format, following the formatting convention of 'string.format'.
-- Does not automatically print an end-of-line character following the string.
-- @param format The 'string.format' formatting convention to apply to the
-- provided parameters.
-- @param ... Optional parameters to format according to the specified format.
-- @usage writef( "Hello, %s!", "world" )
function writef( format, ... )
    io.write( string.format( format, ... ) )
end
