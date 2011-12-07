application =
{
    content =
    {
        width = 320,
        height = 480,

        width = 640,
        height = 960,

        width = 1280,
        height = 1920,

        width = 1280,
        height = 960,

        width = 320,
        height = 320,

        width = 320,
        height = 240,

        width = 160,
        height = 480,

        scale = "none",
        scale = "letterbox",
        scale = "zoomEven",
        scale = "zoomStretch",

        imageSuffix =
        {
            ["@320x480"] = 1,
            ["@640x960"] = 2,
        },
    },
    LuaLib =
    {
        application =
        {
            display =
            {
                scaling =
                {
                    axis = "contentWidth",
                    axis = "contentHeight",
                    axis = "contentScaleMin",
                    axis = "contentScaleMax",
                    axis = "screenWidth",
                    axis = "screenHeight",
                    axis = "screenResMin",
                    axis = "screenResMax",
                },
                statusBar = "hidden",
            },
        },
    },
}

return application
