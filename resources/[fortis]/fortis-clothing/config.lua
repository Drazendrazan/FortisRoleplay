Config = Config or {}

Config.WomanPlayerModels = {
    'mp_f_freemode_01'
}
    
Config.ManPlayerModels = {
    'mp_m_freemode_01'
}

Config.LoadedManModels = {}
Config.LoadedWomanModels = {}

Config.Stores = {
    [1] =   {shopType = "clothing", x = 1693.32,      y = 4823.48,     z = 41.06},
	[2] =   {shopType = "clothing", x = -712.215881,  y = -155.352982, z = 37.4151268},
	[3] =   {shopType = "clothing", x = -1192.94495,  y = -772.688965, z = 17.3255997},
	[4] =   {shopType = "clothing", x =  425.236,     y = -806.008,    z = 28.491},
	[5] =   {shopType = "clothing", x = -162.658,     y = -303.397,    z = 38.733},
	[6] =   {shopType = "clothing", x = 75.950,       y = -1392.891,   z = 28.376},
	[7] =   {shopType = "clothing", x = -822.194,     y = -1074.134,   z = 10.328},
	[8] =   {shopType = "clothing", x = -1450.711,    y = -236.83,     z = 48.809},
	[9] =   {shopType = "clothing", x = 4.254,        y = 6512.813,    z = 30.877},
	[10] =  {shopType = "clothing", x = 615.180,      y = 2762.933,    z = 41.088},
	[11] =  {shopType = "clothing", x = 1196.785,     y = 2709.558,    z = 37.222},
	[12] =  {shopType = "clothing", x = -3171.453,    y = 1043.857,    z = 19.863},
	[13] =  {shopType = "clothing", x = -1100.959,    y = 2710.211,    z = 18.107},
	[14] =  {shopType = "clothing", x = -1207.65,     y = -1456.88,    z = 4.3784737586975},
    [15] =  {shopType = "clothing", x = 121.76,       y = -224.6,      z = 53.56},
	[16] =  {shopType = "barber",   x = -814.3,       y = -183.8,      z = 36.6},
	[17] =  {shopType = "barber",   x = 136.8,        y = -1708.4,     z = 28.3},
	[18] =  {shopType = "barber",   x = -1282.6,      y = -1116.8,     z = 6.0},
	[19] =  {shopType = "barber",   x = 1931.5,       y = 3729.7,      z = 31.8},
	[20] =  {shopType = "barber",   x = 1212.8,       y = -472.9,      z = 65.2},
	[21] =  {shopType = "barber",   x = -32.9,        y = -152.3,      z = 56.1},
	[22] =  {shopType = "barber",   x = -278.1,       y = 6228.5,      z = 30.7}
}

Config.ClothingRooms = {
    [1] = {requiredJob = "police", x = 460.63, y = -978.73, z = 34.29, cameraLocation = {x = 460.63, y = -976.98, z = 34.29, h = 176.153}},
    [2] = {requiredJob = "doctor", x = 300.16, y = -598.93, z = 43.28, cameraLocation = {x = 301.09, y = -596.09, z = 43.28, h = 157.5}},
    [3] = {requiredJob = "ambulance", x = 300.16, y = -598.93, z = 43.28, cameraLocation = {x = 300.16, y = -598.93, z = 43.28, h = 333.5}},
    [4] = {requiredJob = "police", x = -451.46, y = 6014.25, z = 31.72, cameraLocation = {x = -451.46, y = 6014.25, z = 31.72}},
    [5] = {requiredJob = "ambulance", x = -250.5, y = 6323.98, z = 32.32, cameraLocation = {x = -250.5, y = 6323.98, z = 32.32, h = 315.5}},    
    [6] = {requiredJob = "doctor", x = -250.5, y = 6323.98, z = 32.32, cameraLocation = {x = -250.5, y = 6323.98, z = 32.32, h = 315.5}}, 
	[7] = {requiredJob = "mechanic", x = -341.36, y = -162.18, z = 44.58, cameraLocation = {x = -339.90, y = -161.33, z = 44.58, h = 118.18}}, 
    [8] = {requiredJob = "police", x = 1850.13, y = 3694.69, z = 34.26, cameraLocation = {x = 1850.13, y = 3694.69, z = 34.26}},
    [9] = {requiredJob = "ambulance", x = 1825.83, y = 3674.91, z = 34.27, cameraLocation = {x = 1825.83, y = 3674.91, z = 34.27}}, 
}

