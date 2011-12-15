--[[ CooL( Corona Object-Oriented Lua )
     https://github.com/dejayc/CooL
     Copyright 2011 Dejay Clayton

     All use of this file must comply with the Apache License,
     Version 2.0, under which this file is licensed:

     http://www.apache.org/licenses/LICENSE-2.0 --]]

local CLASSPATH = require( "classpath" )
local Display = require( CLASSPATH.CooL.Display )

local App = class( { className = "App" } )

function App:init( config )
    io.flush()

    self:setConfig( config )
    self:setDisplay( Display:new() )
    self:getDisplay():init( self:getConfig() )

    Runtime:addEventListener( "orientation",
        function( event ) self:onOrientationChange( event ) end
    )
end

function App:onOrientationChange( event )
    -- TODO: Remove
    self:getDisplay():debugScreenMetrics()
end

function App:getConfig()
    return self.config
end

function App:setConfig( config )
    self.config = config

    if (self:getDisplay() ~= nil ) then
        self:getDisplay():setConfig( config )
    end
end

function App:getDisplay()
    return self.display
end

function App:setDisplay( display )
    self.display = display
end

return App
