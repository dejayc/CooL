application =
{
    content =
    {
        width = 320,
        height = 480,
        scale = "letterbox",

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
