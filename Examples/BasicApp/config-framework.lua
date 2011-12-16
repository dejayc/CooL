--[[ CooL( Corona Object-Oriented Lua )
     https://github.com/dejayc/CooL
     Copyright 2011 Dejay Clayton

     All use of this file must comply with the Apache License,
     Version 2.0, under which this file is licensed:

     http://www.apache.org/licenses/LICENSE-2.0 --]]

return {
    display =
    {
        scaling =
        {
--[[ List of possible 'axis' values
            axis = "minScale",
            axis = "maxScale",
            axis = "minResScale",
            axis = "maxResScale", -- DEFAULT
            axis = "widthScale",
            axis = "heightScale",
--]]

-- Particular 'axis' value to use for this application
            axis = "maxResScale",

-- Replacement for the underpowered 'imageSuffix' feature
            imageLookup =
            {
                [ 1 ] =
                {
                    {
                        suffix = "@320x480",
                        subdir = "320x480",
                    },
                    "default",
                    {
                        subdir = "320x480",
                    },
                },
                [ 2 ] =
                {
                    {
                        suffix = "@640x960",
                        subdir = "640x960",
                    },
                    {
                        subdir = "640x960",
                    },
                    {
                        suffix = "-hd",
                        subdir = "hd",
                    },
                    "default",
                },
            },

        },

--[[ List of possible 'statusBar' values
        statusBar = "dark",
        statusBar = "default", -- DEFAULT
        statusBar = "hidden",
        statusBar = "translucent",
--]]

-- Particular 'statusBar' value to use for this application
        statusBar = "hidden",
    },
}