--[[ CooL( Corona Object-Oriented Lua )
     https://github.com/dejayc/CooL
     Copyright 2011 Dejay Clayton

     All use of this file must comply with the Apache License,
     Version 2.0, under which this file is licensed:

     http://www.apache.org/licenses/LICENSE-2.0 --]]

local CLASSPATH = require( "classpath" )
local ClassHelper = require( CLASSPATH.CooL.ClassHelper )
local DataHelper = require( CLASSPATH.CooL.DataHelper )

local CLASS = ClassHelper.autoclass( ClassHelper.getPackagePath( ... ) )

function CLASS:init( values )
    self:setValues( values )
end

function CLASS:getValues()
    return self.values
end

function CLASS:setValues( values )
    self.values = values
end

function CLASS:getValue( useDefault, ... )
    local value = DataHelper.selectByNestedIndex( self:getValues(), ... )

    if ( value == nil and ( useDefault or useDefault == nil ) ) then
        value = self:getDefaultValue( ... )
    end

    return value
end

function CLASS:setValue( value, ... )
    DataHelper.updateByNestedIndex( value, self:getValues(), ... )
end

function CLASS:hasValue( ... )
    return DataHelper.hasValue( self:getValue( false, ... ) )
end

function CLASS:getDefaultValues()
    return self.defaultValues
end

function CLASS:setDefaultValues( defaultValues )
    self.defaultValues = defaultValues
end

function CLASS:getDefaultValue( ... )
    return DataHelper.selectByNestedIndex( self:getDefaultValues(), ... )
end

function CLASS:setDefaultValue( value, ... )
    DataHelper.updateByNestedIndex( value, self:getDefaultValues(), ... )
end

return CLASS
