--[[ CooL( Corona Object-Oriented Lua )
     https://github.com/dejayc/CooL
     Copyright 2011 Dejay Clayton

     All use of this file must comply with the Apache License,
     Version 2.0, under which this file is licensed:

     http://www.apache.org/licenses/LICENSE-2.0 --]]

--[[
-------------------------------------------------------------------------------
-- Represents Corona SpriteSheet data.

module "SpriteSheetData"
-------------------------------------------------------------------------------
--]]

local CLASSPATH = require( "classpath" )
local ClassHelper = require( CLASSPATH.CooL.ClassHelper )
local FileHelper = require( CLASSPATH.CooL.FileHelper )

local CLASS = ClassHelper.autoclass( ClassHelper.getPackagePath( ... ) )

--- Description.
-- @name load
-- @param fileName
-- @return description.
-- @usage example
-- @see class
function CLASS:load( fileName )
    local spriteSheetData = require(
        FileHelper.getRequirePath( fileName ) ).getSpriteSheetData()

    local spriteNames = {}
    local spriteIndexLookup = {}

    for index, value in ipairs( spriteSheetData.frames ) do
        spriteNames[ index ] = value.name
        spriteIndexLookup[ value.name ] = index
    end

    self.spriteIndexLookup = spriteIndexLookup
    self.spriteNames = spriteNames
    self.spriteSheetData = spriteSheetData
end

--- Description.
-- @name getData
-- @return description.
-- @usage example
-- @see class
function CLASS:getData()
    return self.spriteSheetData
end

--- Description.
-- @name getSpriteIndex
-- @param spriteName
-- @return description.
-- @usage example
-- @see class
function CLASS:getSpriteIndex( spriteName )
    return self.spriteIndexLookup[ spriteName ]
end

--- Description.
-- @name getSpriteNames
-- @return description.
-- @usage example
-- @see class
function CLASS:getSpriteNames()
    return self.spriteNames
end

return CLASS
