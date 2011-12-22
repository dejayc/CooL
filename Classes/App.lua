--[[ CooL( Corona Object-Oriented Lua )
     https://github.com/dejayc/CooL
     Copyright 2011 Dejay Clayton

     All use of this file must comply with the Apache License,
     Version 2.0, under which this file is licensed:

     http://www.apache.org/licenses/LICENSE-2.0 --]]

local CLASSPATH = require( "classpath" )

local CLASS = autoclass( packagePath( ... ) )

function CLASS:init( platformConfig, frameworkConfig )
    io.flush()

    self:setPlatformConfig( platformConfig )
    self:setPlatformDisplay( new( CLASSPATH.CooL.PlatformDisplay ) )
    self:getPlatformDisplay():init( self:getPlatformConfig() )
    self:setFrameworkConfig( frameworkConfig )
    self:setFrameworkDisplay( new( CLASSPATH.CooL.FrameworkDisplay ) )
    self:getFrameworkDisplay():init( self:getFrameworkConfig() )
end

function CLASS:getFrameworkConfig()
    return self.frameworkConfig
end

function CLASS:setFrameworkConfig( frameworkConfig )
    self.frameworkConfig = frameworkConfig
end

function CLASS:getFrameworkDisplay()
    return self.frameworkDisplay
end

function CLASS:setFrameworkDisplay( frameworkDisplay )
    self.frameworkDisplay = frameworkDisplay
end

function CLASS:getPlatformConfig()
    return self.platformConfig
end

function CLASS:setPlatformConfig( platformConfig )
    self.platformConfig = platformConfig
end

function CLASS:getPlatformDisplay()
    return self.platformDisplay
end

function CLASS:setPlatformDisplay( platformDisplay )
    self.platformDisplay = platformDisplay
end

return CLASS
