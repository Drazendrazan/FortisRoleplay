RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    isLoggedIn = true
    PlayerData = QBCore.Functions.GetPlayerData()
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate')
AddEventHandler('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerData.job = JobInfo
end)

spawn = false
laaststeRolstoel = nil

Citizen.CreateThread(function()
	while PlayerData == nil do Wait(500) end
    while PlayerData.job == nil do Wait(500) end
	while true do
		Citizen.Wait(1)
		if PlayerData.job.name == "ambulance" then

			local ped = GetPlayerPed(-1)
			local pedCoords = GetEntityCoords(ped)


			if GetDistanceBetweenCoords(pedCoords, 317.74, -587.91, 43.28, true) < 7 then
				DrawMarker(0, 317.74, -587.91, 43.08, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.2, 0.2, 0.1, 0, 200, 255, 155, false, false, false, true, false, false, false)
				if GetDistanceBetweenCoords(pedCoords, 317.74, -587.91, 43.28, true) < 1.5 then
					if not spawn then
						DrawText3Ds(317.74, -587.91, 43.28, "~g~X~w~ - Pak Rolstoel")
						if IsControlJustPressed(0, 73) then
							spawn = true
							LoadModel('prop_wheelchair_01')

							laaststeRolstoel = CreateObject(GetHashKey('prop_wheelchair_01'), 317.74, -587.91, 42.28, true)
							SetEntityHeading(laaststeRolstoel, 185.0)
						end
					else 
						DrawText3Ds(317.74, -587.91, 43.28, "~g~X~w~ - Verwijder rolstoel")
						if IsControlJustPressed(0, 73) then
							spawn = false
							-- local wheelchair = GetClosestObjectOfType(GetEntityCoords(GetPlayerPed(-1)), 10.0, GetHashKey('prop_wheelchair_01'))

							if DoesEntityExist(laaststeRolstoel) then
								DeleteEntity(laaststeRolstoel)
							end
						end
					end
				end
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		local letsleep = true

		local ped = GetPlayerPed(-1)
		local pedCoords = GetEntityCoords(ped)

		local wheelchairObject = GetClosestObjectOfType(pedCoords.x, pedCoords.y, pedCoords.z, 3.0, GetHashKey("prop_wheelchair_01"), false)

		if DoesEntityExist(wheelchairObject) then
			letsleep = false
			local wheelChairCoords = GetEntityCoords(wheelchairObject)
			local wheelChairForward = GetEntityForwardVector(wheelchairObject)
			
			local sitCoords = (wheelChairCoords + wheelChairForward * - 0.5)
			local pickupCoords = (wheelChairCoords + wheelChairForward * 0.3)

			if GetDistanceBetweenCoords(pedCoords, sitCoords, true) <= 1.0 then
				DrawText3Ds(sitCoords.x, sitCoords.y, sitCoords.z, "~g~E~w~ - Zit")

				if IsControlJustPressed(0, 38) then
					Sit(wheelchairObject)
				end
			end

			if GetDistanceBetweenCoords(pedCoords, pickupCoords, true) <= 1.5 then
				DrawText3Ds(pickupCoords.x, pickupCoords.y, pickupCoords.z, "~g~E~w~ - Pak vast")

				if IsControlJustPressed(0, 38) then
					PickUp(wheelchairObject)
				end
			end
		end

		if letsleep then
			Citizen.Wait(1000)
		end
	end
end)

