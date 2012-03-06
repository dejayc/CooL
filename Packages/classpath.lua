--[[ CooL( Corona Object-Oriented Lua )
     https://github.com/dejayc/CooL
     Copyright 2011 Dejay Clayton

     All use of this file must comply with the Apache License,
     Version 2.0, under which this file is licensed:

     http://www.apache.org/licenses/LICENSE-2.0 --]]

--[[
-------------------------------------------------------------------------------
-- Base 'classpath' file that includes CooL classes and defines certain CooL
-- global variables.

module "classpath.lua"
-------------------------------------------------------------------------------
--]]

local BaseLua = require( "BaseLua" )

--- CooL class fields.
-- @class table
-- @name CooL
CLASS = {}

local _, _, packageName = string.find( ..., BaseLua.PACKAGE_NAME_PATTERN )
local _, _, packagePath = string.find( ..., BaseLua.PACKAGE_PATH_PATTERN )
packageName = packageName or "CooL"
packagePath = packagePath or ""

--- CooL package helper that facilitates working with CooL packages.
-- @class table
-- @name package 
-- @field name The package name for this CooL class.  Usually should be
--   'CooL', unless the file name of this class has been changed.
-- @field path The package path for all CooL classes.
-- @field PACKAGE_NAME An invocation of package that contains a child index
--   other than "name" or "path" will return the child index appended to the
--   package path.  Replace "PACKAGE_NAME" with the name of the package to
--   return.
-- @Usage: CooL.package.BaseApp -- Packages.BaseClass
CLASS.package = setmetatable(
    {
        name = packageName,
        path = packagePath,
    },
    {
        __index = function( t, index )
            return ( packagePath or "" ) .. index
        end,
    }
)

-- Update the global loaded package table so that future invocations of the
-- Lua function 'require' can retrieve this class without knowing the path to
-- this class.
package.loaded[ packageName ] = CLASS

return CLASS
