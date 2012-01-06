--[[ CooL( Corona Object-Oriented Lua )
     https://github.com/dejayc/CooL
     Copyright 2011 Dejay Clayton

     All use of this file must comply with the Apache License,
     Version 2.0, under which this file is licensed:

     http://www.apache.org/licenses/LICENSE-2.0 --]]

local CLASSPATH = require( "classpath" )
local Data = require( CLASSPATH.CooL.Data )

local CLASS = {}

CLASS.CLASS_SEPARATOR = '.'
CLASS.LUA_FILE_EXTENSION = ".lua"
CLASS.PATH_SEPARATOR = package.config:sub( 1, 1 )
CLASS.PATH_TRIM_PATTERN = string.format(
    "^[%s]?(.-)[%s]?$", CLASS.PATH_SEPARATOR, CLASS.PATH_SEPARATOR )

function CLASS.fileExists( fileName, coronaPathType )
  return CLASS.getFilePath( fileName, coronaPathType ) ~= nil
end

-- Thanks to http://bsharpe.com/code/coronasdk-how-to-know-if-a-file-exists/
function CLASS.getFilePath( fileName, coronaPathType )
  local filePath = system.pathForFile( fileName, coronaPathType )
  return filePath
end

function CLASS.getRequirePath( filePath, fileName )
    if ( Data.endsWith( fileName, CLASS.LUA_FILE_EXTENSION ) ) then
        fileName = string.sub(
            fileName, 1, -1 * ( string.len( CLASS.LUA_FILE_EXTENSION ) + 1 ) )
    end

    if ( filePath == nil or filePath == "" or
         filePath == CLASS.PATH_SEPARATOR )
    then
        return fileName
    end

    filePath = string.gsub(
        string.match( filePath, CLASS.PATH_TRIM_PATTERN ),
        CLASS.PATH_SEPARATOR, CLASS.CLASS_SEPARATOR )

    if ( fileName == nil or fileName == "" ) then
        return filePath
    end

    if ( filePath == "" ) then
        return fileName
    end

    return filePath .. CLASS.CLASS_SEPARATOR .. fileName
end

return CLASS
