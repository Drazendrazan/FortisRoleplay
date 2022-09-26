Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
}

Config = {}

Config.MenuItems = {
    [1] = {
        id = 'citizen',
        title = 'Burger Interactie',
        icon = '#citizen',
        items = {
            {
                id    = 'givenum',
                title = 'Geef Contact Gegevens',
                icon = '#nummer',
                type = 'client',
                event = 'qb-phone_new:client:GiveContactDetails',
                shouldClose = true,
            },
            {
                id    = 'getintrunk',
                title = 'Stap in kofferbak',
                icon = '#vehicle',
                type = 'client',
                event = 'qb-trunk:client:GetIn',
                shouldClose = true,
            },
            {
                id    = 'cornerselling',
                title = 'Corner Selling',
                icon = '#walk',
                type = 'client',
                event = 'qb-drugs:client:cornerselling',
                shouldClose = true,
            },
            {
                id = 'interactions',
                title = 'Interactie',
                icon = '#illegal',
                items = {
                    {
                        id    = 'handcuff',
                        title = 'Boeien',
                        icon = '#masker',
                        type = 'client',
                        event = 'police:client:CuffPlayerSoft',
                        shouldClose = true,
                    },
                    {
                        id    = 'playerinvehicle',
                        title = 'Zet in voertuig',
                        icon = '#vehicle',
                        type = 'client',
                        event = 'police:client:PutPlayerInVehicle',
                        shouldClose = true,
                    },
                    {
                        id    = 'playeroutvehicle',
                        title = 'Haal uit voertuig',
                        icon = '#vehicle',
                        type = 'client',
                        event = 'police:client:SetPlayerOutVehicle',
                        shouldClose = true,
                    },
                    {
                        id    = 'stealplayer',
                        title = 'Beroven',
                        icon = '#illegal',
                        type = 'client',
                        event = 'police:client:RobPlayer',
                        shouldClose = true,
                    },
                    {
                        id    = 'escort',
                        title = 'Kidnappen',
                        icon = '#illegal',
                        type = 'client',
                        event = 'police:client:KidnapPlayer',
                        shouldClose = true,
                    },
                    {
                        id    = 'escort2',
                        title = 'Escorteren',
                        icon = '#citizen',
                        type = 'client',
                        event = 'police:client:EscortPlayer',
                        shouldClose = true,
                    },
                    {
                        id    = 'escort554',
                        title = 'Neem hostage',
                        icon = '#citizen',
                        type = 'client',
                        event = 'A5:Client:TakeHostage',
                        shouldClose = true,
                    },
                }
            },
        }
    },
    [2] = {
        id = 'general',
        title = 'Algemeen',
        icon = '#general',
        items = {
            {
                id = 'house',
                title = 'Huis Interactie',
                icon = '#house',
                items = {
                    {
                        id    = 'givehousekey',
                        title = 'Geef Huis Sleutels',
                        icon = '#vehiclekey',
                        type = 'client',
                        event = 'qb-houses:client:giveHouseKey',
                        shouldClose = true,
                        items = {},
                    },
                    {
                        id    = 'removehousekey',
                        title = 'Verwijder Huis Sleutel',
                        icon = '#vehiclekey',
                        type = 'client',
                        event = 'qb-houses:client:removeHouseKey',
                        shouldClose = true,
                        items = {},
                    },
                    {
                        id    = 'togglelock',
                        title = 'Toggle Deurslot',
                        icon = '#vehiclekey',
                        type = 'client',
                        event = 'qb-houses:client:toggleDoorlock',
                        shouldClose = true,
                    },
                    {
                        id    = 'decoratehouse',
                        title = 'Decoreer Huis',
                        icon = '#house',
                        type = 'client',
                        event = 'qb-houses:client:decorate',
                        shouldClose = true,
                    },            
                    {
                        id = 'houseLocations',
                        title = 'Interactie Locaties',
                        icon = '#house',
                        items = {
                            {
                                id    = 'setstash',
                                title = 'Stash Instellen',
                                icon = '#vehiclekey',
                                type = 'client',
                                event = 'qb-houses:client:setLocation',
                                shouldClose = true,
                            },
                            {
                                id    = 'setoutift',
                                title = 'Kledingkast Instellen',
                                icon = '#shirt',
                                type = 'client',
                                event = 'qb-houses:client:setLocation',
                                shouldClose = true,
                            },
                        }
                    },
                }
            },
            {    id = 'kleding',
                title = 'Kleding aan/uit',
                icon = '#shirt',
                items = {
                    {
                        id    = 'handschoenen',
                        title = 'Handschoenen',
                        icon = '#handschoenen',
                        type = 'client',
                        event = 'kleding:handschoenen',
                        shouldClose = true,
                        items = {},
                    },
                    {
                        id    = 'schoenen',
                        title = 'Schoenen',
                        icon = '#sokken',
                        type = 'client',
                        event = 'kleding:schoenen',
                        shouldClose = true,
                        items = {},
                    },
                    {
                        id    = 'masker',
                        title = 'Masker',
                        icon = '#masker',
                        type = 'client',
                        event = 'kleding:masker',
                        shouldClose = true,
                        items = {},
                    },
                    {
                        id    = 'shirt',
                        title = 'Shirt',
                        icon = '#shirt',
                        type = 'client',
                        event = 'kleding:jas',
                        shouldClose = true,
                        items = {},
                    },
                    {
                        id    = 'broek',
                        title = 'Broek',
                        icon = '#broek',
                        type = 'client',
                        event = 'kleding:broek',
                        shouldClose = true,
                        items = {},
                    },
                    {
                        id    = 'hoed',
                        title = 'Hoed',
                        icon = '#hoed',
                        type = 'client',
                        event = 'kleding:hoed',
                        shouldClose = true,
                        items = {},
                    },
                    {
                        id    = 'bril',
                        title = 'Bril',
                        icon = '#bril',
                        type = 'client',
                        event = 'kleding:bril',
                        shouldClose = true,
                        items = {},
                    },
                }
            }
        }
    },
    [3] = {
        id = 'vehicle',
        title = 'Voertuig Interactie',
        icon = '#vehicle',
        items = {
            {
                id    = 'vehicledoors',
                title = 'Voertuig Deuren',
                icon = '#vehicledoors',
                items = {
                    {
                        id    = 'door0',
                        title = 'Bestuurdersdeur',
                        icon = '#leftdoor',
                        type = 'client',
                        event = 'qb-radialmenu:client:openDoor',
                        shouldClose = false,
                    },
                    {
                        id    = 'door4',
                        title = 'Motorkap',
                        icon = '#vehicle',
                        type = 'client',
                        event = 'qb-radialmenu:client:openDoor',
                        shouldClose = false,
                    },
                    {
                        id    = 'door1',
                        title = 'Passagiers Deur',
                        icon = '#rightdoor',
                        type = 'client',
                        event = 'qb-radialmenu:client:openDoor',
                        shouldClose = false,
                    },
                    {
                        id    = 'door3',
                        title = 'Rechter Achterdeur',
                        icon = '#rightdoor',
                        type = 'client',
                        event = 'qb-radialmenu:client:openDoor',
                        shouldClose = false,
                    },
                    {
                        id    = 'door5',
                        title = 'Kofferbak',
                        icon = '#vehicle',
                        type = 'client',
                        event = 'qb-radialmenu:client:openDoor',
                        shouldClose = false,
                    },
                    {
                        id    = 'door2',
                        title = 'Linker Achterdeur',
                        icon = '#leftdoor',
                        type = 'client',
                        event = 'qb-radialmenu:client:openDoor',
                        shouldClose = false,
                    },
                }
            },
            {
                id    = 'vehicleextras',
                title = 'Vehicle Extras',
                icon = '#plus',
                items = {
                    {
                        id    = 'extra1',
                        title = 'Extra 1',
                        icon = '#plus',
                        type = 'client',
                        event = 'qb-radialmenu:client:setExtra',
                        shouldClose = false,
                    },
                    {
                        id    = 'extra2',
                        title = 'Extra 2',
                        icon = '#plus',
                        type = 'client',
                        event = 'qb-radialmenu:client:setExtra',
                        shouldClose = false,
                    },
                    {
                        id    = 'extra3',
                        title = 'Extra 3',
                        icon = '#plus',
                        type = 'client',
                        event = 'qb-radialmenu:client:setExtra',
                        shouldClose = false,
                    },
                    {
                        id    = 'extra4',
                        title = 'Extra 4',
                        icon = '#plus',
                        type = 'client',
                        event = 'qb-radialmenu:client:setExtra',
                        shouldClose = false,
                    },
                    {
                        id    = 'extra5',
                        title = 'Extra 5',
                        icon = '#plus',
                        type = 'client',
                        event = 'qb-radialmenu:client:setExtra',
                        shouldClose = false,
                    },
                    {
                        id    = 'extra6',
                        title = 'Extra 6',
                        icon = '#plus',
                        type = 'client',
                        event = 'qb-radialmenu:client:setExtra',
                        shouldClose = false,
                    },
                    {
                        id    = 'extra7',
                        title = 'Extra 7',
                        icon = '#plus',
                        type = 'client',
                        event = 'qb-radialmenu:client:setExtra',
                        shouldClose = false,
                    },
                    {
                        id    = 'extra8',
                        title = 'Extra 8',
                        icon = '#plus',
                        type = 'client',
                        event = 'qb-radialmenu:client:setExtra',
                        shouldClose = false,
                    },
                    {
                        id    = 'extra9',
                        title = 'Extra 9',
                        icon = '#plus',
                        type = 'client',
                        event = 'qb-radialmenu:client:setExtra',
                        shouldClose = false,
                    },                                                                                                                  
                }
            },
            {
                id    = 'vehicleseats',
                title = 'Voertuig Stoelen',
                icon = '#vehicledoors',
                items = {
                    {
                        id    = 'door0',
                        title = 'Driver',
                        icon = '#plus',
                        type = 'client',
                        event = 'qb-radialmenu:client:ChangeSeat',
                        shouldClose = false,
                    },
                }
            },
            {
                id = 'vehicleengine',
                title = 'Voertuig Motor',
                icon = '#vehicle',
                type = 'client',
                event = 'qb-radialmenu:client:VehicleEngine', 
                shouldClose = true,
            },
            {
                id = 'vehicleengine',
                title = 'Voertuig Neon',
                icon = '#vehicle',
                type = 'client',
                event = 'qb-radialmenu:client:switchNeon', 
                shouldClose = true,
            },
            {
                id    = 'vehicleraam',
                title = 'Voertuig Ramen',
                icon = '#vehicledoors',
                items = {
                    {
                        id    = 'door0',
                        title = 'Bestuurders raam',
                        icon = '#plus',
                        type = 'client',
                        event = 'qb-radialmenu:client:raampjeszakuuuhhhhbesuurder',
                        shouldClose = false,
                    },
                    {
                        id    = 'door0',
                        title = 'Bijrijders raam',
                        icon = '#plus',
                        type = 'client',
                        event = 'qb-radialmenu:client:raampjeszakuuuhhhhrechts',
                        shouldClose = false,
                    },
                    {
                        id    = 'door0',
                        title = 'Achter raam rechts',
                        icon = '#plus',
                        type = 'client',
                        event = 'qb-radialmenu:client:raampjeszakuuuhhhhrechtsachter',
                        shouldClose = false,
                    },
                    {
                        id    = 'door0',
                        title = 'Achter raam links',
                        icon = '#plus',
                        type = 'client',
                        event = 'qb-radialmenu:client:raampjeszakuuuhhhhlinksachter',
                        shouldClose = false,
                    },
                    {
                        id    = 'door0',
                        title = 'Alle ramen',
                        icon = '#plus',
                        type = 'client',
                        event = 'qb-radialmenu:client:raampjeszakuuuhhhh',
                        shouldClose = false,
                    },
                },
            },
        },
    },
    [4] = {
        id = 'jobinteractions',
        title = 'Werk Interactie',
        icon = '#walk',
        items = {},
    },
}

