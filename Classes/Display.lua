--[[ CooL( Corona Object-Oriented Lua )
     https://github.com/dejayc/CooL
     Copyright 2011 Dejay Clayton

     All use of this file must comply with the Apache License,
     Version 2.0, under which this file is licensed:

     http://www.apache.org/licenses/LICENSE-2.0 --]]

local CLASSPATH = require( "classpath" )
local Class = require( CLASSPATH.CooL.Class )
local Config = require( CLASSPATH.CooL.PlatformConfig )
local Data = require( CLASSPATH.CooL.Data )
local File = require( CLASSPATH.CooL.File )

local Display = Class:extend( { className = "Display" } )

function Display:init( config )
    self.memoized = self.memoized or {}
    self:setConfig( config )

    local statusBar = self:getConfig():getStatusBar()

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

function Display:debugScreenMetrics()
    io.write "Orientation is now: "
    print( system.orientation )

    io.write "(displayWidth, displayHeight): ("
    io.write( self.getDisplayWidth() )
    io.write ", "
    io.write( self.getDisplayHeight() )
    print ")"

    io.write "display.(contentScaleX, contentScaleY): ("
    io.write( display.contentScaleX )
    io.write ", "
    io.write( display.contentScaleY )
    print ")"

    io.write "(displayScale, dynamicScale): ("
    io.write( self:getDisplayScale() )
    io.write ", "
    io.write( self:getDynamicScale() )
    print ")"

    io.write "dynamicImageSuffixes: ("
    io.write( table.concat( self:getDynamicImageSuffixes(), ", " ) )
    print ")"
end

function Display:getConfig()
    return self.config
end

function Display:setConfig( config )
    self.config = config
    self:refreshConfig()
end

function Display:refreshConfig()
    self.memoized.displayScale =  nil
    self.memoized.dynamicImageSuffixes = {}
end

function Display.getDisplayWidth()
    return Data.roundNumber(
        display.viewableContentWidth / display.contentScaleX, 0 )
end

function Display.getDisplayHeight()
    return Data.roundNumber(
        display.viewableContentHeight / display.contentScaleY, 0 )
end

function Display:getDisplayScale()
    local orientation = Display.getEffectiveOrientation()

    if ( self.memoized.displayScale ~= nil ) then
        return self.memoized.displayScale
    end

    local scalingAxis = self:getConfig():getScalingAxis()

    local scalingFactor = nil
    local height = Display.getDisplayHeight()
    local heightScale = display.contentScaleY
    local width = Display.getDisplayWidth()
    local widthScale = display.contentScaleX

    if ( scalingAxis == "minScale" ) then
        if ( heightScale < widthScale ) then
            scalingFactor = widthScale
        else
            scalingFactor = heightScale
        end
    elseif ( scalingAxis == "maxScale" ) then
        if ( heightScale > widthScale ) then
            scalingFactor = widthScale
        else
            scalingFactor = heightScale
        end
    elseif ( scalingAxis == "minResScale" ) then
        if ( height < width ) then
            scalingFactor = heightScale
        else
            scalingFactor = widthScale
        end
    elseif ( scalingAxis == "maxResScale" ) then
        if ( height > width ) then
            scalingFactor = heightScale
        else
            scalingFactor = widthScale
        end
    elseif ( scalingAxis == "widthScale" ) then
        if ( orientation == "landscape" )
        then
            scalingFactor = widthScale
        else
            scalingFactor = heightScale
        end
    elseif ( scalingAxis == "heightScale" ) then
        if ( orientation == "landscape" )
        then
            scalingFactor = heightScale
        else
            scalingFactor = widthScale
        end
    end

    self.memoized.displayScale = scalingFactor
    return scalingFactor 
end

function Display:getImageFileNameWithSuffix(
    imageFileName, imageRootPath, coronaPathType, scale
)
    if ( imageFileName == nil or imageFileName == "" ) then return nil end

    if ( imageRootPath ~= nil ) then
        imageRootPath = imageRootPath .. File.PATH_SEPARATOR
    else
        imageRootPath = ""
    end

    local imageSuffixes = self:getDynamicImageSuffixes( scale )
    if ( imageSuffixes == nil or table.getn( imageSuffixes ) < 1 )
    then
        local imageDir = self:getConfig():getImageDir()

        if ( imageDir ~= nil ) then
            imageRootPath = imageRootPath .. imageDir .. File.PATH_SEPARATOR
        end

        return File.getFilePath(
            imageRootPath .. imageFileName, coronaPathType )
    end

    local _, _, imagePrefix, imageExt = string.find(
        imageFileName, "^(.*)%.(.-)$" )

    for _, imageSuffix in ipairs( imageSuffixes ) do
        local filePath = File.getFilePath(
            imageRootPath .. imagePrefix .. imageSuffix ..  "." .. imageExt,
            coronaPathType )

        if ( filePath ~= nil ) then return filePath end
    end

    return File.getFilePath( imageRootPath .. imageFileName, coronaPathType )
end

function Display:getDynamicImageSuffixes( scale )
    scale = scale or self:getDynamicScale()

    if ( self.memoized.dynamicImageSuffixes[ scale ] ~= nil )
    then
        return self.memoized.dynamicImageSuffixes[ scale ]
    end

    local imageSuffixesSorted = self:getConfig():getImageSuffixesSorted()
    local imageSuffixes = {}

    if ( imageSuffixesSorted ~= nil ) then
        if ( scale >= 1 ) then
            for _, entry in ipairs( imageSuffixesSorted ) do
                if ( entry.scale > scale ) then break end

                if ( entry.scale >= 1 ) then
                    table.insert( imageSuffixes, 1, entry.suffix )
                end
            end
        else
            for _, entry in ipairs( imageSuffixesSorted ) do
                if ( entry.scale > 1 ) then break end

                if ( entry.scale >= scale ) then
                    table.insert( imageSuffixes, entry.suffix )
                end
            end
        end
    end

    self.memoized.dynamicImageSuffixes[ scale ] = imageSuffixes
    return imageSuffixes
end

function Display:getDynamicScale()
    return Data.roundNumber( 1 / self:getDisplayScale(), 3 )
end

function Display.getEffectiveOrientation()
    if ( ( system.orientation == "landscapeLeft" ) or
         ( system.orientation == "landscapeRight" ) )
    then
        return "landscape"
    else
        return "portrait"
    end
end

return Display