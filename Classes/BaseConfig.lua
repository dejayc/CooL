--[[ CooL( Corona Object-Oriented Lua )
     https://github.com/dejayc/CooL
     Copyright 2011 Dejay Clayton

     All use of this file must comply with the Apache License,
     Version 2.0, under which this file is licensed:

     http://www.apache.org/licenses/LICENSE-2.0 --]]

--[[
-------------------------------------------------------------------------------
-- The base class for classes that inspect and manipulate configurations.

module "BaseConfig"
-------------------------------------------------------------------------------
--]]

local CLASSPATH = require( "classpath" )
local ClassHelper = require( CLASSPATH.CooL.ClassHelper )
local DataHelper = require( CLASSPATH.CooL.DataHelper )

local CLASS = ClassHelper.autoclass( ClassHelper.getPackagePath( ... ) )

--- Description.
-- @name init
-- @param values
-- @return description.
-- @usage example
-- @see class
function CLASS:init( values )
    self:setValues( values )
end

--- Description.
-- @name getValue
-- @return description.
-- @usage example
-- @see class
function CLASS:getValues()
    return self.values
end

--- Description.
-- @name setValues
-- @param values
-- @return description.
-- @usage example
-- @see class
function CLASS:setValues( values )
    self.values = values
end

--- Description.
-- @name getValue
-- @param useDefault
-- @param ...
-- @return description.
-- @usage example
-- @see class
function CLASS:getValue( useDefault, ... )
    local value = DataHelper.selectByNestedIndex( self:getValues(), ... )

    if ( value == nil and ( useDefault or useDefault == nil ) ) then
        value = self:getDefaultValue( ... )
    end

    return value
end

--- Description.
-- @name setValue
-- @param value
-- @param ...
-- @return description.
-- @usage example
-- @see class
function CLASS:setValue( value, ... )
    DataHelper.updateByNestedIndex( value, self:getValues(), ... )
end

--- Description.
-- @name hasValue
-- @param ...
-- @return description.
-- @usage example
-- @see class
function CLASS:hasValue( ... )
    return DataHelper.hasValue( self:getValue( false, ... ) )
end

--- Description.
-- @name getDefaultValues
-- @return description.
-- @usage example
-- @see class
function CLASS:getDefaultValues()
    return self.defaultValues
end

--- Description.
-- @name setDefaultValues
-- @param defaultValues
-- @return description.
-- @usage example
-- @see class
function CLASS:setDefaultValues( defaultValues )
    self.defaultValues = defaultValues
end

--- Description.
-- @name getDefaultValue
-- @param ...
-- @return description.
-- @usage example
-- @see class
function CLASS:getDefaultValue( ... )
    return DataHelper.selectByNestedIndex( self:getDefaultValues(), ... )
end

--- Description.
-- @name setDefaultValue
-- @param value
-- @param ...
-- @return description.
-- @usage example
-- @see class
function CLASS:setDefaultValue( value, ... )
    DataHelper.updateByNestedIndex( value, self:getDefaultValues(), ... )
end

return CLASS
