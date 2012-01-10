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

function CLASS:init( frameworkConfig, ... )
    self.fileLookup = frameworkConfig:getFileLookup()
    self.scalingAxis = frameworkConfig:getScalingAxis()
    DisplayHelper.setStatusBar( frameworkConfig:getStatusBar() )
end

CLASS.findFileByScale = DataHelper.memoize( function(
    self, fileName, rootPath, coronaPathType, dynamicScale,
    bypassDefaultCheck
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
        dynamicScale = self:getDynamicScale()
        hasDefaultArguments = true
    end

    if ( bypassDefaultCheck == nil ) then
        bypassDefaultCheck = false
        hasDefaultArguments = true
    end

    -- If default values have been used, call the method again with the
    -- default values so that the results are memoized for both method
    -- invocations.
    if ( hasDefaultArguments ) then
        return self:findFileByScale(
            fileName, rootPath, coronaPathType, dynamicScale,
            bypassDefaultCheck )
    end

    if ( fileName == nil or fileName == "" ) then return nil end

    if ( rootPath ~= nil ) then
        rootPath = rootPath .. FileHelper.PATH_SEPARATOR
    else
        rootPath = ""
    end

    local fileLookups = self:getFileLookupsForScale( dynamicScale )

    if ( DataHelper.isNonEmptyTable( fileLookups ) ) then

        local _, _, filePrefix, fileExt = string.find(
            fileName, "^(.*)%.(.-)$" )

        local checkedPaths = {}

        for _, entry in ipairs( fileLookups ) do
            local fileLookup = entry.lookup
            local fileScale = entry.scale

            local subdirs = fileLookup.subdir
            if ( subdirs == nil ) then subdirs = { "" } end

            if ( type( subdirs ) ~= "table" ) then
                subdirs = { subdirs }
            end

            local suffixes = fileLookup.suffix
            if ( suffixes == nil ) then suffixes = { "" } end

            if ( type( suffixes ) ~= "table" ) then
                suffixes = { suffixes }
            end

            for _, subdir in ipairs( subdirs )
            do
                for _, suffix in ipairs( suffixes )
                do
                    -- Skip the check when subdir and suffix are both empty,
                    -- as that condition will be checked last, when the default
                    -- directory and filename are checked.
                    if ( subdir ~= "" or suffix ~= "" )
                    then
                        local filePath = rootPath

                        if ( subdir ~= "" ) then
                            filePath = filePath .. subdir ..
                                FileHelper.PATH_SEPARATOR
                        end

                        local checkedFileName =
                            filePrefix .. suffix .. "." .. fileExt
                        local checkedPath = filePath .. checkedFileName

                        if ( checkedPaths[ checkedPath ] == nil ) then
                            checkedPaths[ checkedPath ] = true

                            if ( FileHelper.getFilePath(
                                checkedPath, coronaPathType ) ~= nil )
                            then
                                return filePath, checkedFileName, fileScale
                            end
                        end
                    end
                end
            end
        end
    end

    if ( bypassDefaultCheck ) then
        return nil
    end

    local checkedPath = rootPath .. fileName

    if ( FileHelper.getFilePath( checkedPath, coronaPathType ) == nil ) then
        return nil
    end

    return rootPath, fileName, 1
end )

CLASS.getDisplayScale = DataHelper.memoize( function(
    self, scalingAxis
)
    local hasDefaultArguments = false

    if ( scalingAxis == nil ) then
        scalingAxis = self:getScalingAxis()
        hasDefaultArguments = true
    end

    -- If default values have been used, call the method again with the
    -- default values so that the results are memoized for both method
    -- invocations.
    if ( hasDefaultArguments ) then
        return self:getDisplayScale( scalingAxis )
    end

    local displayScale = nil
    local height = DisplayHelper.getDisplayHeight()
    local heightScale = display.contentScaleY
    local width = DisplayHelper.getDisplayWidth()
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

function CLASS:getDynamicScale()
    return DataHelper.roundNumber( 1 / self:getDisplayScale(), 3 )
end

function CLASS:getFileLookup()
    return self.fileLookup
end

function CLASS:hasFileLookup()
    return DataHelper.hasValue( self.fileLookup )
end

CLASS.getFileLookupsForScale = DataHelper.memoize( function(
    self, scale
)
    local fileLookupsForScale = {}
    local fileLookupsSortedByScale = self:getFileLookupsSortedByScale()

    if ( fileLookupsSortedByScale ~= nil ) then
        if ( scale >= 1 ) then
            for _, entry in ipairs( fileLookupsSortedByScale ) do
                if ( entry.scale > scale ) then break end

                if ( entry.scale >= 1 ) then
                    local index = 1
                    for _, lookup in pairs( entry.lookup ) do
                        table.insert( fileLookupsForScale, index,
                            { lookup = lookup, scale = entry.scale } )
                        index = index + 1
                    end
                end
            end
        else
            for _, entry in ipairs( fileLookupsSortedByScale ) do
                if ( entry.scale > 1 ) then break end

                if ( entry.scale >= scale ) then
                    for _, lookup in pairs( entry.lookup ) do
                        table.insert( fileLookupsForScale,
                            { lookup = lookup, scale = entry.scale } )
                    end
                end
            end
        end
    end

    return fileLookupsForScale
end )

CLASS.getFileLookupsSortedByScale = DataHelper.memoize( function(
    self
)
    local fileLookup = self:getFileLookup()
    if ( fileLookup == nil ) then return nil end

    local fileScales = DataHelper.getNumericKeysSorted( fileLookup )
    local fileLookupsSortedByScale = {}

    for _, scale in pairs( fileScales ) do
        table.insert( fileLookupsSortedByScale, {
            scale = scale,
            lookup = fileLookup[ scale ] } )
    end

    return fileLookupsSortedByScale
end )

function CLASS:getScalingAxis()
    return self.scalingAxis
end

function CLASS:hasScalingAxis()
    return DataHelper.hasValue( self.scalingAxis )
end

return CLASS
