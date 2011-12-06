local CLASSPATH = require( "classpath" )

local Data = {}

-- Thanks to http://lua-users.org/wiki/SimpleRound
function Data.roundNumber( num, idp )
    local mult = 10^( idp or 0 )
    return math.floor( num * mult + 0.5 ) / mult
end

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
