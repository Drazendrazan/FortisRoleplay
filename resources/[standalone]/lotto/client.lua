QBCore = nil

Citizen.CreateThread(function()
	while QBCore == nil do
		TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('lotto:usar')
AddEventHandler('lotto:usar', function()
	loadAnimDict("missheistdockssetup1clipboard@base")
    TaskPlayAnim(GetPlayerPed(-1), "missheistdockssetup1clipboard@base", "base", 8.0, -8, -1, 3, 0, 0, 0, 0)
	SetNuiFocus( true, true )
	SendNUIMessage({
		showPlayerMenu = true
	})
end)

RegisterNetEvent('lotto:showprice')
AddEventHandler('lotto:showprice', function(money)
	SetNuiFocus( true, true )
	SendNUIMessage({
		showPlayerMenu = nil,
		prize = money
	})
end)

RegisterCommand("helpnui", function(source, args, rawCommand)
	SetNuiFocus( false, false )
	SendNUIMessage({
		showPlayerMenu = false
	})

end)




RegisterNetEvent('lotto:addcalc')
AddEventHandler('lotto:addcalc', function()
	item = true
end)

RegisterNetEvent('lotto:removecalc')
AddEventHandler('lotto:removecalc', function()
	item = false
end)

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(5)
    end
end