Config.JobInteractions = {
    ["ambulance"] = {
        {
            id    = 'statuscheck',
            title = 'Onderzoek Persoon',
            icon = '#banknr',
            type = 'client',
            event = 'hospital:client:CheckStatus',
            shouldClose = true,
        },
        {
            id    = 'treatwounds',
            title = 'Reviven',
            icon = '#plus',
            type = 'client',
            event = 'hospital:client:TreatWounds',
            shouldClose = true,
        },
        {
            id    = 'emergencybutton2',
            title = 'Noodknop',
            icon = '#illegal',
            type = 'client',
            event = 'police:client:SendPoliceEmergencyAlert',
            shouldClose = true,
        },
        {
            id    = 'escort',
            title = 'Escorteren',
            icon = '#citizen',
            type = 'client',
            event = 'police:client:EscortPlayer',
            shouldClose = true,
        },
        {
            id = 'brancardoptions',
            title = 'Brancard',
            icon = '#vehicle',
            items = {
                {
                    id    = 'spawnbrancard',
                    title = 'Spawn Brancard',
                    icon = '#general',
                    type = 'client',
                    event = 'hospital:client:TakeBrancard',
                    shouldClose = false,
                },
                {
                    id    = 'despawnbrancard',
                    title = 'Verwijder Brancard',
                    icon = '#general',
                    type = 'client',
                    event = 'hospital:client:RemoveBrancard',
                    shouldClose = false,
                },
            },
        },
        {
            id    = 'togglenpc',
            title = 'Missie Starten',
            icon = '#citizen',
            type = 'client',
            event = 'ambu:client:ToggleNpc',
            shouldClose = true,
        },
        { 
            id    = 'spawnobject',
            title = 'Objecten menu',
            icon = '#handschoenen',
            type = 'client',
            event = 'police:client:objectMenu',
            shouldClose = true,
        },
        {
            id    = 'spawnobject',
            title = 'Doodsoorzaak',
            icon = '#handschoenen',
            type = 'client',
            event = 'hospital:client:doodsoorzaak',
            shouldClose = true,
        },
    },
	["mechanic"] = {             
        {
            id    = 'repair',
            title = 'Repareren',
            icon = '#general',
            type = 'client',
            event = 'iens:repairRadialANWB',
            shouldClose = true,
        },
		{
            id    = 'impound',
            title = 'Voertuig in beslag nemen',
            icon = '#general',
            type = 'client',
            event = 'fortis-vehicletuning:client:impoundveh',
            shouldClose = true,
        },
        {
            id    = 'togglenpc',
            title = 'Missie Starten',
            icon = '#general',
            type = 'client',
            event = 'anwb:client:ToggleNpc',
            shouldClose = true,
        },
        {
            id    = 'towvehicle',
            title = 'Sleep Voertuig',
            icon = '#vehicle',
            type = 'client',
            event = 'qb-tow:client:TowVehicle',
            shouldClose = true,
        },
        {
            id    = 'open',
            title = 'Voertuig openen',
            icon = '#vehicle',
            type = 'client',
            event = 'police:client:autoOpenen',
            shouldClose = true,
        },
        {
            id    = 'spawnobject',
            title = 'Objecten menu',
            icon = '#handschoenen',
            type = 'client',
            event = 'police:client:objectMenu',
            shouldClose = true,
        },	
    },
    ["taxi"] = {
        -- {
        --     id    = 'togglemeter',
        --     title = 'Bekijk/Hide Meter',
        --     icon = '#illegal',
        --     type = 'client',
        --     event = 'qb-taxi:client:toggleMeter',
        --     shouldClose = false,
        -- },
        -- {
        --     id    = 'togglemouse',
        --     title = 'Start/Stop Meter',
        --     icon = '#banknr',
        --     type = 'client',
        --     event = 'qb-taxi:client:enableMeter',
        --     shouldClose = true,
        -- },
        {
            id    = 'npc_mission',
            title = 'Missie Starten',
            icon = '#citizen',
            type = 'client',
            event = 'qb-taxi:client:DoTaxiNpc',
            shouldClose = true,
        },
    },
    ["police"] = {
        {
            id    = 'emergencybutton',
            title = 'Noodknop',
            icon = '#illegal',
            type = 'client',
            event = 'police:client:SendPoliceEmergencyAlert',
            shouldClose = true,
        },
        {
            id    = 'searchplayer',
            title = 'Fouilleer',
            icon = '#rijbewijs',
            type = 'client',
            event = 'police:client:SearchPlayer',
            shouldClose = true,
        },
        -- {
        --     id    = 'checkvehstatus',
        --     title = 'Bekijk Tune Status',
        --     icon = '#vehiclekey',
        --     type = 'client',
        --     event = 'qb-tunerchip:server:TuneStatus',
        --     shouldClose = true,
        -- },
        -- {
        --     id    = 'resethouse',
        --     title = 'Reset Huisslot',
        --     icon = '#vehiclekey',
        --     type = 'client',
        --     event = 'qb-houses:client:ResetHouse',
        --     shouldClose = true,
        -- },
        {
            id    = 'spawnobject',
            title = 'Objecten menu',
            icon = '#handschoenen',
            type = 'client',
            event = 'police:client:objectMenu',
            shouldClose = true,
        },
        -- {
        --     id    = 'takedriverlicense',
        --     title = 'Rijbewijs Invorderen',
        --     icon = '#vehicle',
        --     type = 'client',
        --     event = 'police:client:SeizeDriverLicense',
        --     shouldClose = true,
        -- },
        {
            id    = 'treatwounds',
            title = 'Reviven',
            icon = '#plus',
            type = 'client',
            event = 'hospital:client:RevivePlayer',
            shouldClose = true,
        },
        {
            id    = 'checkstatus',
            title = 'Onderzoek Persoon',
            icon = '#banknr',
            type = 'client',
            event = 'police:client:CheckStatus',
            shouldClose = true,
        },
        {
            id    = 'escort',
            title = 'Escorteren',
            icon = '#citizen',
            type = 'client',
            event = 'police:client:EscortPlayer',
            shouldClose = true,
        },
        {
            id    = 'open',
            title = 'Voertuig openen',
            icon = '#vehicle',
            type = 'client',
            event = 'police:client:autoOpenen',
            shouldClose = true,
        },
    },
}

