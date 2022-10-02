Config = {}

Config.groothandelPrijs = 450000
Config.werknemerSlotPrijs = 75000

-- Groothandel deur locaties
Config.groothandelDeuren = {
    -- Paleto
    [1] = {
        ["deur"] = {x = 53.17, y = 6338.18, z = 31.38, h = 207.68},
        ["voertuig"] = {x = 61.39, y = 6338.14, z = 31.46, h = 29.96}
    },
    [2] = {
        ["deur"] = {x = -6.11, y = 6274.65, z = 31.38, h = 25.74},
	    ["voertuig"] = {x = 4.64, y = 6276.25, z = 31.47, h = 119.77}
    },
    [3] = {
        ["deur"] = {x = 90.67, y = 6340.34, z = 31.38, h = 297.54},
	    ["voertuig"] = {x = 89.17, y = 6325.33, z = 31.47, h = 26.33}
    },
    [4] = {
        ["deur"] = {x = 96.16, y = 6363.26, z = 31.38, h = 207.00},
	    ["voertuig"] = {x = 88.20, y = 6367.69, z = 31.46, h = 26.35}
    },
    [5] = {
        ["deur"] = {x = 148.67, y = 6362.34, z = 31.53, h = 299.72},
	    ["voertuig"] = {x = 157.11, y = 6354.55, z = 31.64, h = 118.57}
    },

    -- Olie velden
    [6] = {
        ["deur"] = {x = 1744.02, y = -1623.07, z = 112.60, h = 280.23},
	    ["voertuig"] = {x = 1741.61, y = -1633.55, z = 112.71, h = 100.01}
    },
    [7] = {
        ["deur"] = {x = 1743.76, y = -1623.03, z = 116.20, h = 353.21},
        ["voertuig"] = {x = 1741.61, y = -1633.55, z = 112.71, h = 100.01}
    },            
    [8] = {
        ["deur"] = {x = 1740.98, y = -1606.75, z = 112.57, h = 279.80},
        ["voertuig"] = {x = 1743.24, y = -1583.20, z = 112.83, h = 99.29}
    },
    [9] = {
        ["deur"] = {x = 1740.93, y = -1606.75, z = 116.20, h = 346.69},
        ["voertuig"] = {x = 1743.24, y = -1583.20, z = 112.83, h = 99.29}
    },

    -- Fabrieken
    [10] = {
        ["deur"] = {x = 976.11, y = -2423.11, z = 30.19, h = 85.36},
        ["voertuig"] = {x = 982.54, y = -2429.41, z = 29.23, h = 175.41}
    },
    [11] = {
        ["deur"] = {x = 975.67, y = -2430.10, z = 30.19, h = 77.20},
        ["voertuig"] = {x = 982.54, y = -2429.41, z = 29.23, h = 175.41}
    },
    [12] = {
        ["deur"] = {x = 822.55, y = -2253.22, z = 30.14, h = 174.73},
        ["voertuig"] = {x = 852.89, y = -2258.70, z = 30.56, h = 358.41}
    },
    [13] = {
        ["deur"] = {x = 838.79, y = -2254.01, z = 30.19, h = 176.87},
        ["voertuig"] = {x = 852.89, y = -2258.70, z = 30.56, h = 358.41}
    },

    -- Haven
    [14] = {
        ["deur"] = {x = -263.65, y = -2485.98, z = 7.30, h = 47.90},
        ["voertuig"] = {x = -258.10, y = -2493.19, z = 6.24, h = 230.49}
    },
    [15] = {
        ["deur"] = {x = -272.30, y = -2496.32, z = 7.30, h = 52.81},
        ["voertuig"] = {x = -265.88, y = -2502.10, z = 6.24, h = 229.30}
    },
}

