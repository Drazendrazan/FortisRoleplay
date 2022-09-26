local afkTimeout = 900
local timer = 0

local currentPosition  = nil
local previousPosition = nil
local currentHeading   = nil
local previousHeading  = nil

QBCore = nil

Citizen.CreateThread(function() 
    while true do
        Citizen.Wait(1)
        if QBCore == nil then
            TriggerEvent("QBCore:GetObject", function(obj) QBCore = obj end)    
            Citizen.Wait(200)
        end
    end
end)

local group = "user"
local isLoggedIn = false

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    QBCore.Functions.TriggerCallback('qb-afkkick:server:GetPermissions', function(UserGroup)
        group = UserGroup
    end)
    isLoggedIn = true
end)

RegisterNetEvent('QBCore:Client:OnPermissionUpdate')
AddEventHandler('QBCore:Client:OnPermissionUpdate', function(UserGroup)
    group = UserGroup
end)

RegisterNetEvent('fortis-afkkick:client:resetTimer')
AddEventHandler('fortis-afkkick:client:resetTimer', function()
	timer = 900
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)

		playerPed = PlayerPedId()
		if playerPed and group == 'user' then
			currentPosition = GetEntityCoords(playerPed, true)
			currentHeading  = GetEntityHeading(playerPed)

			if currentPosition == previousPosition and currentHeading == previousHeading then
				if timer > 0 then
					if timer == math.ceil(afkTimeout / 4) then
						QBCore.Functions.Notify('Je bent AFK en zal gekickt worden over ' .. timer .. ' seconden!', 'error', 10000)
					end

					timer = timer - 1
				else
					TriggerServerEvent("KickForAFK")
				end
			else
				timer = afkTimeout
			end

			previousPosition = currentPosition
			previousHeading  = currentHeading
		end
	end
end)