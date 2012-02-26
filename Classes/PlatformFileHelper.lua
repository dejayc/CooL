--[[ CooL( Corona Object-Oriented Lua )
     https://github.com/dejayc/CooL
     Copyright 2011 Dejay Clayton

     All use of this file must comply with the Apache License,
     Version 2.0, under which this file is licensed:

     http://www.apache.org/licenses/LICENSE-2.0 --]]

--[[
-------------------------------------------------------------------------------
-- Convenience functions for files, file systems, file names, and directories
-- in Corona.

module "PlatformFileHelper"
-------------------------------------------------------------------------------
--]]

local CLASSPATH = require( "classpath" )
local DataHelper = require( CLASSPATH.CooL.DataHelper )

local CLASS = {}

--- Indicates whether the specified file exists within the specified Corona
-- path type.
-- @name fileExists
-- @param fileName The file name, optionally containing a file path, to check
-- for in the specified Corona path type.
-- @param coronaPathType The type of Corona path in which to search for the
-- specified file name.  Valid values are "system.DocumentsDirectory",
-- "system.ResourceDirectory", and "system.TemporaryDirectory".  Defaults to
-- "system.ResourceDirectory".
-- @return True if the specified file name exists within the specified Corona
-- path type; otherwise, false.
-- @usage fileExists( "data.xml" ) -- true if "data.xml" exists in the
--   system.ResourceDirectory directory.
-- @usage fileExists( "data/data.xml" ) -- true if "data.xml" exists in the
--   "data" subdirectory of the system.ResourceDirectory directory.
-- @usage fileExists( "data.xml", system.DocumentsDirectory ) -- true if
--   "data.xml" exists in the system.DocumentsDirectory directory.
-- @see getFileSystemPath
-- @see system.pathForFile
function CLASS.fileExists( fileName, coronaPathType )
    return CLASS.getFileSystemPath( fileName, coronaPathType ) ~= nil
end

--- Returns an absolute path for the specified file if it exists within the
-- specified Corona path type; otherwise, nil.
-- @name getFileSystemPath 
-- @param fileName The file name, optionally containing a file path, to check
-- for in the specified Corona path type.
-- @param coronaPathType The type of Corona path in which to search for the
-- specified file name.  Valid values are "system.DocumentsDirectory",
-- "system.ResourceDirectory", and "system.TemporaryDirectory".  Defaults to
-- "system.ResourceDirectory".
-- @return The absolute path for the specified file if it exists within the
-- specified Corona path type; otherwise, nil.
-- @usage getFileSystemPath( "data.xml" ) -- Absolute path to "data.xml"
--   in the system.ResourceDirectory directory.
-- @usage getFileSystemPath( "data/data.xml" ) -- Absolute path to "data.xml"
--   in the "data" subdirectory of the system.ResourceDirectory directory.
-- @usage getFileSystemPath( "data.xml", system.DocumentsDirectory )
--   -- Absolute path to "data.xml" in the system.DocumentsDirectory
--   directory.
-- @see system.pathForFile
-- @see http://bsharpe.com/code/coronasdk-how-to-know-if-a-file-exists/
function CLASS.getFileSystemPath( fileName, coronaPathType )
    local path = system.pathForFile( fileName, coronaPathType )

    -- If coronaPathType is system.ResourceDirectory, which is read-only, the
    -- results of system.pathForFile will conclusively indicate whether the
    -- specified file already exists.  No need to perform further checks.
    if ( coronaPathType == system.ResourceDirectory or path == nil ) then
        return path
    end

    -- If coronaPathType is a writeable directory, system.pathForFile will not
    -- indicate whether the specified file already exists; it will only
    -- indicate whether the file could be created.  An attempt to open the
    -- specified file in read mode will conclusively indicate whether it
    -- exists.
    local fileHandle = io.open( path, "r" )

    if ( fileHandle ~= nil ) then
        io.close( fileHandle )
        return path
    end
end

return CLASS
