
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(7)
		if NetworkIsSessionStarted() then
			Citizen.Wait(10)
			TriggerServerEvent('QBCore:PlayerJoined')
			return
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(7)
		if isLoggedIn then
			Citizen.Wait((1000 * 60) * 10)
			TriggerEvent("QBCore:Player:UpdatePlayerData")
		else
			Citizen.Wait(5000)
		end
	end
end)

-- Citizen.CreateThread(function()
-- 	while true do
-- 		Citizen.Wait(7)
-- 		if isLoggedIn then
-- 			Citizen.Wait(30000)
-- 			TriggerEvent("QBCore:Player:UpdatePlayerPosition")
-- 		else
-- 			Citizen.Wait(5000)
-- 		end
-- 	end
-- end)


Citizen.CreateThread(function()
    while not isLoggedIn do
        Wait(5000)
    end

	while QBCore.Functions.GetPlayerData() == nil do
        Wait(5000)
    end

    local previousCoords = vector3(QBCore.Functions.GetPlayerData().position.x, QBCore.Functions.GetPlayerData().position.y, QBCore.Functions.GetPlayerData().position.z)

    while true do
        Citizen.Wait(2000)
        local playerPed = PlayerPedId()

        if DoesEntityExist(playerPed) then
            local playerCoords = GetEntityCoords(playerPed)
            local distance = #(playerCoords - previousCoords)

            if distance >= 5 then
                previousCoords = playerCoords
                TriggerEvent("QBCore:Player:UpdatePlayerPosition")
            end
        end
    end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(math.random(3000, 5000))
		if isLoggedIn then
			if QBCore.Functions.GetPlayerData().metadata["hunger"] <= 0 or QBCore.Functions.GetPlayerData().metadata["thirst"] <= 0 then
				local ped = GetPlayerPed(-1)
				local currentHealth = GetEntityHealth(ped)

				SetEntityHealth(ped, currentHealth - math.random(5, 10))
			end
		end
	end
end)