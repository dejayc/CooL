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
    self:setFrameworkConfig( frameworkConfig )
    self:setDisplay( new( CLASSPATH.CooL.Display ) )
    self:getDisplay():init( self )

    Runtime:addEventListener( "orientation",
        function( event ) self:onOrientationChange( event ) end
    )
end

function CLASS:onOrientationChange( event )
    -- TODO: Remove
    self:getDisplay():debugScreenMetrics()
end

function CLASS:getFrameworkConfig()
    return self.frameworkConfig
end

function CLASS:setFrameworkConfig( frameworkConfig )
    self.frameworkConfig = frameworkConfig

    if ( self:getDisplay() ~= nil ) then
        self:getDisplay():refreshConfig()
    end
end

function CLASS:getPlatformConfig()
    return self.platformConfig
end

function CLASS:setPlatformConfig( platformConfig )
    self.platformConfig = platformConfig

    if ( self:getPlatformConfig() ~= nil ) then
        self:getPlatformConfig():refreshConfig()
    end

    if ( self:getDisplay() ~= nil ) then
        self:getDisplay():refreshConfig()
    end
end

function CLASS:getDisplay()
    return self.display
end

function CLASS:setDisplay( display )
    self.display = display
end

return CLASS
