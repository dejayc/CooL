OS_PATH_SEP = package.config:sub( 1, 1 )

local CLASSPATH = {
    root = "Classes"
}

CLASSPATH.LuaLib = CLASSPATH.root .. OS_PATH_SEP .. "LuaLib" .. OS_PATH_SEP

CLASSPATH.LuaLib = {
    App = CLASSPATH.LuaLib .. "App",
    Class = CLASSPATH.LuaLib .. "Class"
}

CLASSPATH.SwapBlocks =
    CLASSPATH.root .. OS_PATH_SEP .. "SwapBlocks" .. OS_PATH_SEP

CLASSPATH.SwapBlocks = {
    Game = CLASSPATH.SwapBlocks .. "Game",
    GameBoard = CLASSPATH.SwapBlocks .. "GameBoard",
    GameLevel = CLASSPATH.SwapBlocks .. "GameLevel",
    GameLevels = CLASSPATH.SwapBlocks .. "GameLevels",
    GamePiece = CLASSPATH.SwapBlocks .. "GamePiece",
    GamePieceDefinition = CLASSPATH.SwapBlocks .. "GamePieceDefinition",
    GamePlay = CLASSPATH.SwapBlocks .. "GamePlay",
    GameStage = CLASSPATH.SwapBlocks .. "GameStage",
    GameStageUi = CLASSPATH.SwapBlocks .. "GameStageUi",
}

return CLASSPATH
