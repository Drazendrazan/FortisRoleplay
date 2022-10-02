

local menuEnabled = false

RegisterNetEvent("ToggleActionmenu")
AddEventHandler("ToggleActionmenu", function()
	ToggleActionMenu()
end)

function ToggleActionMenu()
	Citizen.Trace("tutorial launch")
	menuEnabled = not menuEnabled
	if ( menuEnabled ) then
		SetNuiFocus( true, true )
		SendNUIMessage({
			showPlayerMenu = true
		})
	else
		SetNuiFocus( false )
		SendNUIMessage({
			showPlayerMenu = false
		})
	end
end

function killTutorialMenu()
	ClearPedTasks(GetPlayerPed(-1))
	SetNuiFocus( false, false )
	SendNUIMessage({
		showPlayerMenu = false
	})
	menuEnabled = false

end

RegisterNUICallback('closeButton', function(data, cb)
	killTutorialMenu()
  	cb('ok')
end)

RegisterNUICallback('win', function(data, cb)
	TriggerServerEvent("zb-kraskaart:winamattie")
  	cb('ok')
	Citizen.Wait(1500)
	killTutorialMenu()
end)

RegisterNUICallback('lose', function(data, cb)
	QBCore.Functions.Notify("Helaas, volgende keer beter.", "error")
  	cb('ok')
	Citizen.Wait(1500)
	killTutorialMenu()
end)