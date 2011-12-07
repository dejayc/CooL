local CLASSPATH = require( "classpath" )
local Class = require( CLASSPATH.LuaLib.Class )
local Display = require( CLASSPATH.LuaLib.Display )

local App = Class:extend( { className = "App" } )

function App:init( config )
    io.flush()

    self:setConfig( config )
    self:setDisplay( Display:new() )
    self:getDisplay():init( config )

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
