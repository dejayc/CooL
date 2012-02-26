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

--- Returns the base path, file name, file base name, and file extension
-- components of the specified path.
-- @name getPathComponents
-- @param path The path to split into separate components.
-- @return The base path of the specified path.
-- @return The file name of the specified path.
-- @return The file base name of the specified path.
-- @return The file extension of the specified path.
-- components of the specified path.
-- @usage getPathComponents( "/" ) -- { "/", nil, nil, nil }
-- @usage getPathComponents( "/path/to/" ) -- { "/path/to/", nil, nil, nil }
-- @usage getPathComponents( "/path/to/file" )
--   -- { "/path/to/", "file", "file", nil }
-- @usage getPathComponents( "/path/to/file.txt" )
--   -- { "/path/to/", "file.txt", "file", "txt" }
-- @usage getPathComponents( "/path/to/file.txt.bak" )
--   -- { "/path/to", "file.txt.bak", "file.txt", "bak" }
-- @usage getPathComponents( "/path/to/.file" )
--   -- { "/path/to/", ".file", ".file", nil }
-- @usage getPathComponents( "/path/to/.file.txt" )
--   -- { "/path/to/", ".file.txt", ".file", "txt" }
-- @usage getPathComponents( "/path/to/../" )
--   -- { "/path/to/..", nil, nil, nil }
-- @usage getPathComponents( "/path/to/./" )
--   -- { "/path/to/.", nil, nil, nil }
-- @usage getPathComponents( "/path/to/.." )
--   -- { "/path/to/../", nil, nil, nil }
-- @usage getPathComponents( "/path/to/." )
--   -- { "/path/to/./", nil, nil, nil }
-- @see http://stackoverflow.com/a/1403489
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

--- Translates the specified path into a format compatible with the Lua
-- "require" function.
-- @name getRequirePath
-- @param filePath The path to be translated.
-- @return The specified path translated into a format compatible with the
--   Lua "require" function.
-- @usage getRequirePath( "myModule.lua" ) -- "myModule"
-- @usage getRequirePath( "Classes/myModule.lua" ) -- "Classes.myModule"
function CLASS.getRequirePath( filePath )
    if ( DataHelper.endsWith( filePath, CLASS.LUA_FILE_EXTENSION, true ) )
    then
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
