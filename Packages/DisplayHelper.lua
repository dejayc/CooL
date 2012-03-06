--[[ CooL( Corona Object-Oriented Lua )
     https://github.com/dejayc/CooL
     Copyright 2011 Dejay Clayton

     All use of this file must comply with the Apache License,
     Version 2.0, under which this file is licensed:

     http://www.apache.org/licenses/LICENSE-2.0 --]]

--[[
-------------------------------------------------------------------------------
-- Convenience functions for inspecting and manipulating the display.

module "DisplayHelper"
-------------------------------------------------------------------------------
--]]

local BaseLua = require( "BaseLua" )
local CooL = require( "CooL" )

local DataHelper = require( BaseLua.package.DataHelper )
local FileHelper = require( BaseLua.package.FileHelper )

local CLASS = {}

--- Description.
-- @name getDisplayHeight
-- @return description.
-- @usage example
-- @see class
function CLASS.getDisplayHeight()
    return DataHelper.roundNumber(
        display.viewableContentHeight / display.contentScaleY, 0 )
end

--- Description.
-- @name getDisplayWidth
-- @return description.
-- @usage example
-- @see class
function CLASS.getDisplayWidth()
    return DataHelper.roundNumber(
        display.viewableContentWidth / display.contentScaleX, 0 )
end

--- Description.
-- @name getDisplayScale
-- @return description.
-- @usage example
-- @see class
function CLASS.getDisplayScale()
    local heightScale = display.contentScaleY
    local widthScale = display.contentScaleX

    if ( heightScale > widthScale ) then
        return heightScale
    else
        return widthScale
    end
end

--- Description.
-- @name getDynamicScale
-- @return description.
-- @usage example
-- @see class
function CLASS.getDynamicScale()
    return DataHelper.roundNumber( 1 / CLASS.getDisplayScale(), 3 )
end

--- Description.
-- @name getEffectiveOrientation
-- @param orientation
-- @return description.
-- @usage example
-- @see class
function CLASS.getEffectiveOrientation( orientation )
    orientation = orientation or system.orientation

    if ( ( orientation == "landscapeLeft" ) or
         ( orientation == "landscapeRight" ) )
    then
        return "landscape"
    else
        return "portrait"
    end
end

--- Description.
-- @name getImageBoundingBox
-- @param image
-- @return description.
-- @usage example
-- @see class
function CLASS.getImageBoundingBox( image )
    xBound = ( image.width * image.xScale ) / 2
    yBound = ( image.height * image.yScale ) / 2

    return {
        -xBound, -yBound,
        xBound, -yBound,
        xBound, yBound,
        -xBound, yBound
    }
end

--- Description.
-- @name isImageScaled
-- @param image
-- @return description.
-- @usage example
-- @see class
function CLASS.isImageScaled( image )
    return image.xScale ~= 1 or image.yScale ~= 1
end

--- Description.
-- @name setStatusBar
-- @param statusBar
-- @return description.
-- @usage example
-- @see class
function CLASS.setStatusBar( statusBar )
    if ( statusBar == "hidden" )
    then
        display.setStatusBar( display.HiddenStatusBar )
    elseif ( statusBar == "translucent" )
    then
        display.setStatusBar( display.TranslucentStatusBar )
    elseif ( statusBar == "dark" )
    then
        display.setStatusBar( display.DarkStatusBar )
    else
        display.setStatusBar( display.DefaultStatusBar )
    end
end

return CLASS
