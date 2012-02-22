--[[ CooL( Corona Object-Oriented Lua )
     https://github.com/dejayc/CooL
     Copyright 2011 Dejay Clayton

     All use of this file must comply with the Apache License,
     Version 2.0, under which this file is licensed:

     http://www.apache.org/licenses/LICENSE-2.0 --]]

--[[
-------------------------------------------------------------------------------
-- Convenience methods to inspect and manipulate the state of the display, as
-- configured by CooL.

module "FrameworkDisplay"
-------------------------------------------------------------------------------
--]]

local CLASSPATH = require( "classpath" )
local ClassHelper = require( CLASSPATH.CooL.ClassHelper )
local DataHelper = require( CLASSPATH.CooL.DataHelper )
local DisplayHelper = require( CLASSPATH.CooL.DisplayHelper )
local FileHelper = require( CLASSPATH.CooL.FileHelper )

local CLASS = ClassHelper.autoclass( ClassHelper.getPackagePath( ... ) )

--- Description.
-- @name init
-- @param frameworkConfig
-- @param ...
-- @return description.
-- @usage example
-- @see .class
function CLASS:init( frameworkConfig, ... )
    self.fileLookup = frameworkConfig:getFileLookup()
    self.scalingAxis = frameworkConfig:getScalingAxis()
    DisplayHelper.setStatusBar( frameworkConfig:getStatusBar() )
end

--- Description.
-- @name findByScale
-- @param fileName
-- @param rootPath
-- @param coronaPathType
-- @param dynamicScale
-- @param bypassDefaultCheck
-- @return description.
-- @usage example
-- @see .class
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

                            if ( FileHelper.getFileSystemPath(
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

    if ( FileHelper.getFileSystemPath( checkedPath, coronaPathType ) == nil )
    then
        return nil
    end

    return rootPath, fileName, 1
end )

--- Description.
-- @name getDisplayScale
-- @param scalingAxis
-- @return description.
-- @usage example
-- @see .class
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

--- Description.
-- @name getDynamicScale
-- @return description.
-- @usage example
-- @see .class
function CLASS:getDynamicScale()
    return DataHelper.roundNumber( 1 / self:getDisplayScale(), 3 )
end

--- Description.
-- @name getFileLookup
-- @return description.
-- @usage example
-- @see .class
function CLASS:getFileLookup()
    return self.fileLookup
end

--- Description.
-- @name hasFileLookup
-- @return description.
-- @usage example
-- @see .class
function CLASS:hasFileLookup()
    return DataHelper.hasValue( self.fileLookup )
end

--- Description.
-- @name getFileLookupsForScale
-- @param scale
-- @return description.
-- @usage example
-- @see .class
CLASS.getFileLookupsForScale = DataHelper.memoize( function(
    self, scale
)
    local fileLookupsForScale = {}
    local fileLookupsSortedByScale = self:getFileLookupsSortedByScale()

    if ( fileLookupsSortedByScale ~= nil ) then
        local cutOff, threshold, indexIncrement

        if ( scale >= 1 ) then
            cutOff, threshold, indexIncrement = scale, 1, 1
        else
            cutOff, threshold, indexIncrement = 1, scale, 0
        end

        for _, entry in ipairs( fileLookupsSortedByScale ) do
            if ( entry.scale > cutOff ) then break end

            if ( entry.scale >= threshold ) then
                local index = 1
                for _, lookup in pairs( entry.lookup ) do
                    table.insert( fileLookupsForScale, index,
                        { lookup = lookup, scale = entry.scale } )
                    index = index + indexIncrement
                end
            end
        end
    end

    return fileLookupsForScale
end )

--- Description.
-- @name getFileLookupsSortedByScale
-- @return description.
-- @usage example
-- @see .class
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

--- Description.
-- @name getScalingAxis
-- @return description.
-- @usage example
-- @see .class
function CLASS:getScalingAxis()
    return self.scalingAxis
end

--- Description.
-- @name hasScalingAxis
-- @return description.
-- @usage example
-- @see .class
function CLASS:hasScalingAxis()
    return DataHelper.hasValue( self.scalingAxis )
end

return CLASS
