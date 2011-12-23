--[[ CooL( Corona Object-Oriented Lua )
     https://github.com/dejayc/CooL
     Copyright 2011 Dejay Clayton

     All use of this file must comply with the Apache License,
     Version 2.0, under which this file is licensed:

     http://www.apache.org/licenses/LICENSE-2.0 --]]

local CLASSPATH = require( "classpath" )
local Data = require( CLASSPATH.CooL.Data )
local File = require( CLASSPATH.CooL.File )

local CLASS = autoextend( CLASSPATH.CooL.Display, packagePath( ... ) )

function CLASS:init( platformConfig, ... )
    self.super.init( self, platformConfig, ... )
    self:setPlatformConfig( platformConfig )
end

function CLASS:getPlatformConfig()
    return self.platformConfig
end

function CLASS:setPlatformConfig( platformConfig )
    self.platformConfig = platformConfig 
    self:refreshConfig()
end

function CLASS:refreshConfig()
    self.memoized = {
        imageForScale = {},
        imageSuffixesForScale = {},
        imageSuffixesSortedByScale = nil,
    }
end

function CLASS:findImageForScale(
    imageFileName, imageRootPath, coronaPathType, scale
)
    if ( imageFileName == nil or imageFileName == "" ) then return nil end

    scale = scale or self:getDynamicScale()

    local memoizeIndex = string.format( "%s:%s:%s:%s",
        tostring( imageFileName ), tostring( imageRootPath ),
        tostring( coronaPathType ), tostring( scale ) )

    if ( self.memoized.imageForScale[ memoizeIndex ] ~= nil ) then
        return
            self.memoized.imageForScale[ memoizeIndex ].imagePath,
            self.memoized.imageForScale[ memoizeIndex ].scale
    end

    if ( imageRootPath ~= nil ) then
        imageRootPath = imageRootPath .. File.PATH_SEPARATOR
    else
        imageRootPath = ""
    end

    local imageSuffixes = self:getImageSuffixesForScale( scale )
    if ( imageSuffixes == nil or table.getn( imageSuffixes ) < 1 ) then
        local imagePath = File.getFilePath(
            imageRootPath .. imageFileName, coronaPathType )

        self.memoized.imageForScale[ memoizeIndex ] = {
            imagePath = imagePath, scale = 1
        }
        return imagePath, 1
    end

    local _, _, imagePrefix, imageExt = string.find(
        imageFileName, "^(.*)%.(.-)$" )

    for _, entry in ipairs( imageSuffixes ) do
        local imageSuffix = entry.imageSuffix
        local imageScale = entry.scale

        local imagePath = File.getFilePath(
            imageRootPath .. imagePrefix .. imageSuffix ..  "." .. imageExt,
            coronaPathType )

        if ( imagePath ~= nil ) then
            self.memoized.imageForScale[ memoizeIndex ] = {
                imagePath = imagePath, scale = imageScale
            }
            return imagePath, imageScale
        end
    end

    local imagePath = File.getFilePath(
        imageRootPath .. imageFileName, coronaPathType )

    self.memoized.imageForScale[ memoizeIndex ] = {
        imagePath = imagePath, scale = 1
    }
    return imagePath, 1
end

function CLASS:getDisplayScale()
    local heightScale = display.contentScaleY
    local widthScale = display.contentScaleX

    if ( heightScale > widthScale ) then
        return heightScale
    else
        return widthScale
    end
end

function CLASS:getImageSuffixesForScale( scale )
    if ( self.memoized.imageSuffixesForScale[ scale ] ~= nil ) then
        return self.memoized.imageSuffixesForScale[ scale ]
    end

    local imageSuffixesForScale = {}
    local imageSuffixesSortedByScale = self:getImageSuffixesSortedByScale()

    if ( imageSuffixesSortedByScale ~= nil ) then
        if ( scale >= 1 ) then
            for _, entry in ipairs( imageSuffixesSortedByScale ) do
                if ( entry.scale > scale ) then break end

                if ( entry.scale >= 1 ) then
                    table.insert( imageSuffixesForScale, 1, {
                        imageSuffix = entry.suffix, scale = entry.scale } )
                end
            end
        else
            for _, entry in ipairs( imageSuffixesSortedByScale ) do
                if ( entry.scale > 1 ) then break end

                if ( entry.scale >= scale ) then
                    table.insert( imageSuffixesForScale, {
                        imageSuffix = entry.suffix, scale = entry.scale } )
                end
            end
        end
    end

    self.memoized.imageSuffixesForScale[ scale ] = imageSuffixesForScale
    return imageSuffixesForScale
end

function CLASS:getImageSuffixesSortedByScale()
    if ( self.memoized.imageSuffixesSortedByScale ~= nil ) then
        return self.memoized.imageSuffixesSortedByScale
    end

    local imageSuffix = self:getPlatformConfig():getImageSuffix()
    if ( imageSuffix == nil ) then return nil end

    local imageScales = {}
    local imageSuffixesByScale = {}
    for suffix, scale in pairs( imageSuffix ) do
        if ( type( scale ) == "number" ) then
            table.insert( imageScales, scale )
            imageSuffixesByScale[ scale ] = suffix
        end
    end

    table.sort( imageScales )

    local imageSuffixesSortedByScale = {}
    for _, scale in pairs( imageScales ) do
        table.insert( imageSuffixesSortedByScale, {
            scale = scale,
            suffix = imageSuffixesByScale[ scale ] } )
    end

    self.memoized.imageSuffixesSortedByScale = imageSuffixesSortedByScale
    return imageSuffixesSortedByScale
end

return CLASS
