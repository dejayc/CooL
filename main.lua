local CLASSPATH = require( "classpath" )

local Config = require( CLASSPATH.CooL.Config )
local config = Config:new()
config:init( require( "config-local" ) )

local App = require( CLASSPATH.CooL.App )
local app = App:new()
app:init( config )

local Game = require( CLASSPATH.SwapBlocks.Game )
local game = Game:new()
game:init( app )
game:start()