Sit = function(wheelchairObject)
	local closestPlayer, closestPlayerDist = GetClosestPlayer()

	if closestPlayer ~= nil and closestPlayerDist <= 1.5 then
		if IsEntityPlayingAnim(GetPlayerPed(closestPlayer), 'missfinale_c2leadinoutfin_c_int', '_leadin_loop2_lester', 3) then
			QBCore.Functions.Notify("Er is al iemand in deze rolstoel aan het rijden!", "error")
			return
		end
	end

	LoadAnim("missfinale_c2leadinoutfin_c_int")

	AttachEntityToEntity(GetPlayerPed(-1), wheelchairObject, 0, 0, 0.0, 0.4, 0.0, 0.0, 180.0, 0.0, false, false, false, false, 2, true)

	local heading = GetEntityHeading(wheelchairObject)

	while IsEntityAttachedToEntity(GetPlayerPed(-1), wheelchairObject) do
		Citizen.Wait(5)
		local ped = GetPlayerPed(-1)
		local pedCoords = GetEntityCoords(ped) 

		if IsPedDeadOrDying(GetPlayerPed(-1)) then -- Dood gaan
			DetachEntity(GetPlayerPed(-1), true, false)
		end

		if not IsEntityPlayingAnim(GetPlayerPed(-1), 'missfinale_c2leadinoutfin_c_int', '_leadin_loop2_lester', 3) then -- Animatie
			TaskPlayAnim(GetPlayerPed(-1), 'missfinale_c2leadinoutfin_c_int', '_leadin_loop2_lester', 8.0, 8.0, -1, 69, 1, false, false, false)
		end

		if IsControlJustPressed(0, 73) then -- X
			DetachEntity(GetPlayerPed(-1), true, false)

			local x, y, z = table.unpack(GetEntityCoords(wheelchairObject) + GetEntityForwardVector(wheelchairObject) * - 0.7)

			SetEntityCoords(GetPlayerPed(-1), x,y,z)
		end
	end
end

PickUp = function(wheelchairObject)
	local closestPlayer, closestPlayerDist = GetClosestPlayer()

	if closestPlayer ~= nil and closestPlayerDist <= 1.5 then
		if IsEntityPlayingAnim(GetPlayerPed(closestPlayer), 'anim@heists@box_carry@', 'idle', 3) then
			QBCore.Functions.Notify("Er is al iemand in deze rolstoel aan het rijden!", "error")
			return
		end
	end

	NetworkRequestControlOfEntity(wheelchairObject)

	LoadAnim("anim@heists@box_carry@")

	AttachEntityToEntity(wheelchairObject, GetPlayerPed(-1), GetPedBoneIndex(GetPlayerPed(-1), 28422), -0.00, -0.3, -0.73, 195.0, 180.0, 180.0, true, false, false, true, false, 2, true)

	while IsEntityAttachedToEntity(wheelchairObject, GetPlayerPed(-1)) do
		Citizen.Wait(1)
		local ped = GetPlayerPed(-1)
		local pedCoords = GetEntityCoords(ped) 

		if GetDistanceBetweenCoords(pedCoords, 298.77, -584.51, 43.15) < 1.5 then -- Deur
			DetachEntity(wheelchairObject, true, false)

			Citizen.Wait(1)
			ClearPedTasksImmediately(GetPlayerPed(-1))
			QBCore.Functions.Notify("Het is niet toegestaan om deze mee te nemen naar buiten!", "error")
			return
		end

		if not IsEntityPlayingAnim(GetPlayerPed(-1), 'anim@heists@box_carry@', 'idle', 3) then -- Animatie
			TaskPlayAnim(GetPlayerPed(-1), 'anim@heists@box_carry@', 'idle', 8.0, 8.0, -1, 50, 0, false, false, false)
		end

		if IsPedDeadOrDying(GetPlayerPed(-1)) then -- Dood gaan
			DetachEntity(wheelchairObject, true, false)
		end

		if IsControlJustPressed(0, 73) then -- X
			DetachEntity(wheelchairObject, true, false)
			ClearPedTasksImmediately(GetPlayerPed(-1))
		end
	end
end

GetPlayers = function()
    local players = {}

    for i = 0, 31 do
        if NetworkIsPlayerActive(i) then
            table.insert(players, i)
        end
    end

    return players
end

GetClosestPlayer = function()
	local players = GetPlayers()
	local closestDistance = -1
	local closestPlayer = -1
	local ply = GetPlayerPed(-1)
	local plyCoords = GetEntityCoords(ply, 0)
	
	for index,value in ipairs(players) do
		local target = GetPlayerPed(value)
		if(target ~= ply) then
			local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
			local distance = Vdist(targetCoords["x"], targetCoords["y"], targetCoords["z"], plyCoords["x"], plyCoords["y"], plyCoords["z"])
			if(closestDistance == -1 or closestDistance > distance) then
				closestPlayer = value
				closestDistance = distance
			end
		end
	end
	
	return closestPlayer, closestDistance
end

LoadAnim = function(dict)
	while not HasAnimDictLoaded(dict) do
		RequestAnimDict(dict)
		
		Citizen.Wait(1)
	end
end

LoadModel = function(model)
	while not HasModelLoaded(model) do
		RequestModel(model)
		
		Citizen.Wait(1)
	end
end