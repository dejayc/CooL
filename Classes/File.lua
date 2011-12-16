--[[ CooL( Corona Object-Oriented Lua )
     https://github.com/dejayc/CooL
     Copyright 2011 Dejay Clayton

     All use of this file must comply with the Apache License,
     Version 2.0, under which this file is licensed:

     http://www.apache.org/licenses/LICENSE-2.0 --]]

local CLASSPATH = require( "classpath" )

local CLASS = {}

CLASS.PATH_SEPARATOR = package.config:sub( 1, 1 )

function CLASS.fileExists( filename, coronaPathType )
  return CLASS.getFilePath( filename, coronaPathType ) ~= nil
end

-- Thanks to http://bsharpe.com/code/coronasdk-how-to-know-if-a-file-exists/
function CLASS.getFilePath( filename, coronaPathType )
  local filePath = system.pathForFile( filename, coronaPathType )
  return filePath
end

return CLASS
