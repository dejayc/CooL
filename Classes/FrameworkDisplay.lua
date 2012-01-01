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
    self.findImage:__forget()
    self.getDisplayScale:__forget()
    self.getImageLookupsForScale:__forget()
    self.getImageLookupsSortedByScale:__forget()
end

CLASS.findImage = Data.memoize( function(
    self, imageFileName, imageRootPath, coronaPathType, dynamicScale
)
    if ( imageFileName == nil or imageFileName == "" ) then return nil end

    if ( imageRootPath ~= nil ) then
        imageRootPath = imageRootPath .. File.PATH_SEPARATOR
    else
        imageRootPath = ""
    end

    dynamicScale = dynamicScale or self:getDynamicScale()
    local imageLookups = self:getImageLookupsForScale( dynamicScale )

    if ( Data.isNonEmptyTable( imageLookups ) ) then

        local _, _, imagePrefix, imageExt = string.find(
            imageFileName, "^(.*)%.(.-)$" )

        local checkedPaths = {}

        for _, entry in ipairs( imageLookups ) do
            local imageLookup = entry.lookup
            local imageScale = entry.scale

            local imageSubdirs = imageLookup.subdir
            if ( imageSubdirs == nil ) then imageSubdirs = { "" } end

            if ( type( imageSubdirs ) ~= "table" ) then
                imageSubdirs = { imageSubdirs }
            end

            local imageSuffixes = imageLookup.suffix
            if ( imageSuffixes == nil ) then imageSuffixes = { "" } end

            if ( type( imageSuffixes ) ~= "table" ) then
                imageSuffixes = { imageSuffixes }
            end

            for _, imageSubdir in ipairs( imageSubdirs )
            do
                for _, imageSuffix in ipairs( imageSuffixes )
                do
                    -- Skip the check when imageSubdir and imageSuffix are both
                    -- empty, as that condition will be checked last, when the
                    -- default directory and filename are checked.
                    if ( imageSubdir ~= "" or imageSuffix ~= "" )
                    then
                        local imagePath = imageRootPath

                        if ( imageSubdir ~= "" ) then
                            imagePath = imagePath .. imageSubdir ..
                                File.PATH_SEPARATOR
                        end

                        local imageFileName =
                            imagePrefix .. imageSuffix .. "." .. imageExt
                        local checkedPath = imagePath .. imageFileName

                        if ( checkedPaths[ checkedPath ] == nil ) then
                            checkedPaths[ checkedPath ] = true

                            if ( File.getFilePath(
                                checkedPath, coronaPathType ) ~= nil )
                            then
                                return imagePath, imageFileName, imageScale
                            end
                        end
                    end
                end
            end
        end
    end

    if ( not self:getFrameworkConfig():getImageLookupTryFallback() ) then
        return nil
    end

    local checkedPath = imageRootPath .. imageFileName

    if ( File.getFilePath( checkedPath, coronaPathType ) == nil ) then
        return nil
    end

    return imageRootPath, imageFileName, 1
end )

CLASS.getDisplayScale = Data.memoize( function(
    self, scalingAxis
)
    scalingAxis = scalingAxis or self:getFrameworkConfig():getScalingAxis()

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
    return displayScale
end )

CLASS.getImageLookupsForScale = Data.memoize( function(
    self, scale
)
    local imageLookupsForScale = {}
    local imageLookupsSortedByScale = self:getImageLookupsSortedByScale()

    if ( imageLookupsSortedByScale ~= nil ) then
        if ( scale >= 1 ) then
            for _, entry in ipairs( imageLookupsSortedByScale ) do
                if ( entry.scale > scale ) then break end

                if ( entry.scale >= 1 ) then
                    local index = 1
                    for _, lookup in pairs( entry.lookup ) do
                        table.insert( imageLookupsForScale, index,
                            { lookup = lookup, scale = entry.scale } )
                        index = index + 1
                    end
                end
            end
        else
            for _, entry in ipairs( imageLookupsSortedByScale ) do
                if ( entry.scale > 1 ) then break end

                if ( entry.scale >= scale ) then
                    for _, lookup in pairs( entry.lookup ) do
                        table.insert( imageLookupsForScale,
                            { lookup = lookup, scale = entry.scale } )
                    end
                end
            end
        end
    end

    return imageLookupsForScale
end )

CLASS.getImageLookupsSortedByScale = Data.memoize( function(
    self
)
    local imageLookup = self:getFrameworkConfig():getImageLookup()
    if ( imageLookup == nil ) then return nil end

    local imageScales = Data.getNumericKeysSorted( imageLookup )
    local imageLookupsSortedByScale = {}

    for _, scale in pairs( imageScales ) do
        table.insert( imageLookupsSortedByScale, {
            scale = scale,
            lookup = imageLookup[ scale ] } )
    end

    return imageLookupsSortedByScale
end )

return CLASS
