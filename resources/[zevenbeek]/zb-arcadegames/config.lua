Config = {}

-- Which translation you wish to use ?
Config.Locale = "en"

-- Key settings
Config.keyToOpenTicketMenu = "E"
Config.keyToOpenComputer = "E"

-- Marker for buying ticket
Config.Arcade = { 
    {
        NPC = {
            position = vector3(335.81, -914.2, 28.25),
            heading = 179.11,
            model = "ig_claypain",
        },
        marker = {
            markerPosition = vector3(335.81, -916.73, 29.5),
            markerType = 2,
            options = {
                scale = { x = 0.2, y = 0.3, z = 0.1 },
                color = { r = 28, g = 202, b = 155, a = 155 },
            }
        }, 0.25, 0.2, 0.1
    }, 
}

-- ticket price, and time in arcade.
Config.ticketPrice = {
    [_U("bronz")] = {
        name = "Minimum ticket voor 10 minuten speeltijd",
        price = 500,
        time = 10, -- in minutes
    },
    [_U("silver")] = {
        name = "Standaard ticket voor 20 minuten speeltijd",
        price = 1000,
        time = 20, -- in minutes
    },
    [_U("gold")] = {
        name = "High end ticket voor 30 minuten speeltijd",
        price = 1500,
        time = 30, -- in minutes
    },
}

-- is arcade payed ?
Config.enableGameHouse = true
-- do not change unless you know what you're doing
Config.GPUList = {
    [1] = "ETX2080",
    [2] = "ETX1050",
    [3] = "ETX660",
}

-- do not change unless you know what you're doing
Config.CPUList = {
    [1] = "U9_9900",
    [2] = "U7_8700",
    [3] = "U3_6300",
    [4] = "BENTIUM",
}

Config.MyList = {
    {
        name = "name",
        link = "bleh",
    },
}

-- game list for retro machine
Config.RetroMachine = {
    {
        name = "Pacman",
        link = "https://xogos.robinko.eu/PACMAN/",
    },
    {
        name = "Tetris",
        link = "https://xogos.robinko.eu/TETRIS/",
    },
    {
        name = "Ping Pong",
        link = "https://xogos.robinko.eu/PONG/",
    },
    -- {
    --     name = "DOOM",
    --     link = string.format("nui://rcore_arcade/html/msdos.html?url=%s&params=%s", "https://www.retrogames.cz/dos/zip/Doom.zip", "./DOOM.EXE"),
    -- },
    -- {
    --     name = "Duke Nukem 3D",
    --     link = string.format("nui://rcore_arcade/html/msdos.html?url=%s&params=%s", "https://www.retrogames.cz/dos/zip/duke3d.zip", "./DUKE3D.EXE"),
    -- },
    -- {
    --     name = "Wolfenstein 3D",
    --     link = string.format("nui://rcore_arcade/html/msdos.html?url=%s&params=%s", "https://www.retrogames.cz/dos/zip/Wolfenstein3D.zip", "./WOLF3D.EXE"),
    -- },
}
 
-- game list for gaming machine
Config.GamingMachine = {
    {
        name = "Slide a Lama",
        link = "https://lama.robinko.eu/fullscreen.html",
    },
    {
        name = "Uno",
        link = "https://duowfriends.eu/",
    },
    {
        name = "Ants",
        link = "https://ants.robinko.eu/fullscreen.html",
    },
    {
        name = "FlappyParrot",
        link = "https://xogos.robinko.eu/FlappyParrot/",
    },
    {
        name = "Zoopaloola",
        link = "https://zoopaloola.robinko.eu/Embed/fullscreen.html"
    }
}

-- game list for super computer
Config.SuperMachine = {}

for i = 1, #Config.RetroMachine do
    table.insert(Config.SuperMachine, Config.RetroMachine[i])
end
 
for i = 1, #Config.GamingMachine do
    table.insert(Config.SuperMachine, Config.GamingMachine[i])
end

