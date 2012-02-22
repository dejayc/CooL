--[[ CooL( Corona Object-Oriented Lua )
     https://github.com/dejayc/CooL
     Copyright 2011 Dejay Clayton

     All use of this file must comply with the Apache License,
     Version 2.0, under which this file is licensed:

     http://www.apache.org/licenses/LICENSE-2.0 --]]

--[[
-------------------------------------------------------------------------------
-- Convenience methods to inspect and manipulate the state of the Corona
-- configuration.

module "PlatformConfig"
-------------------------------------------------------------------------------
--]]

local CLASSPATH = require( "classpath" )
local ClassHelper = require( CLASSPATH.CooL.ClassHelper )

local CLASS = ClassHelper.autoextend(
    CLASSPATH.CooL.BaseConfig, ClassHelper.getPackagePath( ... ) )

--- Description.
-- @name init
-- @param ...
-- @return description.
-- @usage example
-- @see class
function CLASS:init( ... )
    self.super.init( self, ... )
end

--- Description.
-- @name getImageSuffix
-- @return description.
-- @usage example
-- @see class
function CLASS:getImageSuffix()
    return self:getValue( false, "content", "imageSuffix" )
end

--- Description.
-- @name hasImageSuffix
-- @return description.
-- @usage example
-- @see class
function CLASS:hasImageSuffix()
    return self:hasValue( "content", "imageSuffix" )
end

return CLASS
