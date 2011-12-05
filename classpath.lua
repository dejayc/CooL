OS_PATH_SEP = package.config:sub( 1, 1 )

return {
    root = "Classes",
    LuaLib = require( "classpath-LuaLib" ),
    SwapBlocks = require( "classpath-SwapBlocks" )
}
