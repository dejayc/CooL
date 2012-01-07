--[[ CooL( Corona Object-Oriented Lua )
     https://github.com/dejayc/CooL
     Copyright 2011 Dejay Clayton

     All use of this file must comply with the Apache License,
     Version 2.0, under which this file is licensed:

     http://www.apache.org/licenses/LICENSE-2.0 --]]

local CLASSPATH = require( "classpath" )
local Data = require( CLASSPATH.CooL.Data )
local File = require( CLASSPATH.CooL.File )

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

function CLASS:prepare( dataFileName, imageFileName, coronaPathType )
    self:release()

    self.dataFileName = dataFileName
    self.imageFileName = imageFileName
    self.coronaPathType = coronaPathType

    local spriteSheetData = require( Data.getRequirePath( dataFileName ) ).
        spriteSheetMethod.getSpriteSheetData()
    local spriteNameLookup = {}

    for index, value in ipairs( spriteSheetData.sheet.frames ) do
        spriteNameLookup[ value.name ] = index
    end

    self.spriteSheetData = spriteSheetData
    self.spriteNameLookup = spriteNameLookup
end

function CLASS:load()
    if ( spriteSheet == nil ) then
        self:release()
        self.spriteSheet = sprite.newSpriteSheetFromData(
            self.imageFileName, self.spriteSheetData, self.coronaPathType )
        self.spriteSet = sprite.newSpriteSet(
            self.spriteSheet, 1, table.getn( self.spriteNameLookup ) )
    end
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

function CLASS:getSprite( spriteName )
    local spriteIndex = self.spriteNameLookup[ spriteName ]
    if ( spriteIndex == nil ) then return nil end

    local thisSprite = sprite.newSprite( self.spriteSet )
    thisSprite.currentFrame = spriteIndex
    return thisSprite
end

return CLASS
