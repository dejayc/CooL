application =
{
    content =
    {
---[[
        width = 320,
        height = 480,
--]]
--[[
        width = 640,
        height = 960,
--]]
--[[
        width = 1280,
        height = 1920,
--]]
--[[
        scale = "none",
--]]
--[[
        scale = "letterbox",
--]]
---[[
        scale = "zoomEven",
--]]
--[[
        scale = "zoomStretch",
--]]

        imageSuffix =
        {
            ["@320x480"] = 1,
            ["@640x960"] = 2,
        },
    },
    LuaLib =
    {
        appConfig =
        {
            display =
            {
                statusBar = "hidden",
            },
        },
    },
}

return application