Config.Outfits = {
    ["police"] = {
        ["male"] = {
            [1] = {
                outfitLabel = "Noodhulp Kort",
                outfitData = {
                    ["pants"]       = { item = 108, texture = 0},  -- Broek
                    ["arms"]        = { item = 0, texture = 0},  -- Armen
                    ["t-shirt"]     = { item = 111, texture = 0},  -- T Shirt
                    ["vest"]        = { item = 26, texture = 0},  -- Body Vest
                    ["torso2"]      = { item = 74, texture = 0},  -- Jas / Vesten
                    ["shoes"]       = { item = 25, texture = 0},  -- Schoenen
                    ["decals"]      = { item = 58, texture = 0},  -- Decals
                    ["accessory"]   = { item = 48, texture = 0},  -- Nek / Das
                    ["bag"]         = { item = 54, texture = 0},  -- Tas
                    ["hat"]         = { item = -1, texture = 0},  -- Pet
                    ["glass"]       = { item = 0, texture = 0},  -- Bril
            --      ["ear"]         = { item = -1, texture = 0},  -- Oor accessoires
                    ["mask"]         = { item = 141, texture = 0},  -- Masker
                },
            },
            [2] = {
                outfitLabel = "Noodhulp Lang",
                outfitData = {
                    ["pants"]       = { item = 108, texture = 0},  -- Broek
                    ["arms"]        = { item = 4, texture = 0},  -- Armen
                    ["t-shirt"]     = { item = 111, texture = 0},  -- T Shirt
                    ["vest"]        = { item = 27, texture = 0},  -- Body Vest
                    ["torso2"]      = { item = 143, texture = 0},  -- Jas / Vesten
                    ["shoes"]       = { item = 25, texture = 0},  -- Schoenen
                    ["decals"]      = { item = 58, texture = 0},  -- Decals
                    ["accessory"]   = { item = 48, texture = 0},  -- Nek / Das
                    ["bag"]         = { item = 54, texture = 0},  -- Tas
                    ["hat"]         = { item = -1, texture = 0},  -- Pet
                    ["glass"]       = { item = 0, texture = 0},  -- Bril
            --      ["ear"]         = { item = -1, texture = 0},  -- Oor accessoires
                    ["mask"]         = { item = 141, texture = 0},  -- Masker
                },
            },
            [3] = {
                outfitLabel = "VP Kort",
                outfitData = {
                    ["pants"]       = { item = 108, texture = 0},  -- Broek
                    ["arms"]        = { item = 0, texture = 0},  -- Armen
                    ["t-shirt"]     = { item = 92, texture = 0},  -- T Shirt
                    ["vest"]        = { item = 26, texture = 5},  -- Body Vest
                    ["torso2"]      = { item = 74, texture = 0},  -- Jas / Vesten
                    ["shoes"]       = { item = 25, texture = 0},  -- Schoenen
                    ["decals"]      = { item = 58, texture = 0},  -- Decals
                    ["accessory"]   = { item = 48, texture = 0},  -- Nek / Das
                    ["bag"]         = { item = 54, texture = 0},  -- Tas
                    ["hat"]         = { item = -1, texture = 0},  -- Pet
                    ["glass"]       = { item = 0, texture = 0},  -- Bril
            --      ["ear"]         = { item = -1, texture = 0},  -- Oor accessoires
                    ["mask"]         = { item = 141, texture = 0},  -- Masker
                },
            },
            [4] = {
                outfitLabel = "VP Lang",
                outfitData = {
                    ["pants"]       = { item = 108, texture = 0},  -- Broek
                    ["arms"]        = { item = 4, texture = 0},  -- Armen
                    ["t-shirt"]     = { item = 92, texture = 0},  -- T Shirt
                    ["vest"]        = { item = 26, texture = 5},  -- Body Vest
                    ["torso2"]      = { item = 143, texture = 0},  -- Jas / Vesten
                    ["shoes"]       = { item = 25, texture = 0},  -- Schoenen
                    ["decals"]      = { item = 58, texture = 0},  -- Decals
                    ["accessory"]   = { item = 48, texture = 0},  -- Nek / Das
                    ["bag"]         = { item = 54, texture = 0},  -- Tas
                    ["hat"]         = { item = -1, texture = 0},  -- Pet
                    ["glass"]       = { item = 0, texture = 0},  -- Bril
            --      ["ear"]         = { item = -1, texture = 0},  -- Oor accessoires
                    ["mask"]         = { item = 141, texture = 0},  -- Masker
                },
            },
            [5] = {
                outfitLabel = "VP Onopvallend Kort",
                outfitData = {
                    ["pants"]       = { item = 108, texture = 0},  -- Broek
                    ["arms"]        = { item = 0, texture = 0},  -- Armen
                    ["t-shirt"]     = { item = 92, texture = 0},  -- T Shirt
                    ["vest"]        = { item = 26, texture = 2},  -- Body Vest
                    ["torso2"]      = { item = 147, texture = 0},  -- Jas / Vesten
                    ["shoes"]       = { item = 25, texture = 0},  -- Schoenen
                    ["decals"]      = { item = 58, texture = 0},  -- Decals
                    ["accessory"]   = { item = 48, texture = 0},  -- Nek / Das
                    ["bag"]         = { item = 0, texture = 0},  -- Tas
                    ["hat"]         = { item = -1, texture = 0},  -- Pet
                    ["glass"]       = { item = 0, texture = 0},  -- Bril
            --      ["ear"]         = { item = -1, texture = 0},  -- Oor accessoires
                    ["mask"]         = { item = 141, texture = 0},  -- Masker
                },
            },
            [6] = {
                outfitLabel = "Zulu piloot en waarnemer",
                outfitData = {
                    ["pants"]       = { item = 31, texture = 0},  -- Broek
                    ["arms"]        = { item = 44, texture = 0},  -- Armen
                    ["t-shirt"]     = { item = 111, texture = 0},  -- T Shirt
                    ["vest"]        = { item = 0, texture = 0},  -- Body Vest
                    ["torso2"]      = { item = 276, texture = 0},  -- Jas / Vesten
                    ["shoes"]       = { item = 25, texture = 0},  -- Schoenen
                    ["decals"]      = { item = 0, texture = 0},  -- Decals
                    ["accessory"]   = { item = 48, texture = 0},  -- Nek / Das
                    ["bag"]         = { item = 0, texture = 0},  -- Tas
                    ["hat"]         = { item = 74, texture = 2},  -- Pet
                    ["glass"]       = { item = 0, texture = 0},  -- Bril
            --      ["ear"]         = { item = -1, texture = 0},  -- Oor accessoires
                    ["mask"]         = { item = 141, texture = 0},  -- Masker
                },
            },
            [7] = {
                outfitLabel = "Motoragent", -- Start bij Agent Rang
                outfitData = {
                    ["pants"]       = { item = 67, texture = 0},  -- Broek
                    ["arms"]        = { item = 17, texture = 0},  -- Armen
                    ["t-shirt"]     = { item = 108, texture = 0},  -- T Shirt
                    ["vest"]        = { item = 0, texture = 0},  -- Body Vest
                    ["torso2"]      = { item = 221, texture = 2},  -- Jas / Vesten
                    ["shoes"]       = { item = 25, texture = 0},  -- Schoenen
                    ["decals"]      = { item = 0, texture = 0},  -- Decals
                    ["accessory"]   = { item = 98, texture = 0},  -- Nek / Das
                    ["bag"]         = { item = 54, texture = 0},  -- Tas
                    ["hat"]         = { item = 17, texture = 0},  -- Pet
                    ["glass"]       = { item = 23, texture = 0},  -- Bril
            --      ["ear"]         = { item = -1, texture = 0},  -- Oor accessoires
                    ["mask"]         = { item = 189, texture = 0},  -- Masker
                },
            },
            [8] = {
                outfitLabel = "EOD",
                outfitData = {
                    ["pants"]       = { item = 11, texture = 4},  -- Broek
                    ["arms"]        = { item = 17, texture = 0},  -- Armen
                    ["t-shirt"]     = { item = 0, texture = 0},  -- T Shirt
                    ["vest"]        = { item = 0, texture = 0},  -- Body Vest
                    ["torso2"]      = { item = 46, texture = 0},  -- Jas / Vesten
                    ["shoes"]       = { item = 13, texture = 2},  -- Schoenen
                    ["decals"]      = { item = 0, texture = 0},  -- Decals
                    ["accessory"]   = { item = 0, texture = 0},  -- Nek / Das
                    ["bag"]         = { item = 0, texture = 0},  -- Tas
                    ["hat"]         = { item = 93, texture = 0},  -- Pet
                    ["glass"]       = { item = 0, texture = 0},  -- Bril
                    ["ear"]         = { item = -1, texture = 0},  -- Oor accessoires
                    ["mask"]         = { item = 205, texture = 0},  -- Masker
                },
            },
            [9] = {
                outfitLabel = "Beveiligingseenheid",
                outfitData = {
                    ["pants"]       = { item = 4, texture = 6},  -- Broek
                    ["arms"]        = { item = 107, texture = 9},  -- Armen
                    ["t-shirt"]     = { item = 110, texture = 0},  -- T Shirt
                    ["vest"]        = { item = 7, texture = 1},  -- Body Vest
                    ["torso2"]      = { item = 111, texture = 3},  -- Jas / Vesten
                    ["shoes"]       = { item = 7, texture = 6},  -- Schoenen
                    ["decals"]      = { item = 0, texture = 0},  -- Decals
                    ["accessory"]   = { item = 100, texture = 0},  -- Nek / Das
                    ["bag"]         = { item = 0, texture = 0},  -- Tas
                    ["hat"]         = { item = 129, texture = 6},  -- Pet
                    ["glass"]       = { item = 0, texture = 0},  -- Bril
                    ["ear"]         = { item = -1, texture = 0},  -- Oor accessoires
                    ["mask"]         = { item = 17, texture = 7},  -- Masker
                },
            },
            [10] = {
                outfitLabel = "Sport Outfit",
                outfitData = {
                    ["pants"]       = { item = 108, texture = 0},  -- Broek
                    ["arms"]        = { item = 0, texture = 0},  -- Armen
                    ["t-shirt"]     = { item = 99, texture = 0},  -- T Shirt
                    ["vest"]        = { item = 0, texture = 0},  -- Body Vest
                    ["torso2"]      = { item = 147, texture = 1},  -- Jas / Vesten
                    ["shoes"]       = { item = 25, texture = 0},  -- Schoenen
                    ["decals"]      = { item = 0, texture = 0},  -- Decals
                    ["accessory"]   = { item = 48, texture = 0},  -- Nek / Das
                    ["bag"]         = { item = -1, texture = 0},  -- Tas
                    ["hat"]         = { item = 0, texture = 0},  -- Pet
                    ["glass"]       = { item = -1, texture = 0},  -- Bril
                    ["ear"]         = { item = -1, texture = 0},  -- Oor accessoires
                    ["mask"]         = { item = 141, texture = 0},  -- Masker
                },
            },
            [11] = {
                outfitLabel = "IBT Kort",
                outfitData = {
                    ["pants"]       = { item = 108, texture = 0},  -- Broek
                    ["arms"]        = { item = 0, texture = 0},  -- Armen
                    ["t-shirt"]     = { item = 92, texture = 0},  -- T Shirt
                    ["vest"]        = { item = 0, texture = 0},  -- Body Vest
                    ["torso2"]      = { item = 129, texture = 0},  -- Jas / Vesten
                    ["shoes"]       = { item = 25, texture = 0},  -- Schoenen
                    ["decals"]      = { item = 0, texture = 0},  -- Decals
                    ["accessory"]   = { item = 48, texture = 0},  -- Nek / Das
                    ["bag"]         = { item = 0, texture = 0},  -- Tas
                    ["hat"]         = { item = -1, texture = 0},  -- Pet
                    ["glass"]       = { item = -1, texture = 0},  -- Bril
                    ["ear"]         = { item = -1, texture = 0},  -- Oor accessoires
                    ["mask"]         = { item = 141, texture = 0},  -- Masker
                },
            },
            [12] = {
                outfitLabel = "IBT Lang",
                outfitData = {
                    ["pants"]       = { item = 108, texture = 0},  -- Broek
                    ["arms"]        = { item = 4, texture = 0},  -- Armen
                    ["t-shirt"]     = { item = 92, texture = 0},  -- T Shirt
                    ["vest"]        = { item = 0, texture = 0},  -- Body Vest
                    ["torso2"]      = { item = 130	, texture = 0},  -- Jas / Vesten
                    ["shoes"]       = { item = 25, texture = 0},  -- Schoenen
                    ["decals"]      = { item = 0, texture = 0},  -- Decals
                    ["accessory"]   = { item = 48, texture = 0},  -- Nek / Das
                    ["bag"]         = { item = 0, texture = 0},  -- Tas
                    ["hat"]         = { item = -1, texture = 0},  -- Pet
                    ["glass"]       = { item = -1, texture = 0},  -- Bril
                    ["ear"]         = { item = -1, texture = 0},  -- Oor accessoires
                    ["mask"]         = { item = 141, texture = 0},  -- Masker
                },
            },
            [13] = {
                outfitLabel = "Forensische Opsporing",
                outfitData = {
                    ["pants"]       = { item = 56, texture = 0},  -- Broek
                    ["arms"]        = { item = 1, texture = 0},  -- Armen
                    ["t-shirt"]     = { item = 15, texture = 0},  -- T Shirt
                    ["vest"]        = { item = 0, texture = 0},  -- Body Vest
                    ["torso2"]      = { item = 18, texture = 0},  -- Jas / Vesten
                    ["shoes"]       = { item = 25, texture = 0},  -- Schoenen
                    ["decals"]      = { item = 0, texture = 0},  -- Decals
                    ["accessory"]   = { item = 48, texture = 0},  -- Nek / Das
                    ["bag"]         = { item = 0, texture = 0},  -- Tas
                    ["hat"]         = { item = -1, texture = 0},  -- Pet
                    ["glass"]       = { item = 0, texture = 0},  -- Bril
            --      ["ear"]         = { item = -1, texture = 0},  -- Oor accessoires
                    ["mask"]         = { item = 141, texture = 0},  -- Masker
                },
            },
            [14] = {
                outfitLabel = "Recherche",
                outfitData = {
                    ["pants"]       = { item = 4, texture = 2},  -- Broek
                    ["arms"]        = { item = 1, texture = 0},  -- Armen
                    ["t-shirt"]     = { item = 76, texture = 1},  -- T Shirt
                    ["vest"]        = { item = 0, texture = 0},  -- Body Vest
                    ["torso2"]      = { item = 35, texture = 0},  -- Jas / Vesten
                    ["shoes"]       = { item = 31, texture = 1},  -- Schoenen
                    ["decals"]      = { item = 0, texture = 0},  -- Decals
                    ["accessory"]   = { item = 48, texture = 0},  -- Nek / Das
                    ["bag"]         = { item = -1, texture = 0},  -- Tas
                    ["hat"]         = { item = 0, texture = 0},  -- Pet
                    ["glass"]       = { item = -1, texture = 0},  -- Bril
                    ["ear"]         = { item = -1, texture = 0},  -- Oor accessoires
                    ["mask"]         = { item = 141, texture = 0},  -- Masker
                },
            }, 
            [15] = {
                outfitLabel = "Kmar kort",
                outfitData = {
                    ["pants"]       = { item = 56, texture = 2},  -- Broek
                    ["arms"]        = { item = 0, texture = 0},  -- Armen
                    ["t-shirt"]     = { item = 51, texture = 1},  -- T Shirt
                    ["vest"]        = { item = 19, texture = 5},  -- Body Vest
                    ["torso2"]      = { item = 29, texture = 0},  -- Jas / Vesten
                    ["shoes"]       = { item = 25, texture = 0},  -- Schoenen
                    ["decals"]      = { item = 56, texture = 0},  -- Decals
                    ["accessory"]   = { item = 96, texture = 0},  -- Nek / Das
                    ["bag"]         = { item = -1, texture = 0},  -- Tas
                    ["hat"]         = { item = 1, texture = 0},  -- Pet
                    ["glass"]       = { item = -1, texture = 0},  -- Bril
            --      ["ear"]         = { item = -1, texture = 0},  -- Oor accessoires
                    ["mask"]         = { item = 141, texture = 0},  -- Masker
                },
            },
            [16] = {
                outfitLabel = "Kmar lang",
                outfitData = {
                    ["pants"]       = { item = 56, texture = 2},  -- Broek
                    ["arms"]        = { item = 1, texture = 0},  -- Armen
                    ["t-shirt"]     = { item = 109, texture = 1},  -- T Shirt
                    ["vest"]        = { item = 19, texture = 5},  -- Body Vest
                    ["torso2"]      = { item = 26, texture = 1},  -- Jas / Vesten
                    ["shoes"]       = { item = 25, texture = 0},  -- Schoenen
                    ["decals"]      = { item = 56, texture = 0},  -- Decals
                    ["accessory"]   = { item = 96, texture = 0},  -- Nek / Das
                    ["bag"]         = { item = -1, texture = 0},  -- Tas
                    ["hat"]         = { item = 1, texture = 0},  -- Pet
                    ["glass"]       = { item = -1, texture = 0},  -- Bril
            --      ["ear"]         = { item = -1, texture = 0},  -- Oor accessoires
                    ["mask"]         = { item = 141, texture = 0},  -- Masker
                },
            },
            [17] = {
                outfitLabel = "Kmar zwaar",
                outfitData = {
                    ["pants"]       = { item = 52, texture = 1},  -- Broek
                    ["arms"]        = { item = 1, texture = 0},  -- Armen
                    ["t-shirt"]     = { item = 101, texture = 0},  -- T Shirt
                    ["vest"]        = { item = 12, texture = 2},  -- Body Vest
                    ["torso2"]      = { item = 219, texture = 9},  -- Jas / Vesten
                    ["shoes"]       = { item = 25, texture = 0},  -- Schoenen
                    ["decals"]      = { item = 0, texture = 0},  -- Decals
                    ["accessory"]   = { item = 87, texture = 0},  -- Nek / Das
                    ["bag"]         = { item = -1, texture = 0},  -- Tas
                    ["hat"]         = { item = 1, texture = 0},  -- Pet
                    ["glass"]       = { item = -1, texture = 0},  -- Bril
            --      ["ear"]         = { item = -1, texture = 0},  -- Oor accessoires
                    ["mask"]         = { item = 141, texture = 0},  -- Masker
                },
            },
            [18] = {
                outfitLabel = "BOT",
                outfitData = {
                    ["pants"]       = { item = 4, texture = 7},  -- Broek
                    ["arms"]        = { item = 165, texture = 0},  -- Armen
                    ["t-shirt"]     = { item = 122, texture = 0},  -- T Shirt
                    ["vest"]        = { item = 4, texture = 4},  -- Body Vest
                    ["torso2"]      = { item = 186, texture = 0},  -- Jas / Vesten
                    ["shoes"]       = { item = 31, texture = 1},  -- Schoenen
                    ["decals"]      = { item = 0, texture = 0},  -- Decals
                    ["accessory"]   = { item = 98, texture = 0},  -- Nek / Das
                    ["bag"]         = { item = 0, texture = 0},  -- Tas
                    ["hat"]         = { item = 125, texture = 0},  -- Pet
                    ["glass"]       = { item = 0, texture = 0},  -- Bril
                    ["ear"]         = { item = -1, texture = 0},  -- Oor accessoires
                    ["mask"]         = { item = 119, texture = 0},  -- Masker
                },
            },
            [19] = {
                outfitLabel = "DSI Briefing", -- DSI Briefing Uniform, Standaard DSI T-Shirt met Masker en Baret
                outfitData = {
                    ["pants"]       = { item = 4, texture = 6},  -- Broek
                    ["arms"]        = { item = 41, texture = 0},  -- Armen
                    ["t-shirt"]     = { item = 118, texture = 1},  -- T Shirt
                    ["vest"]        = { item = 0, texture = 0},  -- Body Vest
                    ["torso2"]      = { item = 100, texture = 0},  -- Jas / Vesten
                    ["shoes"]       = { item = 86, texture = 0},  -- Schoenen
                    ["decals"]      = { item = 0, texture = 0},  -- Decals
                    ["accessory"]   = { item = 102, texture = 0},  -- Nek / Das
                    ["bag"]         = { item = 0, texture = 0},  -- Tas
                    ["hat"]         = { item = 123, texture = 1},  -- Pet
                    ["glass"]       = { item = 0, texture = 0},  -- Bril
                    ["ear"]         = { item = -1, texture = 0},  -- Oor accessoires
                    ["mask"]         = { item = 61, texture = 0},  -- Masker
                },
            },
            [20] = {
                outfitLabel = "DSI - RRT", -- Grijs DSI RRT Uniform
                outfitData = {
                    ["pants"]       = { item = 4, texture = 5},  -- Broek
                    ["arms"]        = { item = 165, texture = 0},  -- Armen
                    ["t-shirt"]     = { item = 116, texture = 1},  -- T Shirt
                    ["vest"]        = { item = 4, texture = 0},  -- Body Vest
                    ["torso2"]      = { item = 212, texture = 0},  -- Jas / Vesten
                    ["shoes"]       = { item = 77, texture = 2},  -- Schoenen
                    ["decals"]      = { item = 0, texture = 0},  -- Decals
                    ["accessory"]   = { item = 88, texture = 0},  -- Nek / Das
                    ["bag"]         = { item = 0, texture = 0},  -- Tas
                    ["hat"]         = { item = 124, texture = 1},  -- Pet
                    ["glass"]       = { item = 0, texture = 0},  -- Bril
                    ["ear"]         = { item = -1, texture = 0},  -- Oor accessoires
                    ["mask"]         = { item = 119, texture = 1},  -- Masker
                },
            },
            [21] = {
                outfitLabel = "DSI - Breacher",
                outfitData = {
                    ["pants"]       = { item = 4, texture = 5},  -- Broek
                    ["arms"]        = { item = 110, texture = 1},  -- Armen
                    ["t-shirt"]     = { item = 118, texture = 1},  -- T Shirt
                    ["vest"]        = { item = 30, texture = 0},  -- Body Vest
                    ["torso2"]      = { item = 177, texture = 2},  -- Jas / Vesten
                    ["shoes"]       = { item = 57, texture = 0},  -- Schoenen
                    ["decals"]      = { item = 0, texture = 0},  -- Decals
                    ["accessory"]   = { item = 88, texture = 0},  -- Nek / Das
                    ["bag"]         = { item = 50, texture = 7},  -- Tas
                    ["hat"]         = { item = 92, texture = 0},  -- Pet
                    ["glass"]       = { item = 0, texture = 0},  -- Bril
                    ["ear"]         = { item = -1, texture = 0},  -- Oor accessoires
                    ["mask"]         = { item = 119, texture = 1},  -- Masker
                },
            },
            [22] = {
                outfitLabel = "DSI - Medic",
                outfitData = {
                    ["pants"]       = { item = 4, texture = 5},  -- Broek
                    ["arms"]        = { item = 110, texture = 1},  -- Armen
                    ["t-shirt"]     = { item = 85, texture = 1},  -- T Shirt
                    ["vest"]        = { item = 24, texture = 5},  -- Body Vest
                    ["torso2"]      = { item = 177, texture = 2},  -- Jas / Vesten
                    ["shoes"]       = { item = 57, texture = 0},  -- Schoenen
                    ["decals"]      = { item = 0, texture = 0},  -- Decals
                    ["accessory"]   = { item = 88, texture = 0},  -- Nek / Das
                    ["bag"]         = { item = 49, texture = 5},  -- Tas
                    ["hat"]         = { item = 79, texture = 0},  -- Pet
                    ["glass"]       = { item = 0, texture = 0},  -- Bril
                    ["ear"]         = { item = -1, texture = 0},  -- Oor accessoires
                    ["mask"]         = { item = 119, texture = 1},  -- Masker
                },
            },
            [23] = {
                outfitLabel = "DSI - Onderhandelaar", -- Middel uniform, met baret op en af optie
                outfitData = {
                    ["pants"]       = { item = 4, texture = 5},  -- Broek
                    ["arms"]        = { item = 42, texture = 1},  -- Armen
                    ["t-shirt"]     = { item = 114, texture = 1},  -- T Shirt
                    ["vest"]        = { item = 11, texture = 0},  -- Body Vest
                    ["torso2"]      = { item = 177, texture = 2},  -- Jas / Vesten
                    ["shoes"]       = { item = 7, texture = 3},  -- Schoenen
                    ["decals"]      = { item = 0, texture = 0},  -- Decals
                    ["accessory"]   = { item = 96, texture = 1},  -- Nek / Das
                    ["bag"]         = { item = 0, texture = 0},  -- Tas
                    ["hat"]         = { item = 123, texture = 1},  -- Pet
                    ["glass"]       = { item = 0, texture = 0},  -- Bril
                    ["ear"]         = { item = -1, texture = 0},  -- Oor accessoires
                    ["mask"]         = { item = 61, texture = 0},  -- Masker
                },
            },
            [24] = {
                outfitLabel = "Noodhulp Vrouw Kort",
                outfitData = {
                    ["pants"]       = { item = 99, texture = 0},  -- Broek
                    ["arms"]        = { item = 44, texture = 0},  -- Armen
                    ["t-shirt"]     = { item = 100, texture = 0},  -- T Shirt
                    ["vest"]        = { item = 3, texture = 0},  -- Body Vest
                    ["torso2"]      = { item = 229, texture = 1},  -- Jas / Vesten
                    ["shoes"]       = { item = 25, texture = 0},  -- Schoenen
                    ["decals"]      = { item = 2, texture = 0},  -- Decals
                    ["accessory"]   = { item = 35, texture = 0},  -- Nek / Das
                    ["bag"]         = { item = -1, texture = 0},  -- Tas
                    ["hat"]         = { item = 0, texture = 0},  -- Pet
                    ["glass"]       = { item = -1, texture = 0},  -- Bril
            --      ["ear"]         = { item = -1, texture = 0},  -- Oor accessoires
                    ["mask"]         = { item = 141, texture = 0},  -- Masker
                },
            },
            [25] = {
                outfitLabel = "Noodhulp Vrouw Lang",
                outfitData = {
                    ["pants"]       = { item = 99, texture = 0},  -- Broek
                    ["arms"]        = { item = 36, texture = 0},  -- Armen
                    ["t-shirt"]     = { item = 100, texture = 0},  -- T Shirt
                    ["vest"]        = { item = 3, texture = 0},  -- Body Vest
                    ["torso2"]      = { item = 145, texture = 1},  -- Jas / Vesten
                    ["shoes"]       = { item = 25, texture = 0},  -- Schoenen
                    ["decals"]      = { item = 2, texture = 0},  -- Decals
                    ["accessory"]   = { item = 35, texture = 0},  -- Nek / Das
                    ["bag"]         = { item = -1, texture = 0},  -- Tas
                    ["hat"]         = { item = 0, texture = 0},  -- Pet
                    ["glass"]       = { item = -1, texture = 0},  -- Bril
            --      ["ear"]         = { item = -1, texture = 0},  -- Oor accessoires
                    ["mask"]         = { item = 141, texture = 0},  -- Masker
                },
            },
            
        },
        ["female"] = {},
    },
    ["ambulance"] = {
        ["male"] = {
            [1] = {
                outfitLabel = "T-Shirt",
                outfitData = {
                    ["pants"]       = { item = 107,texture = 0},  -- Broek
                    ["arms"]        = { item = 85, texture = 0},  -- Armen
                    ["t-shirt"]     = { item = 15, texture = 0},  -- T Shirt
                    ["vest"]        = { item = 0, texture = 0},  -- Body Vest
                    ["torso2"]      = { item = 94, texture = 0},  -- Jas / Vesten
                    ["shoes"]       = { item = 25, texture = 0},  -- Schoenen
                    ["decals"]      = { item = 56, texture = 0},  -- Decals
                    ["accessory"]   = { item = 42, texture = 0},  -- Nek / Das
                    ["bag"]         = { item = 0, texture = 0},  -- Tas
                    ["hat"]         = { item = -1, texture = -1},  -- Pet
                    ["glass"]       = { item = 0, texture = 0},  -- Bril
                    ["ear"]         = { item = 0, texture = 0},  -- Oor accessoires
                    ["mask"]        = { item = 141, texture = 0},  -- Masker
                },
            },
            [2] = {
                outfitLabel = "Arts",
                outfitData = {
                    ["pants"]       = { item = 28,texture = 8},  -- Broek
                    ["arms"]        = { item = 85, texture = 0},  -- Armen
                    ["t-shirt"]     = { item = 15, texture = 0},  -- T Shirt
                    ["vest"]        = { item = 0, texture = 0},  -- Body Vest
                    ["torso2"]      = { item = 22, texture = 0},  -- Jas / Vesten
                    ["shoes"]       = { item = 7, texture = 0},  -- Schoenen
                    ["decals"]      = { item = 0, texture = 0},  -- Decals
                    ["accessory"]   = { item = 126, texture = 0},  -- Nek / Das
                    ["bag"]         = { item = 0, texture = 0},  -- Tas
                    ["hat"]         = { item = -1, texture = -1},  -- Pet
                    ["glass"]       = { item = 0, texture = 0},  -- Bril
                    ["ear"]         = { item = 0, texture = 0},  -- Oor accessoires
                    ["mask"]        = { item = 141, texture = 0},  -- Masker
                },
            },
            [3] = {
                outfitLabel = "Rapid Responder Motor",
                outfitData = {
                    ["pants"]       = { item = 49,texture = 0},  -- Broek
                    ["arms"]        = { item = 86, texture = 0},  -- Armen
                    ["t-shirt"]     = { item = 135, texture = 0},  -- T Shirt
                    ["vest"]        = { item = 0, texture = 0},  -- Body Vest
                    ["torso2"]      = { item = 149, texture = 1},  -- Jas / Vesten
                    ["shoes"]       = { item = 25, texture = 0},  -- Schoenen
                    ["decals"]      = { item = 0, texture = 0},  -- Decals
                    ["accessory"]   = { item = 0, texture = 0},  -- Nek / Das
                    ["bag"]         = { item = 0, texture = 0},  -- Tas
                    ["hat"]         = { item = 17, texture = 1},  -- Pet
                    ["glass"]       = { item = 0, texture = 0},  -- Bril
                    ["ear"]         = { item = 0, texture = 0},  -- Oor accessoires
                    ["mask"]        = { item = 141, texture = 0},  -- Masker
                },
            },
            [4] = {
                outfitLabel = "Jas",
                outfitData = {
                    ["pants"]       = { item = 49,texture = 0},  -- Broek
                    ["arms"]        = { item = 86, texture = 0},  -- Armen
                    ["t-shirt"]     = { item = 135, texture = 0},  -- T Shirt
                    ["vest"]        = { item = 0, texture = 0},  -- Body Vest
                    ["torso2"]      = { item = 149, texture = 1},  -- Jas / Vesten
                    ["shoes"]       = { item = 25, texture = 0},  -- Schoenen
                    ["decals"]      = { item = 0, texture = 0},  -- Decals
                    ["accessory"]   = { item = 0, texture = 0},  -- Nek / Das
                    ["bag"]         = { item = 0, texture = 0},  -- Tas
                    ["hat"]         = { item = 0, texture = 0},  -- Pet
                    ["glass"]       = { item = 0, texture = 0},  -- Bril
                    ["ear"]         = { item = 0, texture = 0},  -- Oor accessoires
                    ["mask"]        = { item = 141, texture = 0},  -- Masker
                },
            },
			[5] = {
                outfitLabel = "Jas MMT",
                outfitData = {
                    ["pants"]       = { item = 48,texture = 2},  -- Broek
                    ["arms"]        = { item = 86, texture = 0},  -- Armen
                    ["t-shirt"]     = { item = 135, texture = 0},  -- T Shirt
                    ["vest"]        = { item = 0, texture = 0},  -- Body Vest
                    ["torso2"]      = { item = 149, texture = 0},  -- Jas / Vesten
                    ["shoes"]       = { item = 25, texture = 0},  -- Schoenen
                    ["decals"]      = { item = 0, texture = 0},  -- Decals
                    ["accessory"]   = { item = 0, texture = 0},  -- Nek / Das
                    ["bag"]         = { item = 0, texture = 0},  -- Tas
                    ["hat"]         = { item = -1, texture = 0},  -- Pet
                    ["glass"]       = { item = 0, texture = 0},  -- Bril
                    ["ear"]         = { item = 0, texture = 0},  -- Oor accessoires
                    ["mask"]        = { item = 141, texture = 0},  -- Masker	
				},
			},
			[6] = {
                outfitLabel = "MMT Piloot",
                outfitData = {
                    ["pants"]       = { item = 48,texture = 2},  -- Broek
                    ["arms"]        = { item = 86, texture = 0},  -- Armen
                    ["t-shirt"]     = { item = 15, texture = 0},  -- T Shirt
                    ["vest"]        = { item = 0, texture = 0},  -- Body Vest
                    ["torso2"]      = { item = 110, texture = 0},  -- Jas / Vesten
                    ["shoes"]       = { item = 25, texture = 0},  -- Schoenen
                    ["decals"]      = { item = 58, texture = 0},  -- Decals
                    ["accessory"]   = { item = 0, texture = 0},  -- Nek / Das
                    ["bag"]         = { item = 0, texture = 0},  -- Tas
                    ["hat"]         = { item = 74, texture = 2},  -- Pet
                    ["glass"]       = { item = 0, texture = 0},  -- Bril
                    ["ear"]         = { item = 0, texture = 0},  -- Oor accessoires
                    ["mask"]        = { item = 141, texture = 0},  -- Masker	
				},
			},
            [7] = {
                outfitLabel = "Jas OvD-G",
                outfitData = {
                    ["pants"]       = { item = 49,texture = 2},  -- Broek
                    ["arms"]        = { item = 86, texture = 0},  -- Armen
                    ["t-shirt"]     = { item = 135, texture = 0},  -- T Shirt
                    ["vest"]        = { item = 0, texture = 0},  -- Body Vest
                    ["torso2"]      = { item = 149, texture = 2},  -- Jas / Vesten
                    ["shoes"]       = { item = 25, texture = 0},  -- Schoenen
                    ["decals"]      = { item = 0, texture = 0},  -- Decals
                    ["accessory"]   = { item = 0, texture = 0},  -- Nek / Das
                    ["bag"]         = { item = 0, texture = 0},  -- Tas
                    ["hat"]         = { item = -1, texture = 0},  -- Pet
                    ["glass"]       = { item = 0, texture = 0},  -- Bril
                    ["ear"]         = { item = 0, texture = 0},  -- Oor accessoires
                    ["mask"]        = { item = 141, texture = 0},  -- Masker	
				},
			},
            [8] = {
                outfitLabel = "Dokterjas",
                outfitData = {
                    ["pants"]       = { item = 22,texture = 0},  -- Broek
                    ["arms"]        = { item = 88, texture = 0},  -- Armen
                    ["t-shirt"]     = { item = 11, texture = 6},  -- T Shirt
                    ["vest"]        = { item = 0, texture = 0},  -- Body Vest
                    ["torso2"]      = { item = 274, texture = 0},  -- Jas / Vesten
                    ["shoes"]       = { item = 10, texture = 0},  -- Schoenen
                    ["decals"]      = { item = 0, texture = 0},  -- Decals
                    ["accessory"]   = { item = 0, texture = 0},  -- Nek / Das
                    ["bag"]         = { item = 0, texture = 0},  -- Tas
                    ["hat"]         = { item = -1, texture = 0},  -- Pet
                    ["glass"]       = { item = 0, texture = 0},  -- Bril
                    ["ear"]         = { item = 0, texture = 0},  -- Oor accessoires
                    ["mask"]        = { item = 141, texture = 0},  -- Masker	
				},
			},
			[9] = {
                outfitLabel = "T-Shirt Zwaar Vest",
                outfitData = {
                    ["pants"]       = { item = 49,texture = 0},  -- Broek
                    ["arms"]        = { item = 85, texture = 0},  -- Armen
                    ["t-shirt"]     = { item = 15, texture = 0},  -- T Shirt
                    ["vest"]        = { item = 19, texture = 4},  -- Body Vest
                    ["torso2"]      = { item = 73, texture = 0},  -- Jas / Vesten
                    ["shoes"]       = { item = 25, texture = 0},  -- Schoenen
                    ["decals"]      = { item = 0, texture = 0},  -- Decals
                    ["accessory"]   = { item = 0, texture = 0},  -- Nek / Das
                    ["bag"]         = { item = 0, texture = 0},  -- Tas
                    ["hat"]         = { item = -1, texture = -1},  -- Pet
                    ["glass"]       = { item = 0, texture = 0},  -- Bril
                    ["ear"]         = { item = 0, texture = 0},  -- Oor accessoires
                    ["mask"]        = { item = 141, texture = 0},  -- Masker
                },
            },
            [10] = {
                outfitLabel = "Instructeur",
                outfitData = {
                    ["pants"]       = { item = 107,texture = 0},  -- Broek
                    ["arms"]        = { item = 85, texture = 0},  -- Armen
                    ["t-shirt"]     = { item = 15, texture = 0},  -- T Shirt
                    ["vest"]        = { item = 0, texture = 0},  -- Body Vest
                    ["torso2"]      = { item = 94, texture = 1},  -- Jas / Vesten
                    ["shoes"]       = { item = 25, texture = 0},  -- Schoenen
                    ["decals"]      = { item = 56, texture = 0},  -- Decals
                    ["accessory"]   = { item = 42, texture = 0},  -- Nek / Das
                    ["bag"]         = { item = 0, texture = 0},  -- Tas
                    ["hat"]         = { item = -1, texture = -1},  -- Pet
                    ["glass"]       = { item = 0, texture = 0},  -- Bril
                    ["ear"]         = { item = 0, texture = 0},  -- Oor accessoires
                    ["mask"]        = { item = 141, texture = 0},  -- Masker
                },
            },
            [11] = {
                outfitLabel = "T-Shirt (Vrouw)",
                outfitData = {
                    ["pants"]       = { item = 49,texture = 0},  -- Broek
                    ["arms"]        = { item = 109, texture = 0},  -- Armen
                    ["t-shirt"]     = { item = 14, texture = 0},  -- T Shirt
                    ["vest"]        = { item = 0, texture = 0},  -- Body Vest
                    ["torso2"]      = { item = 152, texture = 0},  -- Jas / Vesten
                    ["shoes"]       = { item = 25, texture = 0},  -- Schoenen
                    ["decals"]      = { item = 0, texture = 0},  -- Decals
                    ["accessory"]   = { item = 0, texture = 0},  -- Nek / Das
                    ["bag"]         = { item = 0, texture = 0},  -- Tas
                    ["hat"]         = { item = -1, texture = -1},  -- Pet
                    ["glass"]       = { item = 0, texture = 0},  -- Bril
                    ["ear"]         = { item = 0, texture = 0},  -- Oor accessoires
                    ["mask"]        = { item = 141, texture = 0},  -- Masker
                },
            },
            [12] = {
                outfitLabel = "Rapid Responder Motor (Vrouw)",
                outfitData = {
                    ["pants"]       = { item = 49,texture = 0},  -- Broek
                    ["arms"]        = { item = 109, texture = 0},  -- Armen
                    ["t-shirt"]     = { item = 57, texture = 0},  -- T Shirt
                    ["vest"]        = { item = 0, texture = 0},  -- Body Vest
                    ["torso2"]      = { item = 60, texture = 0},  -- Jas / Vesten
                    ["shoes"]       = { item = 25, texture = 0},  -- Schoenen
                    ["decals"]      = { item = 0, texture = 0},  -- Decals
                    ["accessory"]   = { item = 0, texture = 0},  -- Nek / Das
                    ["bag"]         = { item = 0, texture = 0},  -- Tas
                    ["hat"]         = { item = 17, texture = 1},  -- Pet
                    ["glass"]       = { item = 0, texture = 0},  -- Bril
                    ["ear"]         = { item = 0, texture = 0},  -- Oor accessoires
                    ["mask"]        = { item = 141, texture = 0},  -- Masker
                },
            },
            [13] = {
                outfitLabel = "Jas MMT (Vrouw)",
                outfitData = {
                    ["pants"]       = { item = 51,texture = 1},  -- Broek
                    ["arms"]        = { item = 109, texture = 0},  -- Armen
                    ["t-shirt"]     = { item = 57, texture = 0},  -- T Shirt
                    ["vest"]        = { item = 0, texture = 0},  -- Body Vest
                    ["torso2"]      = { item = 148, texture = 0},  -- Jas / Vesten
                    ["shoes"]       = { item = 25, texture = 0},  -- Schoenen
                    ["decals"]      = { item = 0, texture = 0},  -- Decals
                    ["accessory"]   = { item = 0, texture = 0},  -- Nek / Das
                    ["bag"]         = { item = 0, texture = 0},  -- Tas
                    ["hat"]         = { item = -1, texture = -1},  -- Pet
                    ["glass"]       = { item = 0, texture = 0},  -- Bril
                    ["ear"]         = { item = 0, texture = 0},  -- Oor accessoires
                    ["mask"]        = { item = 141, texture = 0},  -- Masker
                },
            },
            [14] = {
                outfitLabel = "Jas OvD-G (Vrouw)",
                outfitData = {
                    ["pants"]       = { item = 51,texture = 0},  -- Broek
                    ["arms"]        = { item = 109, texture = 0},  -- Armen
                    ["t-shirt"]     = { item = 57, texture = 0},  -- T Shirt
                    ["vest"]        = { item = 0, texture = 0},  -- Body Vest
                    ["torso2"]      = { item = 148, texture = 5},  -- Jas / Vesten
                    ["shoes"]       = { item = 25, texture = 0},  -- Schoenen
                    ["decals"]      = { item = 0, texture = 0},  -- Decals
                    ["accessory"]   = { item = 0, texture = 0},  -- Nek / Das
                    ["bag"]         = { item = 0, texture = 0},  -- Tas
                    ["hat"]         = { item = -1, texture = -1},  -- Pet
                    ["glass"]       = { item = 0, texture = 0},  -- Bril
                    ["ear"]         = { item = 0, texture = 0},  -- Oor accessoires
                    ["mask"]        = { item = 141, texture = 0},  -- Masker
                },
            },
            [15] = {
                outfitLabel = "Instructeur (Vrouw)",
                outfitData = {
                    ["pants"]       = { item = 49,texture = 0},  -- Broek
                    ["arms"]        = { item = 109, texture = 0},  -- Armen
                    ["t-shirt"]     = { item = 14, texture = 0},  -- T Shirt
                    ["vest"]        = { item = 0, texture = 0},  -- Body Vest
                    ["torso2"]      = { item = 68, texture = 1},  -- Jas / Vesten
                    ["shoes"]       = { item = 25, texture = 0},  -- Schoenen
                    ["decals"]      = { item = 0, texture = 0},  -- Decals
                    ["accessory"]   = { item = 0, texture = 0},  -- Nek / Das
                    ["bag"]         = { item = 0, texture = 0},  -- Tas
                    ["hat"]         = { item = -1, texture = -1},  -- Pet
                    ["glass"]       = { item = 0, texture = 0},  -- Bril
                    ["ear"]         = { item = 0, texture = 0},  -- Oor accessoires
                    ["mask"]        = { item = 141, texture = 0},  -- Masker
                },
            },
        },
        ["female"] = {},
    },
    ["mechanic"] = {
        ["male"] = {
            [1] = {
                outfitLabel = "ANWB Outfit", -- Jas Uniform
                outfitData = {
                    ["pants"]       = { item = 46,texture = 1},  -- Broek
                    ["arms"]        = { item = 1, texture = 0},  -- Armen
                    ["t-shirt"]     = { item = 15, texture = 0},  -- T Shirt
                    ["vest"]        = { item = 0, texture = 0},  -- Body Vest
                    ["torso2"]      = { item = 118, texture = 0},  -- Jas / Vesten
                    ["shoes"]       = { item = 25, texture = 0},  -- Schoenen
                    ["decals"]      = { item = 0, texture = 0},  -- Decals
                    ["accessory"]   = { item = 0, texture = 0},  -- Nek / Das
                    ["bag"]         = { item = 0, texture = 0},  -- Tas
                    ["hat"]         = { item = 10, texture = 1},  -- Pet
                    -- ["glass"]       = { item = 0, texture = 0},  -- Bril
                    ["ear"]         = { item = 0, texture = 0},  -- Oor accessoires
                    ["mask"]        = { item = 141, texture = 0},  -- Masker
                },
            },
            [2] = {
                outfitLabel = "HQ Outfit", -- T-Shirt ANWB voor op het ANWB Terrein
                outfitData = {
                    ["pants"]       = { item = 46,texture = 1},  -- Broek
                    ["arms"]        = { item = 41, texture = 0},  -- Armen
                    ["t-shirt"]     = { item = 15, texture = 0},  -- T Shirt
                    ["vest"]        = { item = 0, texture = 0},  -- Body Vest
                    ["torso2"]      = { item = 81, texture = 0},  -- Jas / Vesten
                    ["shoes"]       = { item = 25, texture = 0},  -- Schoenen
                    ["decals"]      = { item = 0, texture = 0},  -- Decals
                    ["accessory"]   = { item = 0, texture = 0},  -- Nek / Das
                    ["bag"]         = { item = 0, texture = 0},  -- Tas
                    ["hat"]         = { item = 10, texture = 1},  -- Pet
                    -- ["glass"]       = { item = 0, texture = 0},  -- Bril
                    ["ear"]         = { item = 0, texture = 0},  -- Oor accessoires
                    ["mask"]        = { item = 141, texture = 0},  -- Masker
                },
            },
            [3] = {
                outfitLabel = "RW Outfit 1", -- Jas Uniform 1
                outfitData = {
                    ["pants"]       = { item = 46,texture = 1},  -- Broek
                    ["arms"]        = { item = 42, texture = 0},  -- Armen
                    ["t-shirt"]     = { item = 15, texture = 0},  -- T Shirt
                    ["vest"]        = { item = 0, texture = 0},  -- Body Vest
                    ["torso2"]      = { item = 118, texture = 0},  -- Jas / Vesten
                    ["shoes"]       = { item = 25, texture = 0},  -- Schoenen
                    ["decals"]      = { item = 0, texture = 0},  -- Decals
                    ["accessory"]   = { item = 0, texture = 0},  -- Nek / Das
                    ["bag"]         = { item = 0, texture = 0},  -- Tas
                    ["hat"]         = { item = 10, texture = 1},  -- Pet
                    -- ["glass"]       = { item = 0, texture = 0},  -- Bril
                    ["ear"]         = { item = 0, texture = 0},  -- Oor accessoires
                    ["mask"]        = { item = 141, texture = 0},  -- Masker
                },
            },
            [4] = {
                outfitLabel = "RW Outfit 2", -- Jas Uniform 2
                outfitData = {
                    ["pants"]       = { item = 46,texture = 1},  -- Broek
                    ["arms"]        = { item = 42, texture = 0},  -- Armen
                    ["t-shirt"]     = { item = 15, texture = 0},  -- T Shirt
                    ["vest"]        = { item = 0, texture = 0},  -- Body Vest
                    ["torso2"]      = { item = 177, texture = 6},  -- Jas / Vesten
                    ["shoes"]       = { item = 25, texture = 0},  -- Schoenen
                    ["decals"]      = { item = 0, texture = 0},  -- Decals
                    ["accessory"]   = { item = 0, texture = 0},  -- Nek / Das
                    ["bag"]         = { item = 0, texture = 0},  -- Tas
                    ["hat"]         = { item = 10, texture = 1},  -- Pet
                    -- ["glass"]       = { item = 0, texture = 0},  -- Bril
                    ["ear"]         = { item = 0, texture = 0},  -- Oor accessoires
                    ["mask"]        = { item = 141, texture = 0},  -- Masker
                },
            },
            [5] = {
                outfitLabel = "ANWB Outfit (vrouw)",
                outfitData = {
                    ["pants"]       = { item = 48, texture = 0},  -- Broek
                    ["arms"]        = { item = 36, texture = 0},  -- Armen
                    ["t-shirt"]     = { item = 14, texture = 0},  -- T Shirt
                    ["vest"]        = { item = 0, texture = 0},  -- Body Vest
                    ["torso2"]      = { item = 106, texture = 0},  -- Jas / Vesten
                    ["shoes"]       = { item = 25, texture = 0},  -- Schoenen
                    ["decals"]      = { item = 0, texture = 0},  -- Decals
                    ["accessory"]   = { item = 0, texture = 0},  -- Nek / Das
                    ["bag"]         = { item = 0, texture = 0},  -- Tas
                    ["hat"]         = { item = 0, texture = 0},  -- Pet
                    ["glass"]       = { item = 0, texture = 0},  -- Bril
                    ["ear"]         = { item = 0, texture = 0},  -- Oor accessoires
                    ["mask"]        = { item = 0, texture = 0},  -- Masker
                },
            },
            [6] = {
                outfitLabel = "HQ Outfit (vrouw)",
                outfitData = {
                    ["pants"]       = { item = 31, texture = 0},  -- Broek
                    ["arms"]        = { item = 7, texture = 0},  -- Armen
                    ["t-shirt"]     = { item = 59, texture = 0},  -- T Shirt
                    ["vest"]        = { item = 0, texture = 0},  -- Body Vest
                    ["torso2"]      = { item = 106, texture = 0},  -- Jas / Vesten
                    ["shoes"]       = { item = 25, texture = 0},  -- Schoenen
                    ["decals"]      = { item = 0, texture = 0},  -- Decals
                    ["accessory"]   = { item = 0, texture = 0},  -- Nek / Das
                    ["bag"]         = { item = 0, texture = 0},  -- Tas
                    ["hat"]         = { item = 0, texture = 0},  -- Pet
                    ["glass"]       = { item = 0, texture = 0},  -- Bril
                    ["ear"]         = { item = 0, texture = 0},  -- Oor accessoires
                    ["mask"]        = { item = 0, texture = 0},  -- Masker
                },
            },
            [7] = {
                outfitLabel = "RW Outfit (vrouw)",
                outfitData = {
                    ["pants"]       = { item = 54, texture = 0},  -- Broek
                    ["arms"]        = { item = 36, texture = 0},  -- Armen
                    ["t-shirt"]     = { item = 14, texture = 0},  -- T Shirt
                    ["vest"]        = { item = 0, texture = 0},  -- Body Vest
                    ["torso2"]      = { item = 231, texture = 6},  -- Jas / Vesten
                    ["shoes"]       = { item = 25, texture = 0},  -- Schoenen
                    ["decals"]      = { item = 0, texture = 0},  -- Decals
                    ["accessory"]   = { item = 0, texture = 0},  -- Nek / Das
                    ["bag"]         = { item = 0, texture = 0},  -- Tas
                    ["hat"]         = { item = 0, texture = 0},  -- Pet
                    ["glass"]       = { item = 0, texture = 0},  -- Bril
                    ["ear"]         = { item = 0, texture = 0},  -- Oor accessoires
                    ["mask"]        = { item = 0, texture = 0},  -- Masker
                },
            },
        },
        ["female"] = {},
    },	
}