--[[ CooL( Corona Object-Oriented Lua )
     https://github.com/dejayc/CooL
     Copyright 2011 Dejay Clayton

     All use of this file must comply with the Apache License,
     Version 2.0, under which this file is licensed:

     http://www.apache.org/licenses/LICENSE-2.0 --]]

local CLASSPATH = require( "classpath" )
local ClassHelper = require( CLASSPATH.CooL.ClassHelper )
local DataHelper = require( CLASSPATH.CooL.DataHelper )
local FileHelper = require( CLASSPATH.CooL.FileHelper )
local sprite = require( "sprite" )

local CLASS = ClassHelper.autoclass( ClassHelper.getPackagePath( ... ) )

CLASS.DEFAULT_DATA_EXTENSION = "lua"
CLASS.DEFAULT_IMAGE_EXTENSION = "png"

function CLASS:getCoronaPathType()
    return self.coronaPathType
end

function CLASS:getDataFileName()
    return self.dataFileName
end

function CLASS:getImageFileName()
    return self.imageFileName
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

--[[
    Possible scenarios:

    01: "spritesheet.lua", "spritesheet.png"
    02: "spritesheet", "spritesheet.png"
    03: "spritesheet", ".png"
    04: "spritesheet", "png"
    05: "spritesheet", ".graphics"
    06: "spritesheet", "graphics"
    07: "spritesheet", "graphics.png"
    08: "spritesheet", ""
    09: "spritesheet", nil

    Scenario results:
    01: ( "spritesheet.lua", "spritesheet.png" ) will be loaded.
    02: ( "spritesheet.lua", "spritesheet.png" ) will be loaded.
    03: ( "spritesheet.lua", "spritesheet.png" ) will be loaded.
    04: ( "spritesheet.lua", "spritesheet.png" ) will be loaded.
    05: ( "spritesheet.lua", "spritesheet.graphics" ) will be loaded. ERROR
    06: ( "spritesheet.lua", "spritesheet.graphics" ) will be loaded. ERROR
    07: ( "spritesheet.lua", "graphics.png" ) will be loaded.
    08: ( "spritesheet.lua", "spritesheet.png" ) will be loaded.
    09: ( "spritesheet.lua", "spritesheet.png" ) will be loaded.

    Business rules:
    A. If "dataFileName" is missing a file extension, default to ".lua"
    B. If "imageFileName" is missing a file extension, treat "imageFileName"
       as a file extension, with the file base supplied by "dataFileName"
--]]
    local dataFilePath, dataFileBaseName, dataFileExt =
        FileHelper.getPathComponents( dataFileName )

    local imageFilePath, imageFileBaseName, imageFileExt =
        FileHelper.getPathComponents( imageFileName )

    if ( DataHelper.compareString(
         imageFileExt, FileHelper.LUA_FILE_EXTENSION, true ) )
    then
        imageFileExt = CLASS.DEFAULT_IMAGE_EXTENSION
    end

    self.dataFileName = dataFileName

    if ( not DataHelper.hasValue( imageFileName ) ) then

        if ( imageExt ~= nil ) then
        end
    end

    self.imageFileName = imageFileName
    self.coronaPathType = coronaPathType

    local spriteSheetData = ClassHelper.new( CLASSPATH.CooL.SpriteSheetData )
    spriteSheetData.load( dataFileName )

    self.spriteSheetData = spriteSheetData
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
