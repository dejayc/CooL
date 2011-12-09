--[[ CooL( Corona Object-Oriented Lua )
     https://github.com/dejayc/CooL
     Copyright 2011 Dejay Clayton

     All use of this file must comply with the Apache License,
     Version 2.0, under which this file is licensed:

     http://www.apache.org/licenses/LICENSE-2.0 --]]

--[[
    A note about this file.  Many developers have expressed an interest in
    being able to access the values in 'config.lua' from within their own
    applications.  For example, it would be useful to be able to determine
    what scaling mode or image suffixes have been defined within the file.

    Unfortunately, even though 'config.lua' is a standard Lua file that can
    be 'required' within Lua, the file will not be compiled or copied to a
    target device during the build process.  'config.lua' CAN be accessed
    from within the Corona simulator, but then fails to exist on actual
    devices that have received a compiled build of the application.

    Instead of requiring developers to maintain a separate configuration file
    that contains a copy of the relevant 'config.lua' settings, the developer
    can create a symlink of 'config.lua', such as 'config-local.lua', and
    then 'require' that symlinked file.  The symlinked file will be compiled
    to the target device during the build process.

    Please note that in order to gain access to the 'application' table once
    the file has been 'required', it is necessary to ensure that the last
    line of this file reads 'return application'.

    Windows users that are unable to create symlinks can always go through
    the tedious process of always copying 'config.lua' to another file prior
    to building the application.
--]]
application =
{
    content =
    {
--[[ List of common 'width/height' combinations for testing
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
--]]

-- Particular 'width/height' combination to use for this application
        width = 320,
        height = 480,

        width = 320,
        height = 320,
--[[ List of possible 'scale' values
        scale = "none",
        scale = "letterbox",
        scale = "zoomEven",
        scale = "zoomStretch",
--]]

-- Particular 'scale' value to use for this application
        scale = "letterbox",
        scale = "zoomStretch",

        imageSuffix =
        {
-- A wide range of dynamic image resolution suffixes for testing
            ["@160x240"] = 0.5,
            ["@320x480"] = 1,
            ["@480x720"] = 1.5,
            ["@640x960"] = 2,
            ["@800x600"] = 2.5,
            ["@960x1440"] = 3,
        },
    },
    CooL =
    {
        application =
        {
            display =
            {
                scaling =
                {
--[[ List of possible 'axis' values
                    axis = "contentWidth",
                    axis = "contentHeight",
                    axis = "contentScaleMin",
                    axis = "contentScaleMax",
                    axis = "screenWidth",
                    axis = "screenHeight",
                    axis = "screenResMin",
                    axis = "screenResMax",
--]]

-- Particular 'axis' value to use for this application
                    axis = "screenResMax",
                    axis = "contentWidth",

                },

--[[ List of possible 'statusBar' values
                statusBar = "dark",
                statusBar = "default",
                statusBar = "hidden",
                statusBar = "translucent",
--]]

-- Particular 'statusBar' value to use for this application
                statusBar = "hidden",

            },
        },
    },
}

-- Please remember to include the following line in all 'config.lua' files!
return application
