QBCore = nil

Citizen.CreateThread(function()
	while QBCore == nil do
		TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
		Citizen.Wait(0)
	end
end)

local klaar = false
local timer = -1

Citizen.CreateThread(function()
	while true do 
		Citizen.Wait(1)
		local letsleep = true
        local ped = GetPlayerPed(-1)
		local pos = GetEntityCoords(GetPlayerPed(-1))

		if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.MeltLocation.x, Config.MeltLocation.y, Config.MeltLocation.z, true) < 3.5 then
            letsleep = false
            if timer > 0 then
                DrawText3D(Config.MeltLocation.x, Config.MeltLocation.y, Config.MeltLocation.z, "Goud klaar over " ..timer.. " seconden")
            elseif not klaar then
                DrawText3D(Config.MeltLocation.x, Config.MeltLocation.y, Config.MeltLocation.z, "~g~E~w~ - Smelten")
                if IsControlJustPressed(0, 38) then
                    QBCore.Functions.TriggerCallback("fortis-pawnshop:server:checksiraden", function(resultaat)
                        if resultaat then
                            timer = math.random(30, 60)
                        else
                            QBCore.Functions.Notify("Je hebt niet genoeg sieraden bij je!", "error")
                        end
                    end)
                end
            elseif klaar then
                DrawText3D(Config.MeltLocation.x, Config.MeltLocation.y, Config.MeltLocation.z, "~g~E~w~ - Oppakken")
                if IsControlJustPressed(0, 38) then
                    QBCore.Functions.Progressbar("pakgoud", "Goud oppakken..", 3000, false, false, {
                        disableMovement = true,
                        disableCarMovement = true,
                        disableMouse = false,
                        disableCombat = true,
                    }, {}, {}, {}, function() -- Done
                        TriggerServerEvent("fortis-pawnshop:sever:geefgoud")
                        klaar = false
                        timer = -1
                    end)
                end
            end              
		end

		if letsleep then
			Citizen.Wait(2500)
		end
	end
end)

-- Timer
Citizen.CreateThread(function()
	while true do 
        Citizen.Wait(1)
        if timer > 0 then
		    Citizen.Wait(1000)
            timer = timer -1
        elseif timer == 0 then 
            klaar = true
        end
    end
end)

local sellItemsSet = false
local hasGold = false
Citizen.CreateThread(function()
	while true do 
		Citizen.Wait(1)
		local inRange = false
		local pos = GetEntityCoords(GetPlayerPed(-1))
		if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.SellGold.x, Config.SellGold.y, Config.SellGold.z, true) < 3.0 then
			inRange = true
            if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.SellGold.x, Config.SellGold.y, Config.SellGold.z, true) < 1.5 then
                if GetClockHours() >= 9 and GetClockHours() <= 18 then
                    if not sellItemsSet then 
						hasGold = HasPlayerGold()
						sellItemsSet = true
                    elseif sellItemsSet and hasGold then
                        DrawText3D(Config.SellGold.x, Config.SellGold.y, Config.SellGold.z, "~g~E~w~ - Verkopen")
                        if IsControlJustReleased(0, Keys["E"]) then
                            local lockpickTime = 5000
                            ScrapAnim(lockpickTime)
                            QBCore.Functions.Progressbar("sell_gold", "Goud verkopen..", lockpickTime, false, false, {
                                disableMovement = true,
                                disableCarMovement = true,
                                disableMouse = false,
                                disableCombat = true,
                            }, {
                                animDict = "veh@break_in@0h@p_m_one@",
                                anim = "low_force_entry_ds",
                                flags = 16,
                            }, {}, {}, function() 
                                openingDoor = false
                                ClearPedTasks(GetPlayerPed(-1))
                                TriggerServerEvent('qb-pawnshop:server:sellGold')
                            end)
                        end
                    else
                        DrawText3D(Config.SellGold.x, Config.SellGold.y, Config.SellGold.z, "Je hebt geen goud bij je!")
                    end
                    
                else
                    DrawText3D(Config.SellGold.x, Config.SellGold.y, Config.SellGold.z, "Winkel gesloten..")
                end
			end
		end
        if not inRange then
            sellItemsSet = false
			Citizen.Wait(2500)
		end
	end
end)

function HasPlayerGold()
	local retval = false
	QBCore.Functions.TriggerCallback('qb-pawnshop:server:hasGold', function(result)
		retval = result
	end)
    Citizen.Wait(500)
	return retval
end

function ScrapAnim(time)
    local time = time / 1000
    loadAnimDict("mp_car_bomb")
    TaskPlayAnim(GetPlayerPed(-1), "mp_car_bomb", "car_bomb_mechanic" ,3.0, 3.0, -1, 16, 0, false, false, false)
    openingDoor = true
    Citizen.CreateThread(function()
        while openingDoor do
            TaskPlayAnim(PlayerPedId(), "mp_car_bomb", "car_bomb_mechanic", 3.0, 3.0, -1, 16, 0, 0, 0, 0)
            Citizen.Wait(2000)
            time = time - 2
            if time <= 0 then
                openingDoor = false
                StopAnimTask(GetPlayerPed(-1), "mp_car_bomb", "car_bomb_mechanic", 1.0)
            end
        end
    end)
end

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(5)
    end
end