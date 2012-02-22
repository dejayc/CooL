--[[ CooL( Corona Object-Oriented Lua )
     https://github.com/dejayc/CooL
     Copyright 2011 Dejay Clayton

     All use of this file must comply with the Apache License,
     Version 2.0, under which this file is licensed:

     http://www.apache.org/licenses/LICENSE-2.0 --]]

--[[
-------------------------------------------------------------------------------
-- The base class for CooL applications.  This class is initialized with a
-- FrameworkConfig instance that provides access to CooL configuration
-- settings, and a PlatformConfig instance that provides access to Corona
-- configuration settings.  Upon initialization, this class creates and makes
-- available a DisplayManager instance, initializing the device display as
-- appropriate per the CooL and Corona configuration settings.

module "BaseApp"
-------------------------------------------------------------------------------
--]]

local CLASSPATH = require( "classpath" )
local ClassHelper = require( CLASSPATH.CooL.ClassHelper )

local CLASS = ClassHelper.autoclass( ClassHelper.getPackagePath( ... ) )

--- Initializes an instance of the class, and makes available an instance of
-- DisplayManager to manage the display.
-- @name init
-- @param platformConfig An instance of PlatformConfig that contains Corona
-- configuration settings.
-- @param frameworkConfig An instance of FrameworkConfig that contains CooL
-- configuration settings.
-- @see DisplayManager
-- @see FrameworkConfig
-- @see PlatformConfig
function CLASS:init( platformConfig, frameworkConfig )
    io.flush()

    self.platformConfig = platformConfig
    self.frameworkConfig = frameworkConfig
    self.displayManager = ClassHelper.new( CLASSPATH.CooL.DisplayManager )
    self.displayManager:init( platformConfig, frameworkConfig )
end

--- Gets the DisplayManager instance associated with this application,
-- configured according to the Corona and CooL configuration files.
-- @name getDisplayManager
-- @return The DisplayManager instance associated with this application.
-- @see DisplayManager
function CLASS:getDisplayManager()
    return self.displayManager
end

--- Gets the FrameworkConfig instance associated with this application.
-- @name getFrameworkConfig
-- @return The FrameworkConfig instance associated with this application.
-- @see FrameworkConfig
function CLASS:getFrameworkConfig()
    return self.frameworkConfig
end

--- Gets the PlatformConfig instance associated with this application.
-- @name getPlatformConfig
-- @return The PlatformConfig instance associated with this application.
-- @see PlatformConfig
function CLASS:getPlatformConfig()
    return self.platformConfig
end

return CLASS