Config.TrunkClasses = {
    [0]  = { allowed = true, x = 0.0, y = -1.5, z = 0.0 }, --Coupes  
    [1]  = { allowed = true, x = 0.0, y = -2.0, z = 0.0 }, --Sedans  
    [2]  = { allowed = true, x = 0.0, y = -1.0, z = 0.25 }, --SUVs  
    [3]  = { allowed = true, x = 0.0, y = -1.5, z = 0.0 }, --Coupes  
    [4]  = { allowed = true, x = 0.0, y = -2.0, z = 0.0 }, --Muscle  
    [5]  = { allowed = true, x = 0.0, y = -2.0, z = 0.0 }, --Sports Classics  
    [6]  = { allowed = true, x = 0.0, y = -2.0, z = 0.0 }, --Sports  
    [7]  = { allowed = true, x = 0.0, y = -2.0, z = 0.0 }, --Super  
    [8]  = { allowed = false, x = 0.0, y = -1.0, z = 0.25 }, --Motorcycles  
    [9]  = { allowed = true, x = 0.0, y = -1.0, z = 0.25 }, --Off-road  
    [10] = { allowed = true, x = 0.0, y = -1.0, z = 0.25 }, --Industrial  
    [11] = { allowed = true, x = 0.0, y = -1.0, z = 0.25 }, --Utility  
    [12] = { allowed = true, x = 0.0, y = -1.0, z = 0.25 }, --Vans  
    [13] = { allowed = true, x = 0.0, y = -1.0, z = 0.25 }, --Cycles  
    [14] = { allowed = true, x = 0.0, y = -1.0, z = 0.25 }, --Boats  
    [15] = { allowed = true, x = 0.0, y = -1.0, z = 0.25 }, --Helicopters  
    [16] = { allowed = true, x = 0.0, y = -1.0, z = 0.25 }, --Planes  
    [17] = { allowed = true, x = 0.0, y = -1.0, z = 0.25 }, --Service  
    [18] = { allowed = true, x = 0.0, y = -1.0, z = 0.25 }, --Emergency  
    [19] = { allowed = true, x = 0.0, y = -1.0, z = 0.25 }, --Military  
    [20] = { allowed = true, x = 0.0, y = -1.0, z = 0.25 }, --Commercial  
    [21] = { allowed = true, x = 0.0, y = -1.0, z = 0.25 }, --Trains  
}

