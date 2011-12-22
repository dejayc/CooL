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

function CLASS:init( frameworkConfig, ... )
    self.super.init( self, frameworkConfig, ... )
    self:setFrameworkConfig( frameworkConfig )
    self.setStatusBar( self:getFrameworkConfig():getStatusBar() )
end

function CLASS:getFrameworkConfig()
    return self.frameworkConfig
end

function CLASS:setFrameworkConfig( frameworkConfig )
    self.frameworkConfig = frameworkConfig 
    self:refreshConfig()
end

function CLASS:refreshConfig()
    self.memoized = {
        displayScale = {}, 
        imageFileNameForScale = {},
        imageLookupsForScale = {},
        imageLookupsSortedByScale = nil,
    }
end

function CLASS:findImageFileNameForScale(
    imageFileName, imageRootPath, coronaPathType, scale
)
    if ( imageFileName == nil or imageFileName == "" ) then return nil end

    scale = scale or self:getDynamicScale()

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

    local imageLookups = self:getImageLookupsForScale( scale )
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

    if ( not self:getFrameworkConfig():getImageLookupTryFallback() ) then
        return nil
    end

    local imagePath = imageRootPath .. imageFileName
    if ( attempted[ imagePath ] ~= nil ) then return nil end

    imagePath = File.getFilePath( imagePath, coronaPathType )
    self.memoized.imageFileNameForScale[ memoizeIndex ] = imagePath
    return imagePath
end

function CLASS:getDisplayScale( scalingAxis )
    scalingAxis = scalingAxis or self:getFrameworkConfig():getScalingAxis()

    if ( self.memoized.displayScale[ scalingAxis ] ~= nil ) then
        return self.memoized.displayScale[ scalingAxis ]
    end

    local displayScale = nil
    local height = CLASS.getDisplayHeight()
    local heightScale = display.contentScaleY
    local width = CLASS.getDisplayWidth()
    local widthScale = display.contentScaleX

    if ( scalingAxis == "minScale" ) then
        if ( heightScale < widthScale ) then
            displayScale = widthScale
        else
            displayScale = heightScale
        end
    elseif ( scalingAxis == "maxScale" ) then
        if ( heightScale > widthScale ) then
            displayScale = widthScale
        else
            displayScale = heightScale
        end
    elseif ( scalingAxis == "minResScale" ) then
        if ( height < width ) then
            displayScale = heightScale
        else
            displayScale = widthScale
        end
    elseif ( scalingAxis == "maxResScale" ) then
        if ( height > width ) then
            displayScale = heightScale
        else
            displayScale = widthScale
        end
    elseif ( scalingAxis == "widthScale" ) then
        if ( orientation == "landscape" )
        then
            displayScale = widthScale
        else
            displayScale = heightScale
        end
    elseif ( scalingAxis == "heightScale" ) then
        if ( orientation == "landscape" )
        then
            displayScale = heightScale
        else
            displayScale = widthScale
        end
    end
    self.memoized.displayScale[ scalingAxis ] = displayScale
    return displayScale
end

function CLASS:getImageLookupsForScale( scale )
    if ( self.memoized.imageLookupsForScale[ scale ] ~= nil ) then
        return self.memoized.imageLookupsForScale[ scale ]
    end

    local imageLookupsForScale = {}
    local imageLookupsSortedByScale = self:getImageLookupsSortedByScale()

    if ( imageLookupsSortedByScale ~= nil ) then
        if ( scale >= 1 ) then
            for _, entry in ipairs( imageLookupsSortedByScale ) do
                if ( entry.scale > scale ) then break end

                if ( entry.scale >= 1 ) then
                    local index = 1
                    for _, lookup in pairs( entry.lookup ) do
                        table.insert( imageLookupsForScale, index, lookup )
                        index = index + 1
                    end
                end
            end
        else
            for _, entry in ipairs( imageLookupsSortedByScale ) do
                if ( entry.scale > 1 ) then break end

                if ( entry.scale >= scale ) then
                    for _, lookup in pairs( entry.lookup ) do
                        table.insert( imageLookupsForScale, lookup )
                    end
                end
            end
        end
    end

    self.memoized.imageLookupsForScale[ scale ] = imageLookupsForScale
    return imageLookupsForScale
end

function CLASS:getImageLookupsSortedByScale()
    if ( self.memoized.imageLookupsSortedByScale ~= nil ) then
        return self.memoized.imageLookupsSortedByScale
    end

    local imageLookup = self:getFrameworkConfig():getImageLookup()
    if ( imageLookup == nil ) then return nil end

    local imageScales = Data.getNumericKeysSorted( imageLookup )
    local imageLookupsSortedByScale = {}

    for _, scale in pairs( imageScales ) do
        table.insert( imageLookupsSortedByScale, {
            scale = scale,
            lookup = imageLookup[ scale ] } )
    end

    self.memoized.imageLookupsSortedByScale = imageLookupsSortedByScale
    return imageLookupsSortedByScale
end

return CLASS
