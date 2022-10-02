function DespawnInterior(objects, cb)
    Citizen.CreateThread(function()
        for k, v in pairs(objects) do
            if DoesEntityExist(v) then
                DeleteEntity(v)
            end
        end

        cb()
    end)
end

function TeleportToInterior(x, y, z, h)
    Citizen.CreateThread(function()
        SetEntityCoords(PlayerPedId(), x, y, z, 0, 0, 0, false)
        SetEntityHeading(PlayerPedId(), h)

        Citizen.Wait(100)

        DoScreenFadeIn(1000)
    end)
end

function getRotation(input)
    return 360 / (10 * input)
end

function CreateApartmentShell(spawn)
	local objects = {}

    local POIOffsets = {}
	POIOffsets.exit = json.decode('{"z":1.2,"y":-6.2,"x":4.7,"h":358.633972168}')
	DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Citizen.Wait(10)
    end
	RequestModel(`appartment`)
	while not HasModelLoaded(`appartment`) do
	    Citizen.Wait(1000)
	end
	local house = CreateObject(`appartment`, spawn.x, spawn.y, spawn.z, false, false, false)
    FreezeEntityPosition(house, true)
	table.insert(objects, house)

	TeleportToInterior(spawn.x + 4.7, spawn.y - 6.2, spawn.z + 2.0, POIOffsets.exit.h)

    return { objects, POIOffsets }
end

function CreateCaravanShell(spawn)
	local objects = {}

    local POIOffsets = {}
	POIOffsets.exit = json.decode('{"z":2.3,"y":-2.1,"x":-1.4,"h":358.633972168}')
	DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Citizen.Wait(10)
    end
	RequestModel(`caravan_shell`)
	while not HasModelLoaded(`caravan_shell`) do
	    Citizen.Wait(1000)
	end
	local house = CreateObject(`caravan_shell`, spawn.x, spawn.y, spawn.z, false, false, false)
    FreezeEntityPosition(house, true)
	table.insert(objects, house)

	TeleportToInterior(spawn.x - 1.3, spawn.y + POIOffsets.exit.y + 0.2, spawn.z + POIOffsets.exit.z, POIOffsets.exit.h)

    return { objects, POIOffsets }
end

function CreateFranklinShell(spawn)
	local objects = {}

    local POIOffsets = {}
	POIOffsets.exit = json.decode('{"z":6.7,"y":7.8,"x":10.8,"h":125.5}')
	DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Citizen.Wait(10)
    end
	RequestModel(`frankelientje`)
	while not HasModelLoaded(`frankelientje`) do
	    Citizen.Wait(1000)
	end
	local house = CreateObject(`frankelientje`, spawn.x, spawn.y, spawn.z, false, false, false)
    FreezeEntityPosition(house, true)
	table.insert(objects, house)

	TeleportToInterior(spawn.x + POIOffsets.exit.x, spawn.y + POIOffsets.exit.y, spawn.z + POIOffsets.exit.z, POIOffsets.exit.h)

    return { objects, POIOffsets }
end

function CreateFranklinAuntShell(spawn)
	local objects = {}

    local POIOffsets = {}
	POIOffsets.exit = json.decode('{"z":2.7,"y":-5.7,"x":-0.4,"h":358.633972168}')
	DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Citizen.Wait(10)
    end
	RequestModel(`tante_shell`)
	while not HasModelLoaded(`tante_shell`) do
	    Citizen.Wait(1000)
	end
	local house = CreateObject(`tante_shell`, spawn.x, spawn.y, spawn.z, false, false, false)
    FreezeEntityPosition(house, true)
	table.insert(objects, house)

	TeleportToInterior(spawn.x + POIOffsets.exit.x, spawn.y + POIOffsets.exit.y, spawn.z + POIOffsets.exit.z, POIOffsets.exit.h)

    return { objects, POIOffsets }
end

function CreateMethlabShell(spawn)
	local objects = {}

    local POIOffsets = {}
	POIOffsets.exit = json.decode('{"z":2.7,"y":-5.7,"x":-0.4,"h":358.633972168}')
	DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Citizen.Wait(10)
    end
	RequestModel(`methlab_shell`)
	while not HasModelLoaded(`methlab_shell`) do
	    Citizen.Wait(1000)
	end
	local house = CreateObject(`methlab_shell`, spawn.x, spawn.y, spawn.z, false, false, false)
    FreezeEntityPosition(house, true)
	table.insert(objects, house)

	TeleportToInterior(spawn.x + POIOffsets.exit.x, spawn.y + POIOffsets.exit.y, spawn.z + POIOffsets.exit.z, POIOffsets.exit.h)

    return { objects, POIOffsets }
