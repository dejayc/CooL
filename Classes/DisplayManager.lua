--[[ CooL( Corona Object-Oriented Lua )
     https://github.com/dejayc/CooL
     Copyright 2011 Dejay Clayton

     All use of this file must comply with the Apache License,
     Version 2.0, under which this file is licensed:

     http://www.apache.org/licenses/LICENSE-2.0 --]]

--[[
-------------------------------------------------------------------------------
-- Manages the display as configured by Corona and CooL.

module "DisplayManager"
-------------------------------------------------------------------------------
--]]

local CLASSPATH = require( "classpath" )
local ClassHelper = require( CLASSPATH.CooL.ClassHelper )

local CLASS = ClassHelper.autoclass( ClassHelper.getPackagePath( ... ) )

--- Description.
-- @name init
-- @param platformConfig
-- @param frameworkConfig
-- @param ...
-- @return description.
-- @usage example
-- @see class
function CLASS:init( platformConfig, frameworkConfig, ... )
    self.platformDisplay = ClassHelper.new( CLASSPATH.CooL.PlatformDisplay )
    self.platformDisplay:init( platformConfig )

    self.frameworkDisplay = ClassHelper.new( CLASSPATH.CooL.FrameworkDisplay )
    self.frameworkDisplay:init( frameworkConfig )
end

--- Description.
-- @name getFrameworkDisplay
-- @return description.
-- @usage example
-- @see class
function CLASS:getFrameworkDisplay()
    return self.frameworkDisplay
end

--- Description.
-- @name getPlatformDisplay
-- @return description.
-- @usage example
-- @see class
function CLASS:getPlatformDisplay()
    return self.platformDisplay
end

--- Description.
-- @name findFileByScale
-- @param fileName
-- @param rootPath
-- @param coronaPathType
-- @param dynamicScale
-- @return description.
-- @usage example
-- @see class
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

--- Description.
-- @name getImage
-- @param imageFileName
-- @param imageRootPath
-- @param xPos
-- @param yPos
-- @param coronaPathType
-- @return description.
-- @usage example
-- @see class
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

--- Description.
-- @name getDisplayScale
-- @param scalingAxis
-- @return description.
-- @usage example
-- @see class
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
