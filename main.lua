local CLASSPATH = require( "classpath" )

local App = require( CLASSPATH.LuaLib.App )
local app = App:new()

--[[
-- app:init()

local Game = require( CLASSPATH.SwapBlocks.Game )
local game = Game:new( { className = "Game" } )
-- game:init( app )
-- game:start()
--]]

--[[
local a = Class:new()
local b = Class:new( { className = "b" } )

a:print()
b:print()
--]]

--[[
function initDisplay ()
    display.setStatusBar( display.HiddenStatusBar )
end

function initGame ()
    initDisplay()
end

initGame()

require( "sprite" )

local resolution_640x960 = "640x960"
local targetResolution = resolution_640x960
local filenameSuffix_resolutionSeparator = "@"

local path_Sprites = "Assets/Sprites"
local filenamePrefix_SpriteSheet_Blocks = "SwapBlocks-Blocks"

local filename_SpriteSheet_Blocks =
    path_Sprites .. OS_PATH_SEP .. targetResolution .. OS_PATH_SEP ..
    filenamePrefix_SpriteSheet_Blocks .. "-1" ..
    filenameSuffix_resolutionSeparator .. targetResolution .. ".png"

local filename_SpriteSheetData_Blocks =
    path_Sprites .. OS_PATH_SEP .. targetResolution .. OS_PATH_SEP ..
    filenamePrefix_SpriteSheet_Blocks .. "-1" ..
    filenameSuffix_resolutionSeparator .. targetResolution

local spriteCount_Blocks = 64

local spriteSheet_Blocks = sprite.newSpriteSheetFromData(
    filename_SpriteSheet_Blocks,
    require( filename_SpriteSheetData_Blocks ).getSpriteSheetData())

local spriteSet_Blocks = sprite.newSpriteSet(
    spriteSheet_Blocks, 1, spriteCount_Blocks)

local sprite_Blocks_Amber_1x1 = sprite.newSprite( spriteSet_Blocks )

sprite_Blocks_Amber_1x1.currentFrame = 15

sprite_Blocks_Amber_1x1.x = display.contentWidth / 2
sprite_Blocks_Amber_1x1.y = display.contentHeight / 2
--]]