end

function CreateClassicHouse(spawn)
	local objects = {}

    local POIOffsets = {}
	POIOffsets.exit = json.decode('{"z":6.0,"y":-2.13,"x":4.65,"h":95.633972168}')
	DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Citizen.Wait(10)
    end
	RequestModel(`classichouse_shell`)
	while not HasModelLoaded(`classichouse_shell`) do
	    Citizen.Wait(1000)
	end
	local house = CreateObject(`classichouse_shell`, spawn.x, spawn.y, spawn.z, false, false, false)
    FreezeEntityPosition(house, true)
	table.insert(objects, house)

	TeleportToInterior(spawn.x + POIOffsets.exit.x, spawn.y + POIOffsets.exit.y, spawn.z + POIOffsets.exit.z, POIOffsets.exit.h)

    return { objects, POIOffsets }
end

function CreateClassicHouse2(spawn)
	local objects = {}

    local POIOffsets = {}
	POIOffsets.exit = json.decode('{"z":6.0,"y":-2.13,"x":4.65,"h":95.633972168}')
	DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Citizen.Wait(10)
    end
	RequestModel(`classichouse2_shell`)
	while not HasModelLoaded(`classichouse2_shell`) do
	    Citizen.Wait(1000)
	end
	local house = CreateObject(`classichouse2_shell`, spawn.x, spawn.y, spawn.z, false, false, false)
    FreezeEntityPosition(house, true)
	table.insert(objects, house)

	TeleportToInterior(spawn.x + POIOffsets.exit.x, spawn.y + POIOffsets.exit.y, spawn.z + POIOffsets.exit.z, POIOffsets.exit.h)

    return { objects, POIOffsets }
end

function CreateClassicHouse3(spawn)
	local objects = {}

    local POIOffsets = {}
	POIOffsets.exit = json.decode('{"z":6.0,"y":-2.13,"x":4.65,"h":95.633972168}')
	DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Citizen.Wait(10)
    end
	RequestModel(`classichouse3_shell`)
	while not HasModelLoaded(`classichouse3_shell`) do
	    Citizen.Wait(1000)
	end
	local house = CreateObject(`classichouse3_shell`, spawn.x, spawn.y, spawn.z, false, false, false)
    FreezeEntityPosition(house, true)
	table.insert(objects, house)

	TeleportToInterior(spawn.x + POIOffsets.exit.x, spawn.y + POIOffsets.exit.y, spawn.z + POIOffsets.exit.z, POIOffsets.exit.h)

    return { objects, POIOffsets }
end

function CreateHighEnd(spawn)
	local objects = {}

    local POIOffsets = {}
	POIOffsets.exit = json.decode('{"z":7.20751,"y":-0.4053,"x":-22.185,"h":265.633972168}')
	DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Citizen.Wait(10)
    end
	RequestModel(`shell_highend`)
	while not HasModelLoaded(`shell_highend`) do
	    Citizen.Wait(1000)
	end
	local house = CreateObject(`shell_highend`, spawn.x, spawn.y, spawn.z, false, false, false)
    FreezeEntityPosition(house, true)
	table.insert(objects, house)

	TeleportToInterior(spawn.x + POIOffsets.exit.x, spawn.y + POIOffsets.exit.y, spawn.z + POIOffsets.exit.z, POIOffsets.exit.h)

    return { objects, POIOffsets }
end

function CreateHighEndV2(spawn)
	local objects = {}

    local POIOffsets = {}
	POIOffsets.exit = json.decode('{"z":6.60,"y":0.837,"x":-10.326,"h":95.633972168}')
	DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Citizen.Wait(10)
    end
	RequestModel(`shell_highendv2`)
	while not HasModelLoaded(`shell_highendv2`) do
	    Citizen.Wait(1000)
	end
	local house = CreateObject(`shell_highendv2`, spawn.x, spawn.y, spawn.z, false, false, false)
    FreezeEntityPosition(house, true)
	table.insert(objects, house)

	TeleportToInterior(spawn.x + POIOffsets.exit.x, spawn.y + POIOffsets.exit.y, spawn.z + POIOffsets.exit.z, POIOffsets.exit.h)

    return { objects, POIOffsets }
