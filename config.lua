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

--
        width = 320,
        height = 480,
--

        scale = "none",
        scale = "letterbox",
        scale = "zoomEven",
        scale = "zoomStretch",

--
        scale = "zoomStretch",
--

        imageSuffix =
        {
            ["@160x240"] = 0.5,
            ["@320x480"] = 1,
            ["@640x960"] = 2,
            ["@800x600"] = 2.5,
            ["@960x1440"] = 3,
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