-- Groothandel shell coords
Config.shellSpots = {
    [1] = {x = 1470.86, y = 6241.49, z = -65.48, h = 179.41, actief = false, magazijnData = nil},
    [2] = {x = 1472.30, y = 6198.32, z = -65.48, h = 179.41, actief = false, magazijnData = nil},
    [3] = {x = 1473.93, y = 6149.54, z = -65.48, h = 179.41, actief = false, magazijnData = nil},
    [4] = {x = 1475.28, y = 6108.77, z = -65.48, h = 179.41, actief = false, magazijnData = nil},
    [5] = {x = 1476.83, y = 6062.39, z = -65.48, h = 179.41, actief = false, magazijnData = nil},
    [6] = {x = 1476.83, y = 6062.39, z = -65.48, h = 179.41, actief = false, magazijnData = nil},
    [7] = {x = 1478.37, y = 6016.02, z = -65.48, h = 179.41, actief = false, magazijnData = nil},
    [8] = {x = 1479.94, y = 5968.85, z = -65.48, h = 179.41, actief = false, magazijnData = nil},
    [9] = {x = 1481.54, y = 5920.87, z = -65.48, h = 179.41, actief = false, magazijnData = nil},
    [10] = {x = 1483.27, y = 5868.90, z = -65.48, h = 179.41, actief = false, magazijnData = nil},
    [11] = {x = 1485.08, y = 5814.53, z = -65.48, h = 179.41, actief = false, magazijnData = nil},
    [12] = {x = 1486.81, y = 5762.56, z = -65.48, h = 179.41, actief = false, magazijnData = nil},
    [13] = {x = 1488.59, y = 5708.99, z = -65.48, h = 179.41, actief = false, magazijnData = nil},
    [14] = {x = 1490.38, y = 5655.42, z = -65.48, h = 179.41, actief = false, magazijnData = nil},
    [15] = {x = 1430.02, y = 5648.11, z = -65.48, h = 94.41, actief = false, magazijnData = nil},
    [16] = {x = 1428.03, y = 5705.53, z = -65.48, h = 1.91, actief = false, magazijnData = nil},
    [17] = {x = 1423.79, y = 5760.57, z = -65.48, h = 1.91, actief = false, magazijnData = nil},
    [18] = {x = 1419.43, y = 5817.20, z = -65.48, h = 1.91, actief = false, magazijnData = nil},
    [19] = {x = 1415.06, y = 5873.83, z = -65.48, h = 1.91, actief = false, magazijnData = nil},
    [20] = {x = 1410.51, y = 5932.86, z = -65.48, h = 1.91, actief = false, magazijnData = nil},
    [21] = {x = 1346.55, y = 5932.47, z = -65.48, h = 86.91, actief = false, magazijnData = nil},
    [22] = {x = 1348.39, y = 5877.30, z = -65.48, h = 179.41, actief = false, magazijnData = nil},
    [23] = {x = 1350.09, y = 5826.13, z = -65.48, h = 179.41, actief = false, magazijnData = nil},
    [24] = {x = 1352.01, y = 5768.56, z = -65.48, h = 179.41, actief = false, magazijnData = nil},
    [25] = {x = 1353.90, y = 5711.80, z = -65.48, h = 179.41, actief = false, magazijnData = nil},
    [26] = {x = 1355.68, y = 5658.23, z = -65.48, h = 179.41, actief = false, magazijnData = nil},
    [27] = {x = 1357.46, y = 5604.66, z = -65.48, h = 179.41, actief = false, magazijnData = nil},
    [28] = {x = 1359.38, y = 5547.09, z = -65.48, h = 179.41, actief = false, magazijnData = nil},
    [29] = {x = 1361.14, y = 5494.32, z = -65.48, h = 179.41, actief = false, magazijnData = nil},
    [30] = {x = 1363.03, y = 5437.55, z = -65.48, h = 179.41, actief = false, magazijnData = nil}
}

-- Groothandel rek POIS's kanker (links naar rechts)
Config.rekkenPOIS = {
    -- Begin anast lappie je weet toch
    [1] = {x = -5.00, y = 7.79, z = -3.05, h = 270.0},
    [2] = {x = -1.50, y = 7.79, z = -3.05, h = 270.0},
    [3] = {x = 2.00, y = 7.79, z = -3.05, h = 270.0},
    [4] = {x = 5.50, y = 7.79, z = -3.05, h = 270.0},
    [5] = {x = 9.00, y = 7.79, z = -3.05, h = 270.0},

    -- Midden
    [6] = {x = -5.00, y = 2.79, z = -3.05, h = 90.0},
    [7] = {x = -1.50, y = 2.79, z = -3.05, h = 90.0},
    [8] = {x = 2.00, y = 2.79, z = -3.05, h = 90.0},
    [9] = {x = 5.50, y = 2.79, z = -3.05, h = 90.0},
    [10] = {x = 9.00, y = 2.79, z = -3.05, h = 90.0},
}

