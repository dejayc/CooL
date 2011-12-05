local CLASSPATH = require( "classpath" )

local Data = {}

function Data.selectByNestedIndex( targetTable, ... )
    if ( targetTable == nil ) then return nil end

    local objRef = targetTable

    for i, v in ipairs( arg ) do
        objRef = objRef [ v ]
        if ( objRef == nill ) then return nill end
    end

    return objRef
end

return Data
