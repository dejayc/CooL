OS_PATH_SEP = package.config:sub( 1, 1 )

return {
    root = "Classes",
    LuaLib = require( "Classes/LuaLib/classpath-LuaLib" ),
    SwapBlocks = require( "Classes/SwapBlocks/classpath-SwapBlocks" )
}
