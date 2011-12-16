--[[ CooL( Corona Object-Oriented Lua )
     https://github.com/dejayc/CooL
     Copyright 2011 Dejay Clayton

     All use of this file must comply with the Apache License,
     Version 2.0, under which this file is licensed:

     http://www.apache.org/licenses/LICENSE-2.0 --]]

local CLASSPATH = require( "classpath" )
local Data = require( CLASSPATH.CooL.Data )
local File = require( CLASSPATH.CooL.File )

local Display = autoclass( packagePath ( ... ) )

function Display:init( app )
    self.memoized = self.memoized or {}
    self:setApp( app )

    local statusBar = self:getApp():getFrameworkConfig():getStatusBar()

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

    io.write "imageSuffixesForScale: ("
    io.write( table.concat( self:getImageSuffixesForScale(), ", " ) )
    print ")"
end

function Display:getApp()
    return self.app
end

function Display:setApp( app )
    self.app = app
    self:refreshConfig()
end

function Display:refreshConfig()
    self.memoized.displayScale =  nil
    self.memoized.imageSuffixesForScale = {}
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

    local scalingAxis = self:getApp():getFrameworkConfig():getScalingAxis()

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

function Display:getImageFileNameWithSuffix(
    imageFileName, imageRootPath, coronaPathType, scale
)
    if ( imageFileName == nil or imageFileName == "" ) then return nil end

    if ( imageRootPath ~= nil ) then
        imageRootPath = imageRootPath .. File.PATH_SEPARATOR
    else
        imageRootPath = ""
    end

    local imageSuffixes = self:getImageSuffixesForScale( scale )
    if ( imageSuffixes == nil or table.getn( imageSuffixes ) < 1 )
    then
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

function Display:getImageSuffixesForScale( scale )
    scale = scale or self:getDynamicScale()

    if ( self.memoized.imageSuffixesForScale[ scale ] ~= nil )
    then
        return self.memoized.imageSuffixesForScale[ scale ]
    end

    local imageSuffixes = {}
    local imageSuffixesSorted =
        self:getApp():getPlatformConfig():getImageSuffixesSorted()

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

    self.memoized.imageSuffixesForScale[ scale ] = imageSuffixes
    return imageSuffixes
end

return Display
