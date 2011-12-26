--[[ CooL( Corona Object-Oriented Lua )
     https://github.com/dejayc/CooL
     Copyright 2011 Dejay Clayton

     All use of this file must comply with the Apache License,
     Version 2.0, under which this file is licensed:

     http://www.apache.org/licenses/LICENSE-2.0 --]]

local CLASSPATH = require( "classpath" )

io.flush()
print( string.format( [[
Please make sure that 'config.lua' is symlinked or copied to '%s'!

This basic app doesn't do much, but demonstrates how various objects within
the framework should be constructed and invoked.
]],
tostring( CLASSPATH.config.platform ) ) )

local platformConfig = new( CLASSPATH.CooL.PlatformConfig )
platformConfig:init( require( CLASSPATH.config.platform ) )

local frameworkConfig = new( CLASSPATH.CooL.FrameworkConfig )
frameworkConfig:init( require( CLASSPATH.config.framework ) )

local app = new( CLASSPATH.CooL.App )
app:init( platformConfig, frameworkConfig )