end

function CreateBarber(spawn)
	local objects = {}

    local POIOffsets = {}
	POIOffsets.exit = json.decode('{"z":1.4,"y":5.243,"x":1.590,"h":180.633972168}')
	DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Citizen.Wait(10)
    end
	RequestModel(`shell_barber`)
	while not HasModelLoaded(`shell_barber`) do
	    Citizen.Wait(1000)
	end
	local house = CreateObject(`shell_barber`, spawn.x, spawn.y, spawn.z, false, false, false)
    FreezeEntityPosition(house, true)
	table.insert(objects, house)

	TeleportToInterior(spawn.x + POIOffsets.exit.x, spawn.y + POIOffsets.exit.y, spawn.z + POIOffsets.exit.z, POIOffsets.exit.h)

    return { objects, POIOffsets }
end

function CreateOffice1(spawn)
	local objects = {}

    local POIOffsets = {}
	POIOffsets.exit = json.decode('{"z":2.3,"y":4.974823,"x":1.325928,"h":180.633972168}')
	DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Citizen.Wait(10)
    end
	RequestModel(`shell_office1`)
	while not HasModelLoaded(`shell_office1`) do
	    Citizen.Wait(1000)
	end
	local house = CreateObject(`shell_office1`, spawn.x, spawn.y, spawn.z, false, false, false)
    FreezeEntityPosition(house, true)
	table.insert(objects, house)

	TeleportToInterior(spawn.x + POIOffsets.exit.x, spawn.y + POIOffsets.exit.y, spawn.z + POIOffsets.exit.z, POIOffsets.exit.h)

    return { objects, POIOffsets }
end

function CreateLesterOsso(spawn)
	local objects = {}

    local POIOffsets = {}
	POIOffsets.exit = json.decode('{"z":1.369,"y":-5.911636,"x":-1.565928,"h":0.633972168}')
	DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Citizen.Wait(10)
    end
	RequestModel(`shell_lester`)
	while not HasModelLoaded(`shell_lester`) do
	    Citizen.Wait(1000)
	end
	local house = CreateObject(`shell_lester`, spawn.x, spawn.y, spawn.z, false, false, false)
    FreezeEntityPosition(house, true)
	table.insert(objects, house)

	TeleportToInterior(spawn.x + POIOffsets.exit.x, spawn.y + POIOffsets.exit.y, spawn.z + POIOffsets.exit.z, POIOffsets.exit.h)

    return { objects, POIOffsets }
end

function CreateWarehouse1(spawn)
	local objects = {}

    local POIOffsets = {}
	POIOffsets.exit = json.decode('{"x": -8.95, "y": 0.51, "z": 1.04, "h": 268.82}')
	DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Citizen.Wait(10)
    end
	RequestModel(`shell_warehouse1`)
	while not HasModelLoaded(`shell_warehouse1`) do
	    Citizen.Wait(1000)
	end
	local house = CreateObject(`shell_warehouse1`, spawn.x, spawn.y, spawn.z, false, false, false)
    FreezeEntityPosition(house, true)
	table.insert(objects, house)

	TeleportToInterior(spawn.x + POIOffsets.exit.x, spawn.y + POIOffsets.exit.y, spawn.z + POIOffsets.exit.z, POIOffsets.exit.h)

    return { objects, POIOffsets }
end

function CreateWarehouse2(spawn)
	local objects = {}
    local POIOffsets = {}
	POIOffsets.exit = json.decode('{"x": 12.51, "y": -0.01, "z": 1.03, "h": 94.52}')
	DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Citizen.Wait(10)
    end
	RequestModel(`shell_warehouse2`)
	while not HasModelLoaded(`shell_warehouse2`) do
	    Citizen.Wait(1000)
	end
	local house = CreateObject(`shell_warehouse2`, spawn.x, spawn.y, spawn.z, false, false, false)
    FreezeEntityPosition(house, true)
	table.insert(objects, house)

	TeleportToInterior(spawn.x + POIOffsets.exit.x, spawn.y + POIOffsets.exit.y, spawn.z + POIOffsets.exit.z, POIOffsets.exit.h)

    return { objects, POIOffsets }