Config.BrancardClasses = {
    [0]  = { allowed = false, x = 0.0, y = -1.5, z = 0.0 }, --Coupes  
    [1]  = { allowed = false, x = 0.0, y = -2.0, z = 0.0 }, --Sedans  
    [2]  = { allowed = false, x = 0.0, y = -1.0, z = 0.25 }, --SUVs  
    [3]  = { allowed = false, x = 0.0, y = -1.5, z = 0.0 }, --Coupes  
    [4]  = { allowed = false, x = 0.0, y = -2.0, z = 0.0 }, --Muscle  
    [5]  = { allowed = false, x = 0.0, y = -2.0, z = 0.0 }, --Sports Classics  
    [6]  = { allowed = false, x = 0.0, y = -2.0, z = 0.0 }, --Sports  
    [7]  = { allowed = false, x = 0.0, y = -2.0, z = 0.0 }, --Super  
    [8]  = { allowed = false, x = 0.0, y = -1.0, z = 0.25 }, --Motorcycles  
    [9]  = { allowed = false, x = 0.0, y = -1.0, z = 0.25 }, --Off-road  
    [10] = { allowed = false, x = 0.0, y = -1.0, z = 0.25 }, --Industrial  
    [11] = { allowed = false, x = 0.0, y = -1.0, z = 0.25 }, --Utility  
    [12] = { allowed = false, x = 0.0, y = -1.0, z = 0.25 }, --Vans  
    [13] = { allowed = false, x = 0.0, y = -1.0, z = 0.25 }, --Cycles  
    [14] = { allowed = false, x = 0.0, y = -1.0, z = 0.25 }, --Boats  
    [15] = { allowed = false, x = 0.0, y = -1.0, z = 0.25 }, --Helicopters  
    [16] = { allowed = false, x = 0.0, y = -1.0, z = 0.25 }, --Planes  
    [17] = { allowed = false, x = 0.0, y = -1.0, z = 0.25 }, --Service  
    [18] = { allowed = true, x = -0.15, y = -1.6, z = -0.60 }, --Emergency  
    [19] = { allowed = false, x = 0.0, y = -1.0, z = 0.25 }, --Military  
    [20] = { allowed = false, x = 0.0, y = -1.0, z = 0.25 }, --Commercial  
    [21] = { allowed = false, x = 0.0, y = -1.0, z = 0.25 }, --Trains  
}