--[[ CooL( Corona Object-Oriented Lua )
     https://github.com/dejayc/CooL
     Copyright 2011 Dejay Clayton

     All use of this file must comply with the Apache License,
     Version 2.0, under which this file is licensed:

     http://www.apache.org/licenses/LICENSE-2.0 --]]

local CLASSPATH = require( "classpath" )
local File = require( CLASSPATH.CooL.File )
local sprite = require( "sprite" )

local CLASS = autoclass( packagePath( ... ) )

function CLASS:getCoronaPathType()
    return self.coronaPathType
end

function CLASS:getDataFileName()
    return self.dataFileName
end

function CLASS:getImageFileName()
    return self.imageFileName
end

function CLASS:getIndexForSpriteName( spriteName )
    return self.spriteNameLookup[ spriteName ]
end

function CLASS:getSpriteSheetData()
    return self.spriteSheetData
end

function CLASS:release()
    if ( self.spriteSheet ~= nil ) then
        self.spriteSheet:dispose()
        self.spriteSheet = nil
    end
    if ( self.spriteSet ~= nil ) then
        self.spriteSet = nil
    end
end

function CLASS:prepare( dataFileName, imageFileName, coronaPathType )
    self:release()

    self.dataFileName = dataFileName
    self.imageFileName = imageFileName
    self.coronaPathType = coronaPathType

    local spriteSheetData = require( File.getRequirePath( dataFileName ) ).
        getSpriteSheetData()

    local spriteNames = {}
    local spriteIndexLookup = {}

    for index, value in ipairs( spriteSheetData.frames ) do
        spriteNames[ index ] = value.name
        spriteIndexLookup[ value.name ] = index
    end

    self.spriteSheetData = spriteSheetData
    self.spriteNames = spriteNames
    self.spriteIndexLookup = spriteIndexLookup
end

function CLASS:load()
    if ( spriteSheet == nil ) then
        self:release()

        self.spriteSheet = sprite.newSpriteSheetFromData(
            self.imageFileName, self.spriteSheetData, self.coronaPathType )

        self.spriteSet = sprite.newSpriteSet(
            self.spriteSheet, 1, table.getn( self.spriteNames ) )
    end
end

function CLASS:getSprite( spriteIndex )
    if ( type( spriteIndex ) == "string" ) then
        spriteIndex = self.spriteIndexLookup[ spriteIndex ]
    end

    if ( spriteIndex == nil ) then return nil end

    local thisSprite = sprite.newSprite( self.spriteSet )
    thisSprite.currentFrame = spriteIndex
    return thisSprite
end

return CLASS
