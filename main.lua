local CLASSPATH = require( "classpath" )
local appConfig = require( "config" )

local App = require( CLASSPATH.LuaLib.App )
local app = App:new()
app:init( appConfig )

local Game = require( CLASSPATH.SwapBlocks.Game )
local game = Game:new()
game:init( app )
game:start()
