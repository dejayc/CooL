--[[ CooL( Corona Object-Oriented Lua )
     https://github.com/dejayc/CooL
     Copyright 2011 Dejay Clayton

     All use of this file must comply with the Apache License,
     Version 2.0, under which this file is licensed:

     http://www.apache.org/licenses/LICENSE-2.0 --]]

--[[
-------------------------------------------------------------------------------
-- Convenience functions for performing object-oriented class and object
-- manipulation.

module "ClassHelper"
-------------------------------------------------------------------------------
--]]

local CLASSPATH = require( "classpath" )

local CLASS = {}

--- Invokes the 'extend' method of the CooL 'BaseClass' class, effectively
-- allowing a CooL subclass to be created with the specified name.
-- @name autoclass
-- @param name The name to assign to the new class.
-- @param object An optional object to be cast to the new class.
-- @param ... Optional parameters to be passed to the 'extend' method of the
-- CooL 'BaseClass' class.
-- @return The valued returned by the 'extend' method of the CooL 'BaseClass'
-- class, usually expected to be a new class that subclasses 'BaseClass'.
-- @usage local myClassInstance = ClassHelper.autoclass( "myClassName" )
-- @usage local myClassInstance = ClassHelper.autoclass(
--   "myClassName", existingClass )
-- @see autoclass
-- @see BaseClass:extend
function CLASS.autoclass( name, object, ... )
    if ( object == nil ) then object = {} end
    object.class = object.class or {}
    object.class.name = CLASS.getClassName( name )
    return CLASS.class( object, ... )
end

--- Invokes the 'extend' method of the specified class, to create a subclass
-- of the specified class with the specified name.
-- @name autoextend
-- @param target The class upon which to invoke the 'extend' method.  If a
-- string, will be interpreted as a file name to be 'required' first, which
-- will then be expected to return a class with an 'extend' method to invoke.
-- @param name The name to assign to the new subclass.
-- @param object An optional object to be cast to an instance of the subclass
-- of the specified class.
-- @param ... Optional parameters to be passed to the 'extend' method.
-- @return The valued returned by the 'extend' method of the specified class,
-- usually expected to be a new class that subclasses the specified class.
-- @usage local mySubClassInstance = ClassHelper.autoextend(
--   myClassInstance, "MySubClassName" )
-- @usage local mySubClassInstance = ClassHelper.autoextend(
--   "myClassName", "MySubClassName" )
-- @see BaseClass:extend
function CLASS.autoextend( target, name, object, ... )
    if ( object == nil ) then object = {} end
    object.class = object.class or {}
    object.class.name = CLASS.getClassName( name )
    return CLASS.extend( target, object, ... )
end

--- Invokes the 'cast' method of the specified class, to cast an existing
-- object, class, or table into the specified class.
-- @name cast
-- @param target The class upon which to invoke the 'cast' method.  If a
-- string, will be interpreted as a file name to be 'required' first, which
-- will then be expected to return a class with a 'cast' method to invoke.
-- @param ... Optional parameters to be passed to the 'cast' method.
-- @return The valued returned by the 'cast' method of the specified class,
-- usually expected to be an object instance that is cast to the specified
-- class.
-- @usage local castObject = ClassHelper.cast(
--   myClassInstance, existingObjectToCast )
-- @usage local castObject = ClassHelper.cast(
--   "myClassName", existingObjectToCast )
-- @see BaseClass:cast
function CLASS.cast( target, ... )
    if ( type( target ) == "string" ) then target = require( target ) end
    return target:cast( ... )
end

--- Invokes the 'extend' method of the CooL 'BaseClass' class, effectively
-- allowing a CooL subclass to be created.  Use this method if you are passing
-- in, as the first parameter, a table to be converted into a class.  The
-- table should contain a property 'class.name' that defines the name of the
-- resulting class.  If you want to create a new class from scratch, and would
-- rather pass in the class name as a parameter, please see function
-- 'autoclass'.
-- @name class
-- @param ... Optional parameters to be passed to the 'extend' method of the
-- CooL 'BaseClass' class.
-- @return The valued returned by the 'extend' method of the CooL 'BaseClass'
-- class, usually expected to be a new class that subclasses 'BaseClass'.
-- @usage local myClassInstance = ClassHelper.class( "myClassName" )
-- @see autoclass
-- @see BaseClass:extend
function CLASS.class( ... )
    return require( COOL_CLASS_PACKAGE ):extend( ... )
end

--- Invokes the 'extend' method of the specified class, to create a subclass
-- of the specified class.
-- @name extend
-- @param target The class upon which to invoke the 'extend' method.  If a
-- string, will be interpreted as a file name to be 'required' first, which
-- will then be expected to return a class with an 'extend' method to invoke.
-- @param ... Optional parameters to be passed to the 'extend' method.
-- @return The valued returned by the 'extend' method of the specified class,
-- usually expected to be a new class that subclasses the specified class.
-- @usage local mySubClassInstance = ClassHelper.extend( myClassInstance )
-- @usage local mySubClassInstance = ClassHelper.extend( "myClassName" )
-- @see BaseClass:extend
function CLASS.extend( target, ... )
    if ( type( target ) == "string" ) then target = require( target ) end
    return target:extend( ... )
end

--- Extracts the class name of the specified Lua package path.
-- @name getClassName
-- @param packagePath The Lua package path from which to extract the class
-- name.
-- @return The class name of the specified Lua package path.
-- @usage local name = ClassHelper.getClassName(
--   "Classes.CooL.globals" ) -- "globals"
function CLASS.getClassName( packagePath )
    local _, _, name = string.find( packagePath, PACKAGE_CLASS_PATTERN )
    if ( name == nil ) then name = packagePath end
    return name
end

--- Extracts the package name, without the class name, of the specified Lua
-- package path.
-- @name getPackageName
-- @param packagePath The Lua package path from which to extract the package
-- name.
-- @return The package name of the specified Lua package path.
-- @usage local name = ClassHelper.getPackageName(
--  "Classes.CooL.globals" ) -- "Classes.CooL"
function CLASS.getPackageName( packagePath )
    local _, _, name = string.find( packagePath, PACKAGE_PATH_PATTERN )
    return name
end

--- Returns the provided package path parameter, as a way to provide explicit
-- context for statements that need to get the package path of the current
-- package.
-- @name getPackagePath
-- @param path The package path parameter to return.
-- @return The provided package path parameter.
-- @usage local path = ClassHelper.getPackagePath( ... )
function CLASS.getPackagePath( path )
    return path
end

--- Invokes the 'new' method of the specified class, to create a new class
-- instance object of the specified class.
-- @name new
-- @param target The class upon which to invoke the 'new' method.  If a string,
-- will be interpreted as a file name to be 'required' first, which will then
-- be expected to return a class with a 'new' method to invoke.
-- @param ... Optional parameters to be passed to the 'new' method.
-- @return The valued returned by the 'new' method of the specified class,
-- usually expected to be a new class instance object of the specified class.
-- @usage local myClassObject = ClassHelper.new( myClassInstance )
-- @usage local myClassObject = ClassHelper.new( "myClassName" )
-- @see BaseClass:new
function CLASS.new( target, ... )
    if ( type( target ) == "string" ) then target = require( target ) end
    return target:new( ... )
end

return CLASS;
