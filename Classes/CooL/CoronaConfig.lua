--[[ CooL( Corona Object-Oriented Lua )
     https://github.com/dejayc/CooL
     Copyright 2011 Dejay Clayton

     All use of this file must comply with the Apache License,
     Version 2.0, under which this file is licensed:

     http://www.apache.org/licenses/LICENSE-2.0 --]]

local CLASSPATH = require( "classpath" )
local Class = require( CLASSPATH.CooL.Class )
local Data = require( CLASSPATH.CooL.Data )

local Config = Class:extend( { className = "Config" } )

local defaultScalingAxis = "maxResScale"

function Config:init( configSettings )
    self:setConfigSettings( configSettings )
end

function Config:getConfigSettings()
    return self.configSettings
end

function Config:setConfigSettings( configSettings )
    self.configSettings = configSettings
end

function Config:getImageSuffixes()
    return Data.selectByNestedIndex( self:getConfigSettings(),
        "content", "imageSuffix" )
end

function Config:getImageSuffixesSorted()
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

function Config:getScalingAxis( useDefaultIfNil )
    local scalingAxis = Data.selectByNestedIndex( self:getConfigSettings(),
        "CooL", "application", "display", "scaling", "axis" )

    if ( scalingAxis == nil and
         ( useDefaultIfNil or useDefaultIfNil == nil ) )
    then
        scalingAxis = self:getDefaultScalingAxis()
    end

    return scalingAxis
end

function Config:getDefaultScalingAxis()
    return defaultScalingAxis
end

function Config:getStatusBar()
    return Data.selectByNestedIndex( self:getConfigSettings(),
        "CooL", "application", "display", "statusBar" )
end

return Config
