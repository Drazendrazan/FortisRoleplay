QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

QBCore.Commands.Add("radar", "Zet de radar aan/uit.", {}, false, function(source, args)
	local Player = QBCore.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == "police" then
        TriggerClientEvent("wk:toggleRadar", source)
    else
        TriggerClientEvent('chatMessage', source, "SYSTEEM", "error", "Dit commando is uitsluitend voor hulpdiensten!")
    end
end)