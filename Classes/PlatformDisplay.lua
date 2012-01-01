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
    self.findImage:__forget()
    self.getImageSuffixesForScale:__forget()
    self.getImageSuffixesSortedByScale:__forget()
end

CLASS.findImage = Data.memoize( function (
    self, imageFileName, imageRootPath, coronaPathType, dynamicScale
)
    if ( imageFileName == nil or imageFileName == "" ) then return nil end

    if ( imageRootPath ~= nil ) then
        imageRootPath = imageRootPath .. File.PATH_SEPARATOR
    else
        imageRootPath = ""
    end

    dynamicScale = dynamicScale or self:getDynamicScale()
    local imageSuffixes = self:getImageSuffixesForScale( dynamicScale )

    if ( Data.isNonEmptyTable( imageSuffixes ) ) then

        local _, _, imagePrefix, imageExt = string.find(
            imageFileName, "^(.*)%.(.-)$" )

        for _, entry in ipairs( imageSuffixes ) do
            local imageSuffix = entry.imageSuffix
            local imageScale = entry.scale

            local imageFileName = imagePrefix .. imageSuffix .. "." .. imageExt
            local checkedPath = imageRootPath .. imageFileName

            if ( File.getFilePath( checkedPath, coronaPathType ) )
            then
                return imageRootPath, imageFileName, imageScale
            end
        end
    end

    local checkedPath = imageRootPath .. imageFileName

    if ( File.getFilePath( checkedPath, coronaPathType ) == nil ) then
        return nil
    end

    return imageRootPath, imageFileName, 1
end )

function CLASS:getDisplayScale()
    local heightScale = display.contentScaleY
    local widthScale = display.contentScaleX

    if ( heightScale > widthScale ) then
        return heightScale
    else
        return widthScale
    end
end

CLASS.getImageSuffixesForScale = Data.memoize( function(
    self, scale
)
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

    return imageSuffixesForScale
end )

CLASS.getImageSuffixesSortedByScale = Data.memoize( function(
    self
)
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

    return imageSuffixesSortedByScale
end )

return CLASS