end

function CreateWarehouse3(spawn)
	local objects = {}
    local POIOffsets = {}
	POIOffsets.exit = json.decode('{"x": 2.61, "y": -1.65, "z": 1.00, "h": 85.2}')
	DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Citizen.Wait(10)
    end
	RequestModel(`shell_warehouse3`)
	while not HasModelLoaded(`shell_warehouse3`) do
	    Citizen.Wait(1000)
	end
	local house = CreateObject(`shell_warehouse3`, spawn.x, spawn.y, spawn.z, false, false, false)
    FreezeEntityPosition(house, true)
	table.insert(objects, house)

	TeleportToInterior(spawn.x + POIOffsets.exit.x, spawn.y + POIOffsets.exit.y, spawn.z + POIOffsets.exit.z, POIOffsets.exit.h)

    return { objects, POIOffsets }
end

function CreateGarageHigh(spawn)
	local objects = {}
    local POIOffsets = {}
	POIOffsets.exit = json.decode('{"x": 12.02, "y": -14.30, "z": 0.99, "h": 89.42}')
	DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Citizen.Wait(10)
    end
	RequestModel(`shell_garagel`)
	while not HasModelLoaded(`shell_garagel`) do
	    Citizen.Wait(1000)
	end
	local house = CreateObject(`shell_garagel`, spawn.x, spawn.y, spawn.z, false, false, false)
    FreezeEntityPosition(house, true)
	table.insert(objects, house)

	TeleportToInterior(spawn.x + POIOffsets.exit.x, spawn.y + POIOffsets.exit.y, spawn.z + POIOffsets.exit.z, POIOffsets.exit.h)

    return { objects, POIOffsets }
end

function CreateGarageMed(spawn)
	local objects = {}
    local POIOffsets = {}
	POIOffsets.exit = json.decode('{"x": 13.90, "y": 1.63, "z": 1.0, "h": 87.05}')
	DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Citizen.Wait(10)
    end
	RequestModel(`shell_garagem`)
	while not HasModelLoaded(`shell_garagem`) do
	    Citizen.Wait(1000)
	end
	local house = CreateObject(`shell_garagem`, spawn.x, spawn.y, spawn.z, false, false, false)
    FreezeEntityPosition(house, true)
	table.insert(objects, house)

	TeleportToInterior(spawn.x + POIOffsets.exit.x, spawn.y + POIOffsets.exit.y, spawn.z + POIOffsets.exit.z, POIOffsets.exit.h)

    return { objects, POIOffsets }
end

	
function CreateGarageLow(spawn)
    local objects = {}
	local POIOffsets = {}
	POIOffsets.exit = json.decode('{"x": 5.85, "y": 3.86, "z": 1.0, "h": 180.05}')
	DoScreenFadeOut(500)
	while not IsScreenFadedOut() do
		Citizen.Wait(10)
	end
	RequestModel(`shell_garages`)
	while not HasModelLoaded(`shell_garages`) do
		Citizen.Wait(1000)
	end
	local house = CreateObject(`shell_garages`, spawn.x, spawn.y, spawn.z, false, false, false)
	FreezeEntityPosition(house, true)
	table.insert(objects, house)

	TeleportToInterior(spawn.x + POIOffsets.exit.x, spawn.y + POIOffsets.exit.y, spawn.z + POIOffsets.exit.z, POIOffsets.exit.h)

    return { objects, POIOffsets }
end	

function CreateGunstore(spawn)
	local objects = {}
    local POIOffsets = {}
	POIOffsets.exit = json.decode('{"x": -1.02, "y": -5.43, "z": 1.03, "h": 359.77}')
	DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Citizen.Wait(10)
    end
	RequestModel(`shell_gunstore`)
	while not HasModelLoaded(`shell_gunstore`) do
	    Citizen.Wait(1000)
	end
	local house = CreateObject(`shell_gunstore`, spawn.x, spawn.y, spawn.z, false, false, false)
    FreezeEntityPosition(house, true)
	table.insert(objects, house)

	TeleportToInterior(spawn.x + POIOffsets.exit.x, spawn.y + POIOffsets.exit.y, spawn.z + POIOffsets.exit.z, POIOffsets.exit.h)

    return { objects, POIOffsets }
