--[[ CooL( Corona Object-Oriented Lua )
     https://github.com/dejayc/CooL
     Copyright 2011 Dejay Clayton

     All use of this file must comply with the Apache License,
     Version 2.0, under which this file is licensed:

     http://www.apache.org/licenses/LICENSE-2.0 --]]

local CLASSPATH = require( "classpath" )

print [[
Please make sure that 'config.lua' is symlinked or copied to
'config-Corona.lua'!
]]

local CoronaConfig = require( CLASSPATH.CooL.CoronaConfig )
local coronaConfig = CoronaConfig:new()
coronaConfig:init( require( "config-Corona" ) )

print [[
This basic app isn't very visual, but debugging print statements will reveal
screen statistics when you rotate the hardware in the Corona simulator.
]]

local App = require( CLASSPATH.CooL.App )
local app = App:new()
app:init( coronaConfig )

local function createDisplayReadout()
    local textObj = display.newText(
        "Scale: " .. app:getDisplay():getDynamicScale(),
        0, 0, nil, 10);

    return function( event )
        textObj.text = "Scale: " .. app:getDisplay():getDynamicScale()
    end
end

local displayReadout = createDisplayReadout()
Runtime:addEventListener( "orientation", displayReadout )
displayReadout()
