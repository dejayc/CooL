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

CLASS.findFileByScale = DataHelper.memoize( function (
    self, fileName, rootPath, coronaPathType, dynamicScale
)
    local hasDefaultArguments = false

    if ( fileName == nil ) then
        fileName = ""
        hasDefaultArguments = true
    end

    if ( rootPath == nil ) then
        rootPath = ""
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
        return self:findFileByScale(
            fileName, rootPath, coronaPathType, dynamicScale )
    end

    if ( fileName == nil or fileName == "" ) then return nil end

    if ( rootPath ~= nil ) then
        rootPath = rootPath .. FileHelper.PATH_SEPARATOR
    else
        rootPath = ""
    end

    local imageSuffixes = self:getImageSuffixesForScale( dynamicScale )

    if ( DataHelper.isNonEmptyTable( imageSuffixes ) ) then

        local _, _, filePrefix, fileExt = string.find(
            fileName, "^(.*)%.(.-)$" )

        for _, entry in ipairs( imageSuffixes ) do
            local imageSuffix = entry.imageSuffix
            local imageScale = entry.scale

            local checkedFileName = filePrefix .. imageSuffix .. "." .. fileExt
            local checkedPath = rootPath .. fileName

            if ( FileHelper.getFilePath( checkedPath, coronaPathType ) )
            then
                return rootPath, fileName, imageScale
            end
        end
    end

    local checkedPath = rootPath .. fileName

    if ( FileHelper.getFilePath( checkedPath, coronaPathType ) == nil ) then
        return nil
    end

    return rootPath, fileName, 1
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
