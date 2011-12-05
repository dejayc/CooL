OS_PATH_SEP = package.config:sub( 1, 1 )

local SwapBlocks = "Classes" .. OS_PATH_SEP .. "SwapBlocks" .. OS_PATH_SEP

return {
    Game = SwapBlocks .. "Game",
    GameBoard = SwapBlocks .. "GameBoard",
    GameLevel = SwapBlocks .. "GameLevel",
    GameLevels = SwapBlocks .. "GameLevels",
    GamePiece = SwapBlocks .. "GamePiece",
    GamePieceDefinition = SwapBlocks .. "GamePieceDefinition",
    GamePlay = SwapBlocks .. "GamePlay",
    GameStage = SwapBlocks .. "GameStage",
    GameStageUi = SwapBlocks .. "GameStageUi",
}
