--[[ CooL( Corona Object-Oriented Lua )
     https://github.com/dejayc/CooL
     Copyright 2011 Dejay Clayton

     All use of this file must comply with the Apache License,
     Version 2.0, under which this file is licensed:

     http://www.apache.org/licenses/LICENSE-2.0 --]]

local CLASSPATH = require( "classpath" )

local CLASS = autoclass( packagePath( ... ) )

function CLASS:init( platformConfig, frameworkConfig, ... )
    self.platformDisplay = new( CLASSPATH.CooL.PlatformDisplay )
    self.platformDisplay:init( platformConfig )

    self.frameworkDisplay = new( CLASSPATH.CooL.FrameworkDisplay )
    self.frameworkDisplay:init( frameworkConfig )
end

function CLASS:getFrameworkDisplay()
    return self.frameworkDisplay
end

function CLASS:getPlatformDisplay()
    return self.platformDisplay
end

function CLASS:findFileByScale(
    fileName, rootPath, coronaPathType, dynamicScale
)
    if ( self:getFrameworkDisplay():hasFileLookup() )
    then
        local foundPath, foundFileName, fileScale =
            self:getFrameworkDisplay():findFileByScale(
                fileName, rootPath, coronaPathType, dynamicScale,
                true )

        if ( foundPath ~= nil ) then
            return foundPath, foundFileName, fileScale
        end
    end

    return self:getPlatformDisplay():findFileByScale(
        fileName, rootPath, coronaPathType, dynamicScale )
end

function CLASS:getImage(
    imageFileName, imageRootPath, xPos, yPos, coronaPathType
)
    local imagePath, imageScale = self:findFileByScale(
        imageFileName, imageRootPath, coronaPathType )

    if ( imagePath ~= nil ) then
        local image = display.newImage( imagePath, xPos, yPos )
        image.xScale = 1 / imageScale
        image.yScale = 1 / imageScale
        return image
    end
end

function CLASS.getDisplayScale( scalingAxis )
    local hasDefaultArguments = false

    if ( scalingAxis == nil and
         self:getFrameworkDisplay():hasScalingAxis() )
    then
        scalingAxis = self:getFrameworkDisplay():getScalingAxis()
        hasDefaultArguments = true
    end

    if ( scalingAxis ~= nil ) then
        return self:getFrameworkDisplay():getDisplayScale( scalingAxis )
    end

    return self:getPlatformDisplay():getDisplayScale()
end

return CLASS
