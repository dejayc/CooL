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

        jidth = 1280,
        height = 960,

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
        appConfig =
        {
            display =
            {
                scaling =
                {
                    axis = "max",
                    axis = "min",
                    axis = "height",
                    axis = "width",
                    axis = "portrait",
                    axis = "landscape",
                    threshold = 0,
                },
                statusBar = "hidden",
            },
        },
    },
}

return application
