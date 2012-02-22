--[[ CooL( Corona Object-Oriented Lua )
     https://github.com/dejayc/CooL
     Copyright 2011 Dejay Clayton

     All use of this file must comply with the Apache License,
     Version 2.0, under which this file is licensed:

     http://www.apache.org/licenses/LICENSE-2.0 --]]

local CLASSPATH = require( "classpath" )
local ClassHelper = require( CLASSPATH.CooL.ClassHelper )

local CLASS = ClassHelper.autoclass( ClassHelper.getPackagePath( ... ) )

function CLASS:init( platformConfig, frameworkConfig )
    io.flush()

    self.platformConfig = platformConfig
    self.frameworkConfig = frameworkConfig
    self.displayManager = ClassHelper.new( CLASSPATH.CooL.DisplayManager )
    self.displayManager:init( platformConfig, frameworkConfig )
end

function CLASS:getDisplayManager()
    return self.displayManager
end

function CLASS:getFrameworkConfig()
    return self.frameworkConfig
end

function CLASS:getPlatformConfig()
    return self.platformConfig
end

return CLASS
