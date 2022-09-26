QBBoatshop = QBBoatshop or {}
QBDiving = QBDiving or {}

QBBoatshop.PoliceBoat = {
    x = -800.67, 
    y = -1494.54, 
    z = 1.59,
}

QBBoatshop.PoliceBoatSpawn = {
    x = -793.58, 
    y = -1501.4, 
    z = 0.12,
    h = 111.5,
}

QBBoatshop.PoliceBoat2 = {
    x = -279.41, 
    y = 6635.09, 
    z = 7.51,
}

QBBoatshop.PoliceBoatSpawn2 = {
    x = -293.10, 
    y = 6642.69, 
    z = 0.15,
    h = 65.5,
}

QBBoatshop.Docks = {
    ["cayo"] = {
        label = "Boothuis Cayo Perico",
        coords = {
            take = {
                x = 4938.30, 
                y = -5149.36, 
                z = 2.45, 
            },
            put = {
                x = 4935.10, 
                y = -5155.78, 
                z = 1.34, 
                h = 62.63,
            }
        }
    },
    ["havenindustrie"] = {
        label = "Boothuis Industrie",
        coords = {
            take = {
                x = 107.04, 
                y = -3333.54, 
                z = 5.99, 
            },
            put = {
                x = 99.11, 
                y = -3337.07, 
                z =  1.69, 
                h = 188.5,
            }
        }
    },
    ["lsymc"] = {
        label = "Boothuis Los Santos",
        coords = {
            take = {
                x = -794.66, 
                y = -1510.83, 
                z = 1.59,
            },
            put = {
                x = -793.58, 
                y = -1501.4, 
                z = 0.12,
                h = 111.5,
            }
        }
    },
    ["paletto"] = {
        label = "Boothuis Paleto ",
        coords = {
            take = {
                x = -277.46, 
                y = 6637.2, 
                z = 7.48,
            },
            put = {
                x = -289.2, 
                y = 6637.96, 
                z = 1.01,
                h = 45.5,
            }
        }
    },    
    ["millars"] = {
        label = "Boothuis Alamo",
        coords = {
            take = {
                x = 1299.24, 
                y = 4216.69, 
                z = 33.9, 
            },
            put = {
                x = 1297.82, 
                y = 4209.61, 
                z = 30.12, 
                h = 253.5,
            }
        }
    },
}

QBBoatshop.Depots = {
    [1] = {
        label = "Boten Impound",
        coords = {
            take = {
                x = -772.98, 
                y = -1430.76, 
                z = 1.59, 
            },
            put = {
                x = -729.77, 
                y = -1355.49, 
                z = 1.19, 
                h = 142.5,
            }
        }
    }
}

QBBoatshop.Locations = {
    ["berths"] = {
        [1] = {
            ["boatModel"] = "dinghy",
            ["coords"] = {
                ["boat"] = {
                    ["x"] = -727.05,
                    ["y"] = -1326.59,
                    ["z"] = 1.06,
                    ["h"] = 229.5
                },
                ["buy"] = {
                    ["x"] = -723.3,
                    ["y"] = -1323.61,
                    ["z"] = 1.59,
                }
            },
            ["inUse"] = false
        },
        [2] = {
            ["boatModel"] = "speeder",
            ["coords"] = {
                ["boat"] = {
                    ["x"] = -732.84, 
                    ["y"] = -1333.5, 
                    ["z"] = 1.59, 
                    ["h"] = 229.5
                },
                ["buy"] = {
                    ["x"] = -729.19, 
                    ["y"] = -1330.58, 
                    ["z"] = 1.67, 
                },
            },
            ["inUse"] = false
        },
        [3] = {
            ["boatModel"] = "jetski1",
            ["coords"] = {
                ["boat"] = {
                    ["x"] = -749.59, 
                    ["y"] = -1354.88, 
                    ["z"] = 0.79, 
                    ["h"] = 229.5
                },
                ["buy"] = {
                    ["x"] = -746.6, 
                    ["y"] = -1351.36, 
                    ["z"] = 1.59, 
                },
            },
            ["inUse"] = false
        },
        [4] = {
            ["boatModel"] = "rboat",
            ["coords"] = {
                ["boat"] = {
                    ["x"] = -755.39, 
                    ["y"] = -1361.76, 
                    ["z"] = 0.79, 
                    ["h"] = 229.5
                },
                ["buy"] = {
                    ["x"] = -752.49,
                    ["y"] = -1358.28,
                    ["z"] = 1.59,
                },
            },
            ["inUse"] = false
        },
        [5] = {
            ["boatModel"] = "longfin",
            ["coords"] = {
                ["boat"] = {
                    ["x"] = -737.84, 
                    ["y"] = -1340.83, 
                    ["z"] = 0.99, 
                    ["h"] = 229.5
                },
                ["buy"] = {
                    ["x"] = -734.98, 
                    ["y"] = -1337.42, 
                    ["z"] = 1.67, 
                },
            },
            ["inUse"] = false
        },
        -- [6] = {
        --     ["boatModel"] = "yacht2",
        --     ["coords"] = {
        --         ["boat"] = {
        --             ["x"] = -743.53, 
        --             ["y"] = -1347.7, 
        --             ["z"] = 0.89, 
        --             ["h"] = 229.5
        --         },
        --         ["buy"] = {
        --             ["x"] = -740.62, 
        --             ["y"] = -1344.28, 
        --             ["z"] = 1.67, 
        --         },
        --     },
        --     ["inUse"] = false
        -- },
        --kan aan toegevoed worden tot [12]
    },
}

QBBoatshop.ShopBoats = {
    ["dinghy"] = {
        ["model"] = "dinghy",
        ["label"] = "Dinghy",
        ["price"] = 55000
    },
    ["speeder"] = {
        ["model"] = "speeder",
        ["label"] = "Speeder",
        ["price"] = 150000
    },
    -- ["yacht2"] = {
    --     ["model"] = "yacht2",
    --     ["label"] = "Sea Ray 510 Fly",
    --     ["price"] = 420000
    -- },
    -- ["yacht1"] = {
    --     ["model"] = "yacht1",
    --     ["label"] = "Sea Ray 650",
    --     ["price"] = 350000
    -- },
    ["jetski1"] = {
        ["model"] = "jetski1",
        ["label"] = "Yamaha FX",
        ["price"] = 45000
    },
    ["rboat"] = {
        ["model"] = "rboat",
        ["label"] = "Rapid Boat",
        ["price"] = 250000
    },
    ["longfin"] = {
        ["model"] = "longfin",
        ["label"] = "Long Fin",
        ["price"] = 300000
    },
}

QBBoatshop.SpawnVehicle = {
    x = -719.40, 
    y = -1319.06, 
    z = 2.02, 
    h = 231.04,
}