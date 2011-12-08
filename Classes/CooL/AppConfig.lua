local CLASSPATH = require( "classpath" )
local Class = require( CLASSPATH.CooL.Class )
local Data = require( CLASSPATH.CooL.Data )

local Config = Class:extend( { className = "Config" } )

local defaultScalingAxis = "screenResMax"

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

function Config:getScalingAxis()
    return Data.selectByNestedIndex( self:getConfigSettings(),
        "CooL", "application", "display", "scaling", "axis" )
end

function Config:getDefaultScalingAxis()
    return defaultScalingAxis
end

function Config:getStatusBar()
    return Data.selectByNestedIndex( self:getConfigSettings(),
        "CooL", "application", "display", "statusBar" )
end

return Config
