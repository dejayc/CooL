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

function CLASS:init( platformConfig, frameworkConfig, ... )
    self.super.init( self, ... )

    self:setPlatformDisplay( new( CLASSPATH.CooL.PlatformDisplay ) )
    self:getPlatformDisplay():init( platformConfig )

    self:setFrameworkDisplay( new( CLASSPATH.CooL.FrameworkDisplay ) )
    self:getFrameworkDisplay():init( frameworkConfig )
end

function CLASS:getFrameworkDisplay()
    return self.frameworkDisplay
end

function CLASS:setFrameworkDisplay( frameworkDisplay )
    self.frameworkDisplay = frameworkDisplay
    self:refreshConfig()
end

function CLASS:getPlatformDisplay()
    return self.platformDisplay
end

function CLASS:setPlatformDisplay( platformDisplay )
    self.platformDisplay = platformDisplay
    self:refreshConfig()
end

function CLASS:refreshConfig()
    self.findImage:__forget()
    self.getDisplayScale:__forget()
end

function CLASS:findImage(
    imageFileName, imageRootPath, coronaPathType, dynamicScale
)
    if ( self:getFrameworkDisplay():getFrameworkConfig():hasImageLookup() )
    then
        local imagePath, imageFileName, imageScale =
            self:getFrameworkDisplay():findImage(
                imageFileName, imageRootPath, coronaPathType, dynamicScale,
                true )

        if ( imagePath ~= nil ) then
            return imagePath, imageFileName, imageScale
        end
    end

    return self:getPlatformDisplay():findImage(
        imageFileName, imageRootPath, coronaPathType, dynamicScale )
end

function CLASS.getDisplayScale( scalingAxis )
    local hasDefaultArguments = false

    if ( scalingAxis == nil and
         self:getFrameworkDisplay():getFrameworkConfig():hasScalingAxis() )
    then
        scalingAxis = self:getFrameworkDisplay():getFrameworkConfig():
            getScalingAxis()
        hasDefaultArguments = true
    end

    if ( scalingAxis ~= nil ) then
        return self:getFrameworkDisplay():getDisplayScale( scalingAxis )
    end

    return self:getPlatformDisplay():getDisplayScale()
end
