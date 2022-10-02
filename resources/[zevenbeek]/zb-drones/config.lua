-- Speciaal gemaakt voor FortisRoleplay, gemaakt door m3r en Finn

Config = {}

Config.Droneshops = {
    ['enabled'] = false, -- Zet dit op false als het je dit uit wilt schakelen
    ['text'] = '⬅️➡️',
    ['text_information'] = '~g~E~w~ - Informatie',
    ['purchased-drone'] = '~g~Gefelicteerd met je aankoop!',
    ['text_type'] = 'Prijs: ~g~',
    ['text_distance'] = 'Maximale bereik in meters: ~g~',
    ['text_purchase'] = '~g~7~w~ - Kopen',
    ['text_return'] = '~g~E~w~ - Ga terug',
    ['spawnname'] = GetHashKey('ch_prop_arcade_drone_01a'),
    ['Shops_blip'] = {
        ['title'] = 'Drone Shop',
        ['coords'] = {x = -659.83, y = -937.61, z = 21.83},
    },
    ['Shops'] = {
        [1] = {
            coords = {x = -659.83, y = -937.61, z = 21.83},
            drone_type = 1,
        },
        [2] = {
            coords = {x = -661.64,  y = -934.24, z = 21.82},
            drone_type = 1,
        },
        [3] = {
            coords = {x = -665.34, y = -938.5, z = 22.07},
            drone_type = 1,
        }
    }
}

Config.ProgressbarsText = {
    ['placingDrone'] = 'Drone aan het plaatsen...',
    ['pickupDrone'] = 'Drone oppakken...'
}

Config.PickupText = '~g~E~w~ - Pak Drone op'
Config.Instructions = {
    ['timestamp'] = 30000,
    ['text'] = 'Gebruik W, A, S, D om te bewegen.<br>Pijltjestoetsen om te draaien.<br>Gebruik SHIFT en SPATIE om naar boven en beneden te gaan.<br>Om de camera te resetten druk je op R.<br>Druk op X om handmatig uit de drone te gaan.'
}

Config.ErrorMessages = {
    ['timestamp'] = 3500,
    ['alreadyHasDrone'] = 'Je hebt nog ergens een drone liggen, pak deze eerst op!',
    ['notEnoughMoney'] = 'Je hebt niet genoeg geld!'
}

Config.DroneMessages = {
    ['timestamp'] = 5000,
    ['reachedMaxDistance'] = 'De verbinding is weggevallen, zoek de drone opnieuw op!',
    ['pressedX'] = 'Je hebt de verbinding handmatig verbroken!'
}

Config.Drones = {
    [1] = {
        name = 'Arcade Drone 2',
        spawnname = GetHashKey('ch_prop_arcade_drone_01a'),
        maxDistance = 100.0,
        price = 15000,
    },
    [2] = {
        name = 'Casino Drone 1a',
        spawnname = GetHashKey('ch_prop_casino_drone_01a'),
        maxDistance = 175.0,
        price = 25000,
    },
    [3] = {
        name = 'Arcade Drone 2',
        spawnname = GetHashKey('ch_prop_arcade_drone_01b'),
        maxDistance = 250.0,
        price = 35000,
    },
}