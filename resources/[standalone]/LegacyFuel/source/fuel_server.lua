QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

function round(value, numDecimalPlaces)
	return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", value))
end

RegisterServerEvent('fuel:pay')
AddEventHandler('fuel:pay', function(price)
	local src = source
	local pData = QBCore.Functions.GetPlayer(src)
	local amount = round(price)

	if pData.Functions.RemoveMoney('cash', amount, "bought-fuel") then
		TriggerClientEvent("QBCore:Notify", src, "Je voertuig is gevuld met benzine!", "success")
	end
end)

RegisterServerEvent("fuel:jerrycan")
AddEventHandler("fuel:jerrycan", function()
    local Player = QBCore.Functions.GetPlayer(source)
	
	if Player.PlayerData.money["bank"] < 200 then
		TriggerClientEvent("QBCore:Notify", source, "Je hebt niet genoeg geld op de bank.", "error")
	else
    	Player.Functions.AddItem("jerry_can", 1)
		Player.Functions.RemoveMoney('bank', 200)
		TriggerClientEvent("QBCore:Notify", source, "Je hebt een jerrycan gekocht!", "success")
	end
end)