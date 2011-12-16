--[[ CooL( Corona Object-Oriented Lua )
     https://github.com/dejayc/CooL
     Copyright 2011 Dejay Clayton

     All use of this file must comply with the Apache License,
     Version 2.0, under which this file is licensed:

     http://www.apache.org/licenses/LICENSE-2.0 --]]

local CLASSPATH = require( "classpath" )

local CLASS = autoextend( CLASSPATH.CooL.Config, packagePath( ... ) )

function CLASS:init( ... )
    self.super:init( ... )
    self.memoized = {
        imageFileNameForScale = {},
        imageSuffixesForScale = {},
    }
end

function CLASS:getImageFileNameForScale(
    imageFileName, imageRootPath, coronaPathType, scale
)
    if ( imageFileName == nil or imageFileName == "" ) then return nil end

    local memoizeIndex = string.format( "%s:%s:%s:%s",
        tostring( imageFileName ), tostring( imageRootPath ),
        tostring( coronaPathType ), tostring( scale ) )

    if ( self.memoized.imageFileNameForScale[ memoizeIndex ] ~= nil )
    then
        return self.memoized.imageFileNameForScale[ memoizeIndex ]
    end

    if ( imageRootPath ~= nil ) then
        imageRootPath = imageRootPath .. File.PATH_SEPARATOR
    else
        imageRootPath = ""
    end

    local imageSuffixes = self:getImageSuffixesForScale( scale )
    if ( imageSuffixes == nil or table.getn( imageSuffixes ) < 1 )
    then
        local filePath = File.getFilePath(
            imageRootPath .. imageFileName, coronaPathType )

        self.memoized.imageFileNameForScale[ memoizeIndex ] = filePath
        return filePath
    end

    local _, _, imagePrefix, imageExt = string.find(
        imageFileName, "^(.*)%.(.-)$" )

    for _, imageSuffix in ipairs( imageSuffixes ) do
        local filePath = File.getFilePath(
            imageRootPath .. imagePrefix .. imageSuffix ..  "." .. imageExt,
            coronaPathType )

        if ( filePath ~= nil ) then
            self.memoized.imageFileNameForScale[ memoizeIndex ] = filePath
            return filePath
        end
    end

    self.memoized.imageFileNameForScale[ memoizeIndex ] = filePath
    return File.getFilePath( imageRootPath .. imageFileName, coronaPathType )
end

function CLASS:getImageSuffixes()
    return self:getValue( "content", "imageSuffix" )
end

function CLASS:getImageSuffixesForScale( scale )
    if ( self.memoized.imageSuffixesForScale[ scale ] ~= nil )
    then
        return self.memoized.imageSuffixesForScale[ scale ]
    end

    local imageSuffixes = {}
    local imageSuffixesSorted = self:getImageSuffixesSortedByScale()

    if ( imageSuffixesSorted ~= nil ) then
        if ( scale >= 1 ) then
            for _, entry in ipairs( imageSuffixesSorted ) do
                if ( entry.scale > scale ) then break end

                if ( entry.scale >= 1 ) then
                    table.insert( imageSuffixes, 1, entry.suffix )
                end
            end
        else
            for _, entry in ipairs( imageSuffixesSorted ) do
                if ( entry.scale > 1 ) then break end

                if ( entry.scale >= scale ) then
                    table.insert( imageSuffixes, entry.suffix )
                end
            end
        end
    end

    self.memoized.imageSuffixesForScale[ scale ] = imageSuffixes
    return imageSuffixes
end

function CLASS:getImageSuffixesSortedByScale()
    local imageSuffixes = self:getImageSuffixes()
    if ( imageSuffixes == nil ) then return nil end

    local imageScales = {}
    local imageSuffixesByScale = {}
    for suffix, scale in pairs( imageSuffixes ) do
        if ( type( scale ) == "number" ) then
            table.insert( imageScales, scale )
            imageSuffixesByScale[ scale ] = suffix
        end
    end

    table.sort( imageScales )

    local imageSuffixesSorted = {}
    for _, scale in pairs( imageScales ) do
        table.insert( imageSuffixesSorted, {
            scale = scale,
            suffix = imageSuffixesByScale[ scale ] } )
    end

    return imageSuffixesSorted
end

return CLASS