-- Ophaal en verkoop locaties NPC's
Config.npcLocaties = {
    -- Legaal
    [1] = {x = 128.37, y = 341.44, z = 111.88, h = 30.13},
    [2] = {x = -20.80, y = 239.69, z = 109.55, h = 352.33},
    [3] = {x = -143.92, y = 229.73, z = 94.94, h = 1.24},
    [4] = {x = -379.27, y = 218.25, z = 83.66, h = 357.68},
    [5] = {x = -709.76, y = -129.38, z = 37.83, h = 340.29},
    [6] = {x = -666.11, y = -330.34, z = 35.20, h = 332.75},
    [7] = {x = -610.74, y = -393.17, z = 35.08, h = 26.01},
    [8] = {x = -813.06, y = -979.53, z = 14.28, h = 172.39},
    [9] = {x = -813.94, y = -1114.66, z = 11.18, h = 325.20},
    [10] = {x = -1109.62, y = -1359.02, z = 5.06, h = 270.76},
    [11] = {x = -1612.88, y = -1077.56, z = 13.02, h = 17.34},
    [12] = {x = -1793.23, y = -1199.18, z = 13.02, h = 348.23},
    [13] = {x = 1997.94, y = 3780.58, z = 32.18, h = 161.25},
    [14] = {x = -3047.96, y = 614.19, z = 7.28, h = 265.37},
    [15] = {x = -3154.60, y = 1054.26, z = 20.85, h = 301.25},
    [16] = {x = -2175.07, y = 4294.69, z = 49.05, h = 208.92},
    [17] = {x = -773.49, y = 5597.84, z = 33.61, h = 182.77},
    [18] = {x = -438.90, y = 6148.67, z = 31.48, h = 168.34},
    [19] = {x = -276.16, y = 6239.41, z = 31.49, h = 48.05},
    [20] = {x = 118.67, y = 6640.44, z = 31.87, h = 330.10},
    [21] = {x = 174.82, y = 6642.83, z = 31.57, h = 316.48},
    [22] = {x = 1723.26, y = 6417.74, z = 35.00, h = 61.36},
    [23] = {x = 2315.02, y = 4889.68, z = 41.81, h = 92.33},
    [24] = {x = 1966.85, y = 4634.35, z = 41.10, h = 37.57},
    [25] = {x = 1718.86, y = 4711.46, z = 42.28, h = 194.63},
    [26] = {x = 1657.81, y = 4839.17, z = 42.03, h = 279.33},
    [27] = {x = 1673.74, y = 4958.42, z = 42.35, h = 198.86},
    [28] = {x = 1320.59, y = 4313.49, z = 38.13, h = 40.71},
    [29] = {x = 1300.98, y = 4319.06, z = 38.18, h = 301.52},
    [30] = {x = 1300.98, y = 4319.06, z = 38.18, h = 301.52},
    [31] = {x = -1593.11, y = 5202.96, z = 4.31, h = 291.21},
    [32] = {x = 182.45, y = 2790.17, z = 45.61, h = 322.17},
    [33] = {x = 172.91, y = 2778.69, z = 46.08, h = 238.88},
    [34] = {x = 317.03, y = 2623.22, z = 44.46, h = 304.04},
    [35] = {x = 643.70, y = 2733.21, z = 42.00, h = 5.16},
    [36] = {x = 541.87, y = 2664.08, z = 42.17, h = 143.03},
    [37] = {x = 1048.33, y = 2653.42, z = 39.55, h = 186.76},
    [38] = {x = 1041.14, y = 2652.15, z = 39.55, h = 187.58},
    [39] = {x = 1194.21, y = 2721.93, z = 38.63, h = 1.09},
    [40] = {x = 1980.35, y = 3049.43, z = 50.43, h = 169.67},
    [41] = {x = 2461.42, y = 1575.61, z = 33.11, h = 313.89},
    [42] = {x = 2545.01, y = 2591.89, z = 37.96, h = 130.14},
    [43] = {x = 2476.28, y = 4087.05, z = 38.12, h = 293.70},
    [44] = {x = 2506.88, y = 4097.16, z = 38.71, h = 84.69},
    [45] = {x = 2522.19, y = 4111.28, z = 38.63, h = 335.72},
    [46] = {x = 1952.37, y = 3841.75, z = 32.18, h = 299.42},
    [47] = {x = 1407.85, y = 3619.35, z = 34.89, h = 275.78},
    [48] = {x = 1358.60, y = 3614.37, z = 34.88, h = 28.55},
}

