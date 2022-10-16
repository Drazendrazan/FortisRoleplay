QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

QBCore.Commands.Add("setlawyer", "Neemt iemand aan als advocaat.", {{name="id", help="Speler ID"}}, true, function(source, args)
    local Player = QBCore.Functions.GetPlayer(source)
    local playerId = tonumber(args[1])
    local OtherPlayer = QBCore.Functions.GetPlayer(playerId)
    if Player.PlayerData.job.name == "judge" then
        if OtherPlayer ~= nil then 
            local lawyerInfo = {
                id = math.random(100000, 999999),
                firstname = OtherPlayer.PlayerData.charinfo.firstname,
                lastname = OtherPlayer.PlayerData.charinfo.lastname,
                citizenid = OtherPlayer.PlayerData.citizenid,
            }
            OtherPlayer.Functions.SetJob("lawyer")
            OtherPlayer.Functions.AddItem("lawyerpass", 1, false, lawyerInfo)
            TriggerClientEvent("QBCore:Notify", source, "Je hebt " .. OtherPlayer.PlayerData.charinfo.firstname .. " " .. OtherPlayer.PlayerData.charinfo.lastname .. " aangenomen als Advocaat.")
            TriggerClientEvent("QBCore:Notify", OtherPlayer.PlayerData.source, "Je bent nu een advocaat!")
            TriggerClientEvent('inventory:client:ItemBox', OtherPlayer.PlayerData.source, QBCore.Shared.Items["lawyerpass"], "add")
        else
            TriggerClientEvent("QBCore:Notify", source, "Deze persoon is niet online!", "error")
        end
    else
        TriggerClientEvent("QBCore:Notify", source, "Je hebt hier de rechten niet voor!", "error")
    end
end)

QBCore.Commands.Add("firelawyer", "Ontslaat iemand als advocaat.", {{name="id", help="Speler ID"}}, true, function(source, args)
    local Player = QBCore.Functions.GetPlayer(source)
    local playerId = tonumber(args[1])
    local OtherPlayer = QBCore.Functions.GetPlayer(playerId)
    if Player.PlayerData.job.name == "judge" then
        if OtherPlayer ~= nil then 
            --OtherPlayer.Functions.SetJob("unemployed")
            TriggerClientEvent("QBCore:Notify", OtherPlayer.PlayerData.source, "Je bent nu werkloos!")
            TriggerClientEvent("QBCore:Notify", source, "Je hebt ".. OtherPlayer.PlayerData.charinfo.firstname .. " " .. OtherPlayer.PlayerData.charinfo.lastname .. "ontslagen als advocaat!")
        else
            TriggerClientEvent("QBCore:Notify", source, "Deze persoon is niet online!", "error")
        end
    else
        TriggerClientEvent("QBCore:Notify", source, "Je hebt hier de rechten niet voor!", "error")
    end
end)

QBCore.Functions.CreateUseableItem("lawyerpass", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent("qb-justice:client:showLawyerLicense", -1, source, item.info)
    end
end)