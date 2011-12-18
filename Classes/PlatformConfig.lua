--[[ CooL( Corona Object-Oriented Lua )
     https://github.com/dejayc/CooL
     Copyright 2011 Dejay Clayton

     All use of this file must comply with the Apache License,
     Version 2.0, under which this file is licensed:

     http://www.apache.org/licenses/LICENSE-2.0 --]]

local CLASSPATH = require( "classpath" )
local File = require( CLASSPATH.CooL.File )

local CLASS = autoextend( CLASSPATH.CooL.Config, packagePath( ... ) )

function CLASS:init( ... )
    self.super.init( self, ... )

    self.memoized = {
        imageFileNameForScale = {},
        imageSuffixesForScale = {},
    }
end

function CLASS:findImageFileNameForScale(
    imageFileName, imageRootPath, coronaPathType, scale
)
    if ( imageFileName == nil or imageFileName == "" ) then return nil end

    local memoizeIndex = string.format( "%s:%s:%s:%s",
        tostring( imageFileName ), tostring( imageRootPath ),
        tostring( coronaPathType ), tostring( scale ) )

    if ( self.memoized.imageFileNameForScale[ memoizeIndex ] ~= nil ) then
        return self.memoized.imageFileNameForScale[ memoizeIndex ]
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

        self.memoized.imageFileNameForScale[ memoizeIndex ] = imagePath
        return imagePath
    end

    local _, _, imagePrefix, imageExt = string.find(
        imageFileName, "^(.*)%.(.-)$" )

    for _, imageSuffix in ipairs( imageSuffixes ) do
        local imagePath = File.getFilePath(
            imageRootPath .. imagePrefix .. imageSuffix ..  "." .. imageExt,
            coronaPathType )

        if ( imagePath ~= nil ) then
            self.memoized.imageFileNameForScale[ memoizeIndex ] = imagePath
            return imagePath
        end
    end

    local imagePath = File.getFilePath(
        imageRootPath .. imageFileName, coronaPathType )

    self.memoized.imageFileNameForScale[ memoizeIndex ] = imagePath
    return imagePath
end

function CLASS:getImageSuffix()
    printf( "imageSuffix: [%s]", self:getValues().content.imageSuffix[ "@160x240" ] )
    return self:getValue( false, "content", "imageSuffix" )
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
                    table.insert( imageSuffixesForScale, 1, entry.suffix )
                end
            end
        else
            for _, entry in ipairs( imageSuffixesSortedByScale ) do
                if ( entry.scale > 1 ) then break end

                if ( entry.scale >= scale ) then
                    table.insert( imageSuffixesForScale, entry.suffix )
                end
            end
        end
    end

    self.memoized.imageSuffixesForScale[ scale ] = imageSuffixesForScale
    return imageSuffixesForScale
end

function CLASS:getImageSuffixesSortedByScale()
    local imageSuffix = self:getImageSuffix()
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
end

function CLASS:test()
    printf( "imageSuffix: [%s]", self:getValues().content.imageSuffix[ "@160x240" ] )
end

return CLASS
