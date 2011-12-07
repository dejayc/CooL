local CLASSPATH = require( "classpath" )

local Config = require( CLASSPATH.LuaLib.Config )
local config = Config:new()
config:init( require( "config-local" ) )

local App = require( CLASSPATH.LuaLib.App )
local app = App:new()
app:init( config )

local Game = require( CLASSPATH.SwapBlocks.Game )
local game = Game:new()
game:init( app )
game:start()
