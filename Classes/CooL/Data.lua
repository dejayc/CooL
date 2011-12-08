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

-- Thanks to http://lua-users.org/wiki/FuncTables
function Data.memoize( fn, self )
    fn = fn or function( x ) return nil end

    if ( self == nil ) then
    return setmetatable( {},
    {
        __index = function( table, key )
            key = key or ""
            local value = fn( key )
            table[ key ] = value
            return value
        end,
        __call  = function( table, key )
            return table[ key ]
        end
    } )
    end

    return setmetatable( {},
    {
        __index = function( table, key )
            key = key or ""
            local value = fn( self, key )
            table[ key ] = value
            return value
        end,
        __call  = function( table, self, key )
            key = key or ""
            return table[ key ]
        end
    } )
end

return Data
