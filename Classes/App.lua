--[[ CooL( Corona Object-Oriented Lua )
     https://github.com/dejayc/CooL
     Copyright 2011 Dejay Clayton

     All use of this file must comply with the Apache License,
     Version 2.0, under which this file is licensed:

     http://www.apache.org/licenses/LICENSE-2.0 --]]

local CLASSPATH = require( "classpath" )

local App = autoclass( packagePath ( ... ) )

function App:init( platformConfig, frameworkConfig )
    io.flush()

    self:setPlatformConfig( platformConfig )
    self:setFrameworkConfig( frameworkConfig )
    self:setDisplay( new( CLASSPATH.CooL.Display ) )
    self:getDisplay():init( self )

    Runtime:addEventListener( "orientation",
        function( event ) self:onOrientationChange( event ) end
    )
end

function App:onOrientationChange( event )
    -- TODO: Remove
    self:getDisplay():debugScreenMetrics()
end

function App:getFrameworkConfig()
    return self.frameworkConfig
end

function App:setFrameworkConfig( frameworkConfig )
    self.frameworkConfig = frameworkConfig

    if ( self:getDisplay() ~= nil ) then
        self:getDisplay():refreshConfig()
    end
end

function App:getPlatformConfig()
    return self.platformConfig
end

function App:setPlatformConfig( platformConfig )
    self.platformConfig = platformConfig

    if ( self:getDisplay() ~= nil ) then
        self:getDisplay():refreshConfig()
    end
end

function App:getDisplay()
    return self.display
end

function App:setDisplay( display )
    self.display = display
end

return App
