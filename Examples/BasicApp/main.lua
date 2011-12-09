local CLASSPATH = require( "classpath" )

print [[
Please make sure that 'config.lua' is symlinked or copied to
'config-local.lua'!
]]

local Config = require( CLASSPATH.CooL.Config )
local config = Config:new()
config:init( require( "config-local" ) )

print [[
This basic app isn't very visual, but debugging print statements will reveal
screen statistics when you rotate the hardware in the Corona simulator.
]]

local App = require( CLASSPATH.CooL.App )
local app = App:new()
app:init( config )

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