end

function CreateMedium2(spawn)
	local objects = {}
    local POIOffsets = {}
	POIOffsets.exit = json.decode('{"x": 6.04, "y": 0.34, "z": 1.03, "h": 357.99}')
	DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Citizen.Wait(10)
    end
	RequestModel(`shell_medium2`)
	while not HasModelLoaded(`shell_medium2`) do
	    Citizen.Wait(1000)
	end
	local house = CreateObject(`shell_medium2`, spawn.x, spawn.y, spawn.z, false, false, false)
	FreezeEntityPosition(house, true)
	table.insert(objects, house)

	TeleportToInterior(spawn.x + POIOffsets.exit.x, spawn.y + POIOffsets.exit.y, spawn.z + POIOffsets.exit.z, POIOffsets.exit.h)

    return { objects, POIOffsets }
end

function CreateOfficeBig(spawn)
	local objects = {}
    local POIOffsets = {}
	POIOffsets.exit = json.decode('{"x": -12.48, "y": 1.91, "z": 5.30, "h": 175.13}')
	DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Citizen.Wait(10)
    end
	RequestModel(`shell_officebig`)
	while not HasModelLoaded(`shell_officebig`) do
	    Citizen.Wait(1000)
	end
	local house = CreateObject(`shell_officebig`, spawn.x, spawn.y, spawn.z, false, false, false)
    FreezeEntityPosition(house, true)
	table.insert(objects, house)

	TeleportToInterior(spawn.x + POIOffsets.exit.x, spawn.y + POIOffsets.exit.y, spawn.z + POIOffsets.exit.z, POIOffsets.exit.h)

    return { objects, POIOffsets }
end

function CreateStore2(spawn)
	local objects = {}
    local POIOffsets = {}
	POIOffsets.exit = json.decode('{"x": -0.64, "y": -5.07, "z": 1.02, "h": 1.91}')
	DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Citizen.Wait(10)
    end
	RequestModel(`shell_store2`)
	while not HasModelLoaded(`shell_store2`) do
	    Citizen.Wait(1000)
	end
	local house = CreateObject(`shell_store2`, spawn.x, spawn.y, spawn.z, false, false, false)
    FreezeEntityPosition(house, true)
	table.insert(objects, house)

	TeleportToInterior(spawn.x + POIOffsets.exit.x, spawn.y + POIOffsets.exit.y, spawn.z + POIOffsets.exit.z, POIOffsets.exit.h)

    return { objects, POIOffsets }
end

function CreateStore3(spawn)
	local objects = {}
    local POIOffsets = {}
	POIOffsets.exit = json.decode('{"x": -0.14, "y": -7.87, "z": 2.01, "h": 358.15}')
	DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Citizen.Wait(10)
    end
	RequestModel(`shell_store3`)
	while not HasModelLoaded(`shell_store3`) do
	    Citizen.Wait(1000)
	end
	local house = CreateObject(`shell_store3`, spawn.x, spawn.y, spawn.z, false, false, false)
    FreezeEntityPosition(house, true)
	table.insert(objects, house)

	TeleportToInterior(spawn.x + POIOffsets.exit.x, spawn.y + POIOffsets.exit.y, spawn.z + POIOffsets.exit.z, POIOffsets.exit.h)

    return { objects, POIOffsets }
end

function CreateContainer(spawn)
	local objects = {}
    local POIOffsets = {}
	POIOffsets.exit = json.decode('{"x": 0.08, "y": -5.73, "z": 1.24, "h": 359.32}')
	DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Citizen.Wait(10)
    end
	RequestModel(`container_shell`)
	while not HasModelLoaded(`container_shell`) do
	    Citizen.Wait(1000)
	end
	local house = CreateObject(`container_shell`, spawn.x, spawn.y, spawn.z, false, false, false)
    FreezeEntityPosition(house, true)
    objects[#objects+1] = house
	TeleportToInterior(spawn.x + POIOffsets.exit.x, spawn.y + POIOffsets.exit.y, spawn.z + POIOffsets.exit.z, POIOffsets.exit.h)
    return { objects, POIOffsets }
end