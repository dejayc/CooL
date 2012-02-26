--[[ CooL( Corona Object-Oriented Lua )
     https://github.com/dejayc/CooL
     Copyright 2011 Dejay Clayton

     All use of this file must comply with the Apache License,
     Version 2.0, under which this file is licensed:

     http://www.apache.org/licenses/LICENSE-2.0 --]]

--[[
-------------------------------------------------------------------------------
-- Convenience functions for files, file systems, file names, and directories.

module "FileHelper"
-------------------------------------------------------------------------------
--]]

local CLASSPATH = require( "classpath" )
local DataHelper = require( CLASSPATH.CooL.DataHelper )

local CLASS = {}

CLASS.CLASS_SEPARATOR = "."
CLASS.FILE_EXTENSION_SEPARATOR = "."
CLASS.FILE_EXTENSION_SPLIT_PATTERN = string.format(
    "^(.-)([.]?[^.]*)$", CLASS.FILE_EXTENSION_SEPARATOR )
CLASS.LUA_FILE_EXTENSION = CLASS.FILE_EXTENSION_SEPARATOR .. "lua"
CLASS.PATH_CURRENT_DIRECTORY = "."
CLASS.PATH_PARENT_DIRECTORY = ".."
CLASS.PATH_SEPARATOR = package.config:sub( 1, 1 )
CLASS.PATH_FILE_NAME_SPLIT_PATTERN = string.format(
    "^(.-)([^%s]*)$", CLASS.PATH_SEPARATOR )
CLASS.PATH_TRIM_PATTERN = string.format(
    "^[%s]?(.-)[%s]?$", CLASS.PATH_SEPARATOR, CLASS.PATH_SEPARATOR )

-- Thanks to http://stackoverflow.com/a/1403489
--- Description.
-- @name getPathComponents
-- @param path
-- @return description.
-- @usage example
-- @see class
function CLASS.getPathComponents( path )
    path = path or ""

    local filePath, fileName = string.match(
        path, CLASS.PATH_FILE_NAME_SPLIT_PATTERN )

    if ( filePath == nil ) then
        filePath, fileName = "", path
    elseif ( fileName == CLASS.PATH_CURRENT_DIRECTORY or
        fileName == CLASS.PATH_PARENT_DIRECTORY )
    then
        filePath, fileName = filePath .. fileName, ""
    end

    if ( filePath == "" ) then
        filePath = nil
    elseif ( filePath ~= CLASS.PATH_SEPARATOR and
        DataHelper.endsWith( filePath, CLASS.PATH_SEPARATOR ) )
    then
        filePath = string.sub(
            filePath, 1, -1 * (1 + string.len( CLASS.PATH_SEPARATOR ) ) )
    end

    local fileBase, fileExt = string.match(
        fileName, CLASS.FILE_EXTENSION_SPLIT_PATTERN )

    if ( fileBase == "" and fileExt ~= "" ) then
        fileBase, fileExt = fileExt, ""
    end

    if ( fileName == "" ) then fileName = nil end
    if ( fileBase == "" ) then fileBase = nil end

    if ( fileExt == "" ) then
        fileExt = nil
    elseif ( fileExt ~= CLASS.FILE_EXTENSION_SEPARATOR and
        DataHelper.startsWith( fileExt, CLASS.FILE_EXTENSION_SEPARATOR ) )
    then
        fileExt = string.sub(
            fileExt, 1 + string.len( CLASS.FILE_EXTENSION_SEPARATOR ) )
    end

    return filePath, fileName, fileBase, fileExt
end

--- Description.
-- @name getRequirePath
-- @param filePath
-- @return description.
-- @usage example
-- @see class
function CLASS.getRequirePath( filePath )
    if ( DataHelper.endsWith( filePath, CLASS.LUA_FILE_EXTENSION, true ) ) then
        filePath = string.sub(
            filePath, 1, -1 * ( string.len( CLASS.LUA_FILE_EXTENSION ) + 1 ) )
    end

    if ( filePath == nil or filePath == "" or
         filePath == CLASS.PATH_SEPARATOR )
    then
        return nil
    end

    return string.gsub(
        string.match( filePath, CLASS.PATH_TRIM_PATTERN ),
        CLASS.PATH_SEPARATOR, CLASS.CLASS_SEPARATOR )
end

return CLASS
