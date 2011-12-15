--[[ CooL( Corona Object-Oriented Lua )
     https://github.com/dejayc/CooL
     Copyright 2011 Dejay Clayton

     All use of this file must comply with the Apache License,
     Version 2.0, under which this file is licensed:

     http://www.apache.org/licenses/LICENSE-2.0 --]]

local CLASSPATH = require( "classpath" )

local PlatformConfig = autoextend( CLASSPATH.CooL.Config, packagePath ( ... ) )

function PlatformConfig:getImageSuffixes()
    return self:getValue( "content", "imageSuffix" )
end

function PlatformConfig:getImageSuffixesSorted()
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

return PlatformConfig