-- computer list in world
Config.computerList = {
    -- Retro machines
    {
        -- if false player dont need a ticket to play on this computer.
        isInGamingHouse = true,
        computerType = Config.RetroMachine,
        computerGPU = Config.GPUList[2],
        computerCPU = Config.CPUList[2],
        markerType = 2,
        position = vector3(323.70, -916.60, 29.25),
        markerOptions = {
                            scale = { x = 0.2, y = 0.3, z = 0.1 },
                color = { r = 28, g = 202, b = 155, a = 155 },
            rotate = true,
        },
    },
    {
        -- if false player dont need a ticket to play on this computer.
        isInGamingHouse = true,
        computerType = Config.RetroMachine,
        computerGPU = Config.GPUList[2],
        computerCPU = Config.CPUList[2],
        markerType = 2,
        position = vector3(323.69, -915.67, 29.25),
        markerOptions = {
                            scale = { x = 0.2, y = 0.3, z = 0.1 },
                color = { r = 28, g = 202, b = 155, a = 155 },
            rotate = true,
        },
    },
    {
        -- if false player dont need a ticket to play on this computer.
        isInGamingHouse = true,
        computerType = Config.RetroMachine,
        computerGPU = Config.GPUList[2],
        computerCPU = Config.CPUList[2],
        markerType = 2,
        position = vector3(323.69, -919.9, 29.25),
        markerOptions = {
                            scale = { x = 0.2, y = 0.3, z = 0.1 },
                color = { r = 28, g = 202, b = 155, a = 155 },
            rotate = true,
        },
    },
    {
        -- if false player dont need a ticket to play on this computer.
        isInGamingHouse = true,
        computerType = Config.RetroMachine,
        computerGPU = Config.GPUList[2],
        computerCPU = Config.CPUList[2],
        markerType = 2,
        position = vector3(323.69, -914.67, 29.25),
        markerOptions = {
                            scale = { x = 0.2, y = 0.3, z = 0.1 },
                color = { r = 28, g = 202, b = 155, a = 155 },
            rotate = true,
        },
    },
    ---
    {
        -- if false player dont need a ticket to play on this computer.
        isInGamingHouse = true,
        computerType = Config.RetroMachine,
        computerGPU = Config.GPUList[2],
        computerCPU = Config.CPUList[2],
        markerType = 2,
        position = vector3(328.25, -927.98, 29.25),
        markerOptions = {
                            scale = { x = 0.2, y = 0.3, z = 0.1 },
                color = { r = 28, g = 202, b = 155, a = 155 },
            rotate = true,
        },
    },
    {
        -- if false player dont need a ticket to play on this computer.
        isInGamingHouse = true,
        computerType = Config.RetroMachine,
        computerGPU = Config.GPUList[2],
        computerCPU = Config.CPUList[2],
        markerType = 2,
        position = vector3(328.25, -927.12, 29.25),
        markerOptions = {
                            scale = { x = 0.2, y = 0.3, z = 0.1 },
                color = { r = 28, g = 202, b = 155, a = 155 },
            rotate = true,
        },
    },
    {
        -- if false player dont need a ticket to play on this computer.
        isInGamingHouse = true,
        computerType = Config.RetroMachine,
        computerGPU = Config.GPUList[2],
        computerCPU = Config.CPUList[2],
        markerType = 2,
        position = vector3(328.25, -926.27, 29.25),
        markerOptions = {
                            scale = { x = 0.2, y = 0.3, z = 0.1 },
                color = { r = 28, g = 202, b = 155, a = 155 },
            rotate = true,
        },
    },
    {
        -- if false player dont need a ticket to play on this computer.
        isInGamingHouse = true,
        computerType = Config.RetroMachine,
        computerGPU = Config.GPUList[2],
        computerCPU = Config.CPUList[2],
        markerType = 2,
        position = vector3(328.25, -925.42, 29.25),
        markerOptions = {
                            scale = { x = 0.2, y = 0.3, z = 0.1 },
                color = { r = 28, g = 202, b = 155, a = 155 },
            rotate = true,
        },
    },
    ----------
    {
        -- if false player dont need a ticket to play on this computer.
        isInGamingHouse = true,
        computerType = Config.RetroMachine,
        computerGPU = Config.GPUList[2],
        computerCPU = Config.CPUList[2],
        markerType = 2,
        position = vector3(324.93, -912.95, 29.25),
        markerOptions = {
                            scale = { x = 0.2, y = 0.3, z = 0.1 },
                color = { r = 28, g = 202, b = 155, a = 155 },
            rotate = true,
        },
    },
    {
        -- if false player dont need a ticket to play on this computer.
        isInGamingHouse = true,
        computerType = Config.RetroMachine,
        computerGPU = Config.GPUList[2],
        computerCPU = Config.CPUList[2],
        markerType = 2,
        position = vector3(325.84, -913.06, 29.25),
        markerOptions = {
                            scale = { x = 0.2, y = 0.3, z = 0.1 },
                color = { r = 28, g = 202, b = 155, a = 155 },
            rotate = true,
        },
    },
    {
        -- if false player dont need a ticket to play on this computer.
        isInGamingHouse = true,
        computerType = Config.RetroMachine,
        computerGPU = Config.GPUList[2],
        computerCPU = Config.CPUList[2],
        markerType = 2,
        position = vector3(326.68, -912.96, 29.25),
        markerOptions = {
                            scale = { x = 0.2, y = 0.3, z = 0.1 },
                color = { r = 28, g = 202, b = 155, a = 155 },
            rotate = true,
        },
    },
    ------------------------------------
    {
        -- if false player dont need a ticket to play on this computer.
        isInGamingHouse = true,
        computerType = Config.RetroMachine,
        computerGPU = Config.GPUList[2],
        computerCPU = Config.CPUList[2],
        markerType = 2,
        position = vector3(366.03, -914.51, 24.63),
        markerOptions = {
                            scale = { x = 0.2, y = 0.3, z = 0.1 },
                color = { r = 28, g = 202, b = 155, a = 155 },
            rotate = true,
        },
    },
    {
        -- if false player dont need a ticket to play on this computer.
        isInGamingHouse = true,
        computerType = Config.RetroMachine,
        computerGPU = Config.GPUList[2],
        computerCPU = Config.CPUList[2],
        markerType = 2,
        position = vector3(366.03, -913.53, 24.63),
        markerOptions = {
                            scale = { x = 0.2, y = 0.3, z = 0.1 },
                color = { r = 28, g = 202, b = 155, a = 155 },
            rotate = true,
        },
    },
    {
        -- if false player dont need a ticket to play on this computer.
        isInGamingHouse = true,
        computerType = Config.RetroMachine,
        computerGPU = Config.GPUList[2],
        computerCPU = Config.CPUList[2],
        markerType = 2,
        position = vector3(366.03, -912.53, 24.63),
        markerOptions = {
                            scale = { x = 0.2, y = 0.3, z = 0.1 },
                color = { r = 28, g = 202, b = 155, a = 155 },
            rotate = true,
        },
    },
    {
        -- if false player dont need a ticket to play on this computer.
        isInGamingHouse = true,
        computerType = Config.RetroMachine,
        computerGPU = Config.GPUList[2],
        computerCPU = Config.CPUList[2],
        markerType = 2,
        position = vector3(366.03, -911.53, 24.63),
        markerOptions = {
                            scale = { x = 0.2, y = 0.3, z = 0.1 },
                color = { r = 28, g = 202, b = 155, a = 155 },
            rotate = true,
        },
    },
    {
        -- if false player dont need a ticket to play on this computer.
        isInGamingHouse = true,
        computerType = Config.RetroMachine,
        computerGPU = Config.GPUList[2],
        computerCPU = Config.CPUList[2],
        markerType = 2,
        position = vector3(366.03, -910.53, 24.63),
        markerOptions = {
                            scale = { x = 0.2, y = 0.3, z = 0.1 },
                color = { r = 28, g = 202, b = 155, a = 155 },
            rotate = true,
        },
    },
    {
        -- if false player dont need a ticket to play on this computer.
        isInGamingHouse = true,
        computerType = Config.RetroMachine,
        computerGPU = Config.GPUList[2],
        computerCPU = Config.CPUList[2],
        markerType = 2,
        position = vector3(366.03, -908.53, 24.63),
        markerOptions = {
                            scale = { x = 0.2, y = 0.3, z = 0.1 },
                color = { r = 28, g = 202, b = 155, a = 155 },
            rotate = true,
        },
    },
    {
        -- if false player dont need a ticket to play on this computer.
        isInGamingHouse = true,
        computerType = Config.RetroMachine,
        computerGPU = Config.GPUList[2],
        computerCPU = Config.CPUList[2],
        markerType = 2,
        position = vector3(366.03, -907.53, 24.63),
        markerOptions = {
                            scale = { x = 0.2, y = 0.3, z = 0.1 },
                color = { r = 28, g = 202, b = 155, a = 155 },
            rotate = true,
        },
    },
    -- Gaming computers
    
    
    {
        -- if false player dont need a ticket to play on this computer.
        isInGamingHouse = true,
        computerType = Config.GamingMachine,
        computerGPU = Config.GPUList[2],
        computerCPU = Config.CPUList[2],
        markerType = 2,
        position = vector3(344.15, -902.75, 29.25),
        markerOptions = {
                           scale = { x = 0.2, y = 0.3, z = 0.1 },
                color = { r = 28, g = 202, b = 155, a = 155 },
            rotate = true,
        }, 
    },
    {
        -- if false player dont need a ticket to play on this computer.
        isInGamingHouse = true,
        computerType = Config.GamingMachine,
        computerGPU = Config.GPUList[2],
        computerCPU = Config.CPUList[2],
        markerType = 2,
        position = vector3(342.66, -902.75, 29.25),
        markerOptions = {
                           scale = { x = 0.2, y = 0.3, z = 0.1 },
                color = { r = 28, g = 202, b = 155, a = 155 },
            rotate = true,
        },
    },
    {
        -- if false player dont need a ticket to play on this computer.
        isInGamingHouse = true,
        computerType = Config.GamingMachine,
        computerGPU = Config.GPUList[2],
        computerCPU = Config.CPUList[2],
        markerType = 2,
        position = vector3(340.96, -902.75, 29.25),
        markerOptions = {
                           scale = { x = 0.2, y = 0.3, z = 0.1 },
                color = { r = 28, g = 202, b = 155, a = 155 },
            rotate = true,
        },
    },
    {
        -- if false player dont need a ticket to play on this computer.
        isInGamingHouse = true,
        computerType = Config.GamingMachine,
        computerGPU = Config.GPUList[2],
        computerCPU = Config.CPUList[2],
        markerType = 2,
        position = vector3(339.23, -902.75, 29.25),
        markerOptions = {
                           scale = { x = 0.2, y = 0.3, z = 0.1 },
                color = { r = 28, g = 202, b = 155, a = 155 },
            rotate = true,
        },
    },
    {
        -- if false player dont need a ticket to play on this computer.
        isInGamingHouse = true,
        computerType = Config.GamingMachine,
        computerGPU = Config.GPUList[2],
        computerCPU = Config.CPUList[2],
        markerType = 2,
        position = vector3(337.55, -902.75, 29.25),
        markerOptions = {
                           scale = { x = 0.2, y = 0.3, z = 0.1 },
                color = { r = 28, g = 202, b = 155, a = 155 },
            rotate = true,
        },
    },
    {
        -- if false player dont need a ticket to play on this computer.
        isInGamingHouse = true,
        computerType = Config.GamingMachine,
        computerGPU = Config.GPUList[2],
        computerCPU = Config.CPUList[2],
        markerType = 2,
        position = vector3(331.98, -903.75, 29.25),
        markerOptions = {
                           scale = { x = 0.2, y = 0.3, z = 0.1 },
                color = { r = 28, g = 202, b = 155, a = 155 },
            rotate = true,
        },
    },
    {
        -- if false player dont need a ticket to play on this computer.
        isInGamingHouse = true,
        computerType = Config.GamingMachine,
        computerGPU = Config.GPUList[2],
        computerCPU = Config.CPUList[2],
        markerType = 2,
        position = vector3(330.35, -903.75, 29.25),
        markerOptions = {
                           scale = { x = 0.2, y = 0.3, z = 0.1 },
                color = { r = 28, g = 202, b = 155, a = 155 },
            rotate = true,
        },
    },
    {
        -- if false player dont need a ticket to play on this computer.
        isInGamingHouse = true,
        computerType = Config.GamingMachine,
        computerGPU = Config.GPUList[2],
        computerCPU = Config.CPUList[2],
        markerType = 2,
        position = vector3(328.60, -903.75, 29.25),
        markerOptions = {
                           scale = { x = 0.2, y = 0.3, z = 0.1 },
                color = { r = 28, g = 202, b = 155, a = 155 },
            rotate = true,
        },
    },
    {
        -- if false player dont need a ticket to play on this computer.
        isInGamingHouse = true,
        computerType = Config.GamingMachine,
        computerGPU = Config.GPUList[2],
        computerCPU = Config.CPUList[2],
        markerType = 2,
        position = vector3(327.05, -903.75, 29.25),
        markerOptions = {
                           scale = { x = 0.2, y = 0.3, z = 0.1 },
                color = { r = 28, g = 202, b = 155, a = 155 },
            rotate = true,
        },
    },
    {
        -- if false player dont need a ticket to play on this computer.
        isInGamingHouse = true,
        computerType = Config.GamingMachine,
        computerGPU = Config.GPUList[2],
        computerCPU = Config.CPUList[2],
        markerType = 2,
        position = vector3(325.33, -903.75, 29.25),
        markerOptions = {
                           scale = { x = 0.2, y = 0.3, z = 0.1 },
                color = { r = 28, g = 202, b = 155, a = 155 },
            rotate = true,
        },
    },
    -- Super machines
}
