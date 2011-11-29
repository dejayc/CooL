local CLASSPATH = require( "classpath" )
local Class = require( CLASSPATH.LuaLib.Class )

local App = Class:extend( { className = "App" } )

function App:init()
end

return App