Config.Peds = { -- GTA peds
    [1] = "a_f_m_bevhills_02",
    [2] = "a_f_m_eastsa_02",
    [3] = "s_m_m_cntrybar_01",
    [4] = "a_m_y_yoga_01",
    [5] = "a_m_y_vinewood_02",
}

-- Specialisaties / categorieen
Config.categorieen = {
    -- Legaal
    [1] = {name = "hout", label = "Hout"},
    [2] = {name = "electronica", label = "Electronica"},
    [3] = {name = "fruit", label = "Fruit"},
    [4] = {name = "groente", label = "Groente"},
    [5] = {name = "kleding", label = "Kleding"},
    [6] = {name = "vlees", label = "Vlees"},
    [7] = {name = "sanitair", label = "Sanitair"},
    [8] = {name = "speelgoed", label = "Speelgoed"},
    [9] = {name = "zonnepanelen", label = "Zonnepanelen"},
    [10] = {name = "servies", label = "Servies"},

    -- Illegaal
    [11] = {name = "autoonderdelen", label = "Auto onderdelen"},
    [12] = {name = "sieraden", label = "Sieraden"},
    [13] = {name = "sigaretten", label = "Sigaretten"},
    [14] = {name = "drank", label = "Drank"},
    [15] = {name = "edelmetalen", label = "Edelmetalen"},
}

-- Prijs per doos inkopen & verkopen
Config.doosPrijzen = {
    ["verkopen"] = { -- Dus: Verdienen a.k.a. winst
        [1] = {minimaal = 800, maximaal = 4500},
        [2] = {minimaal = 4750, maximaal = 5500},
        [3] = {minimaal = 6300, maximaal = 7500},
    },

    ["inkopen"] = { -- Dus: Betalen a.k.a. verlies
        [1] = {minimaal = 200, maximaal = 300},
        [2] = {minimaal = 300, maximaal = 500},
        [3] = {minimaal = 600, maximaal = 800},
    }
}

Config.randomNamen = {
    [1] = "Aad van de Meiden",
    [2] = "Thomas Koeman",
    [3] = "Leo ter Ham",
    [4] = "Frank Klaver",
    [5] = "Steve Miller",
    [6] = "Joost Fransen",
    [7] = "Frans Geraerts",
    [8] = "Colline Camron",
    [9] = "Steven de Boer",
    [10] = "Arnaud Davids",
    [11] = "Ramon de Groot",
    [12] = "Pieter van der Deen",
    [13] = "Nick Samson",
    [14] = "Natasha Hendriks",
    [15] = "Rens de Vries",
    [16] = "Tijn Miltenburg",
    [17] = "Carlos Verwij",
    [18] = "Ricardo Winter",
    [19] = "Danique Beckersen",
    [20] = "Pim Bjorn",
    [21] = "Dominic Fabio",
    [22] = "Evy de Jonge",
    [23] = "Joey Harms",
    [24] = "Sander Rosing",
    [25] = "Merel Kooiker",
    [26] = "Feline Lavato",
    [27] = "Matthijs Lachman",
    [28] = "Benthe Gambino",
    [29] = "Francis Ramos",
    [30] = "Sterre Gotti",
    [31] = "Finn Baguette",
    [32] = "Iris Boomstam",
    [33] = "Cor Scheendaal"
}