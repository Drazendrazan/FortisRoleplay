QBCore = nil

local wapens = {
    ["wapens"] = {
	    'WEAPON_BREAD',
	    'WEAPON_HAMMER',
	    'WEAPON_GOLFCLUB',
	    'WEAPON_CROWBAR',
	    'WEAPON_BOTTLE',
	    'WEAPON_DAGGER',
	    'WEAPON_HATCHET',
	    'WEAPON_MACHETE',
	    'WEAPON_BATTLEAXE',
	    'WEAPON_POOLCUE',
	    'WEAPON_WRENCH',
	    'WEAPON_PISTOL',
	    'WEAPON_PISTOL_MK2',
	    'WEAPON_COMBATPISTOL',
	    'WEAPON_APPISTOL',
	    'WEAPON_PISTOL50',
	    'WEAPON_REVOLVER',
	    'WEAPON_SNSPISTOL',
	    'WEAPON_HEAVYPISTOL',
	    'WEAPON_VINTAGEPISTOL',
	    'WEAPON_MICROSMG',
	    'WEAPON_ASSAULTSMG',
	    'WEAPON_MINISMG',
	    'WEAPON_MACHINEPISTOL',
	    'WEAPON_COMBATPDW',
	    'WEAPON_MARKSMANRIFLE',
	    'WEAPON_GRENADELAUNCHER',
	    'WEAPON_RPG',
	    'WEAPON_STINGER',
	    'WEAPON_MINIGUN',
	    'WEAPON_GRENADE',
	    'WEAPON_STICKYBOMB',
	    'WEAPON_SMOKEGRENADE',
	    'WEAPON_BZGAS',
	    'WEAPON_MOLOTOV',
	    'WEAPON_DIGISCANNER',
	    'WEAPON_FIREWORK',
	    'WEAPON_MUSKET',
	    'WEAPON_STUNGUN',
	    'WEAPON_HOMINGLAUNCHER',
	    'WEAPON_PROXMINE',
	    'WEAPON_FLAREGUN',
	    'WEAPON_MARKSMANPISTOL',
	    'WEAPON_RAILGUN',
	    'WEAPON_DBSHOTGUN',
	    'WEAPON_AUTOSHOTGUN',
	    'WEAPON_COMPACTLAUNCHER',
	    'WEAPON_PIPEBOMB',
        'WEAPON_BAT',
    }
}


local laatsteWapen = nil
Citizen.CreateThread(function()
    while true do
        local playerWapen = GetSelectedPedWeapon(GetPlayerPed(-1))
        local playerWapenHash = GetHashKey(playerWapen)

        for w, wapenLijst in pairs(wapens["wapens"]) do
            if playerWapen == GetHashKey(wapenLijst) and playerWapen ~= laatsteWapen then
				laatsteWapen = playerWapen
                local wapenNaam = playerWapen == GetHashKey(wapenLijst)
                TriggerServerEvent("fortis-smallresources:server:wapencheck", wapenLijst, playerWapen)
            end
        end
        Wait(2000)
    end
end)

AddEventHandler("fortis-smallresources:client:wapenGeefCheck", function()
	local playerWapen = GetSelectedPedWeapon(GetPlayerPed(-1))
    local playerWapenHash = GetHashKey(playerWapen)

    for w, wapenLijst in pairs(wapens["wapens"]) do
        if playerWapen == GetHashKey(wapenLijst) then
			laatsteWapen = playerWapen
            local wapenNaam = playerWapen == GetHashKey(wapenLijst)
            TriggerServerEvent("fortis-smallresources:server:wapencheck", wapenLijst, playerWapen)
        end
    end
end)

RegisterNetEvent('fortis-smallresources:client:leegHandWapen')
AddEventHandler('fortis-smallresources:client:leegHandWapen', function(wapenHash)
    RemoveWeaponFromPed(GetPlayerPed(-1), wapenHash)
end)