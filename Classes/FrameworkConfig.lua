--[[ CooL( Corona Object-Oriented Lua )
     https://github.com/dejayc/CooL
     Copyright 2011 Dejay Clayton

     All use of this file must comply with the Apache License,
     Version 2.0, under which this file is licensed:

     http://www.apache.org/licenses/LICENSE-2.0 --]]

local CLASSPATH = require( "classpath" )
local Data = require( CLASSPATH.CooL.Data )
local File = require( CLASSPATH.CooL.File )

local CLASS = autoextend( CLASSPATH.CooL.Config, packagePath( ... ) )

local defaults = {
    display = {
        scaling = {
            axis = "maxResScale",
            imageLookup = {
                tryFallback = true,
            },
        },
    },
}

function CLASS:init( ... )
    self.super:init( ... )
    self:setDefaultValues( defaults )

    self.memoized = {
        imageFileNameForScale = {},
        imageLookupForScale = {},
        imageLookupSortedByScale = nil,
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

    local imageLookups = self:getImageLookupForScale( scale )
    if ( imageLookups == nil or table.getn( imageLookups ) < 1 ) then
        local imagePath = File.getFilePath(
            imageRootPath .. imageFileName, coronaPathType )

        self.memoized.imageFileNameForScale[ memoizeIndex ] = imagePath
        return imagePath
    end

    local _, _, imagePrefix, imageExt = string.find(
        imageFileName, "^(.*)%.(.-)$" )

    local attempted = {}

    for _, imageLookup in ipairs( imageLookups ) do
        local imageSubdirs = imageLookup.subdir
        if ( imageSubdirs == nil ) then imageSubdirs = "" end

        if ( type( imageSubdirs ) ~= "table" ) then
            imageSubdirs = { imageSubdirs }
        end

        local imageSuffixes = imageLookup.suffix
        if ( imageSuffixes == nil ) then imageSuffixes = "" end

        if ( type( imageSuffixes ) ~= "table" ) then
            imageSuffixes = { imageSuffixes }
        end

        for _, imageSubdir in ipairs( imageSubdirs )
        do
            for _, imageSuffix in ipairs( imageSuffixes )
            do
                if ( imageSubdir ~= "" or imageSuffix ~= "" )
                then
                    local imagePath = imageRootPath
 
                    if ( imageSubdir ~= "" ) then
                        imagePath = imagePath .. imageSubdir ..
                            File.PATH_SEPARATOR
                    end

                    imagePath = imagePath .. imagePrefix .. imageSuffix ..
                        "." .. imageExt

                    if ( attempted[ imagePath ] == nil ) then
                        attempted[ imagePath ] = true

                        imagePath = File.getFilePath(
                            imagePath, coronaPathType )

                        if ( imagePath ~= nil ) then
                            self.memoized.imageFileNameForScale[
                                memoizeIndex ] = imagePath
                            return imagePath
                        end
                    end
                end
            end
        end
    end

    if ( not self:getImageLookupTryFallback() ) then return nil end

    local imagePath = imageRootPath .. imageFileName
    if ( attempted[ imagePath ] ~= nil ) then return nil end

    imagePath = File.getFilePath( imagePath, coronaPathType )
    self.memoized.imageFileNameForScale[ memoizeIndex ] = imagePath
    return imagePath
end

function CLASS:getImageLookup()
    return self:getValue( false, "display", "scaling", "imageLookup" )
end

function CLASS:getImageLookupForScale( scale )
    if ( self.memoized.imageLookupForScale[ scale ] ~= nil ) then
        return self.memoized.imageLookupForScale[ scale ]
    end

    local imageLookup = {}
    local imageLookupSortedByScale = self:getImageLookupSortedByScale()

    if ( imageLookupSortedByScale ~= nil ) then
        if ( scale >= 1 ) then
            for _, entry in ipairs( imageLookupSortedByScale ) do
                if ( entry.scale > scale ) then break end

                if ( entry.scale >= 1 ) then
                    local index = 1
                    for _, lookup in pairs( entry.lookup ) do
                        table.insert( imageLookup, index, lookup )
                        index = index + 1
                    end
                end
            end
        else
            for _, entry in ipairs( imageLookupSortedByScale ) do
                if ( entry.scale > 1 ) then break end

                if ( entry.scale >= scale ) then
                    for _, lookup in pairs( entry.lookup ) do
                        table.insert( imageLookup, lookup )
                    end
                end
            end
        end
    end

    self.memoized.imageLookupForScale[ scale ] = imageLookup
    return imageLookup
end

function CLASS:getImageLookupSortedByScale()
    if ( self.memoized.imageLookupSortedByScale ~= nil ) then
        return self.memoized.imageLookupSortedByScale
    end

    local imageLookup = self:getImageLookup()
    if ( imageLookup == nil ) then return nil end

    local imageScales = Data.getNumericKeysSorted( imageLookup )
    local imageLookupSortedByScale = {}

    for _, scale in pairs( imageScales ) do
        table.insert( imageLookupSortedByScale, {
            scale = scale,
            lookup = imageLookup[ scale ] } )
    end

    self.memoized.imageLookupSortedByScale = imageLookupSortedByScale
    return imageLookupSortedByScale
end

function CLASS:getImageLookupTryFallback( useDefaultIfNil )
    return self:getValue(
        useDefaultIfNil, "display", "scaling", "imageLookup", "tryFallback" )
end

function CLASS:getScalingAxis( useDefaultIfNil )
    return self:getValue( useDefaultIfNil, "display", "scaling", "axis" )
end

function CLASS:getStatusBar()
    return self:getValue( true, "display", "statusBar" )
end

return CLASS
