application =
{
    content =
    {
        width = 320,
        height = 480,
        scale = "zoomEven",

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
                hideStatusBar = true,
            },
        },
    },
}

return application
