--[[ CooL( Corona Object-Oriented Lua )
     https://github.com/dejayc/CooL
     Copyright 2011 Dejay Clayton

     All use of this file must comply with the Apache License,
     Version 2.0, under which this file is licensed:

     http://www.apache.org/licenses/LICENSE-2.0 --]]

local CLASSPATH = require( "classpath" )
local DataHelper = require( CLASSPATH.CooL.DataHelper )
local DisplayHelper = require( CLASSPATH.CooL.DisplayHelper )
local FileHelper = require( CLASSPATH.CooL.FileHelper )

local CLASS = autoclass( packagePath( ... ) )

function CLASS:init( platformConfig, ... )
    self.imageSuffix = platformConfig:getImageSuffix()
end

CLASS.findImage = DataHelper.memoize( function (
    self, imageFileName, imageRootPath, coronaPathType, dynamicScale
)
    local hasDefaultArguments = false

    if ( imageFileName == nil ) then
        imageFileName = ""
        hasDefaultArguments = true
    end

    if ( imageRootPath == nil ) then
        imageRootPath = ""
        hasDefaultArguments = true
    end

    if ( coronaPathType == nil ) then
        coronaPathType = system.ResourceDirectory
        hasDefaultArguments = true
    end

    if ( dynamicScale == nil ) then
        dynamicScale = DisplayHelper.getDynamicScale()
        hasDefaultArguments = true
    end

    -- If default values have been used, call the method again with the
    -- default values so that the results are memoized for both method
    -- invocations.
    if ( hasDefaultArguments ) then
        return self:findImage(
            imageFileName, imageRootPath, coronaPathType, dynamicScale )
    end

    if ( imageFileName == nil or imageFileName == "" ) then return nil end

    if ( imageRootPath ~= nil ) then
        imageRootPath = imageRootPath .. FileHelper.PATH_SEPARATOR
    else
        imageRootPath = ""
    end

    local imageSuffixes = self:getImageSuffixesForScale( dynamicScale )

    if ( DataHelper.isNonEmptyTable( imageSuffixes ) ) then

        local _, _, imagePrefix, imageExt = string.find(
            imageFileName, "^(.*)%.(.-)$" )

        for _, entry in ipairs( imageSuffixes ) do
            local imageSuffix = entry.imageSuffix
            local imageScale = entry.scale

            local imageFileName = imagePrefix .. imageSuffix .. "." .. imageExt
            local checkedPath = imageRootPath .. imageFileName

            if ( FileHelper.getFilePath( checkedPath, coronaPathType ) )
            then
                return imageRootPath, imageFileName, imageScale
            end
        end
    end

    local checkedPath = imageRootPath .. imageFileName

    if ( FileHelper.getFilePath( checkedPath, coronaPathType ) == nil ) then
        return nil
    end

    return imageRootPath, imageFileName, 1
end )

function CLASS:getImageSuffix()
    return self.imageSuffix
end

CLASS.getImageSuffixesForScale = DataHelper.memoize( function(
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

CLASS.getImageSuffixesSortedByScale = DataHelper.memoize( function(
    self
)
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
end )

return CLASS
