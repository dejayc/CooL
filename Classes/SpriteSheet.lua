--[[ CooL( Corona Object-Oriented Lua )
     https://github.com/dejayc/CooL
     Copyright 2011 Dejay Clayton

     All use of this file must comply with the Apache License,
     Version 2.0, under which this file is licensed:

     http://www.apache.org/licenses/LICENSE-2.0 --]]

local CLASSPATH = require( "classpath" )
local Data = require( CLASSPATH.CooL.Data )
local File = require( CLASSPATH.CooL.File )

local CLASS = autoclass( packagePath( ... ) )

function CLASS:init( dataFileName, imageFileName, coronaPathType )
    self:loadDataFile( dataFileName, coronaPathType )
    self.imageFileName( imageFileName)
end

function CLASS:getCoronaPathType()
    return self.coronaPathType
end

function CLASS:getDataFileName()
    return self.dataFileName
end

function CLASS:getImageFileName()
    return self.imageFileName
end

function CLASS:loadDataFile( dataFileName, coronaPathType )
    self.dataFileName = dataFileName
    self.coronaPathType = coronaPathType
end
