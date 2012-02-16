--[[ CooL( Corona Object-Oriented Lua )
     https://github.com/dejayc/CooL
     Copyright 2011 Dejay Clayton

     All use of this file must comply with the Apache License,
     Version 2.0, under which this file is licensed:

     http://www.apache.org/licenses/LICENSE-2.0 --]]

local CLASSPATH = require( "classpath" )
local ClassHelper = require( CLASSPATH.CooL.ClassHelper )
local FileHelper = require( CLASSPATH.CooL.FileHelper )

local CLASS = ClassHelper.autoclass( ClassHelper.getPackagePath( ... ) )

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

function CLASS:getData()
    return self.spriteSheetData
end

function CLASS:getSpriteIndex( spriteName )
    return self.spriteIndexLookup[ spriteName ]
end

function CLASS:getSpriteNames()
    return self.spriteNames
end

return CLASS
