QBCore = nil

TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

gebruikt = false

QBCore.Functions.CreateUseableItem("lotto", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("lotto:usar", source)
		gebruikt = true
    end
end)



RegisterServerEvent('zb-kraskaart:winamattie')
AddEventHandler('zb-kraskaart:winamattie', function()
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)

	if gebruikt then
		TriggerClientEvent("QBCore:Notify", source, "Gefeliciteerd, je hebt gewonnen!", "success")
		Player.Functions.AddMoney('cash',math.random(300, 1000), "Kraslot")
		gebruikt = false
	else
		TriggerClientEvent("QBCore:Notify", source, "Nou nee.", "error")
		Citizen.Wait(2000)
		-- TriggerEvent("zb-smallresources:server:banSpelerPerm", source)
	end
end)
