QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

-- Attachments dealer random locatie kiezen
Citizen.CreateThread(function()
    local randomLocatie = math.random(1, #Config.DealerLocaties)
    locatie = Config.DealerLocaties[randomLocatie]
end)

QBCore.Functions.CreateCallback("zb-bmshop:server:checkDealer", function(source, cb)
    cb(locatie)
end)

RegisterServerEvent("zb-bmshop:server:koopAttachment")
AddEventHandler("zb-bmshop:server:koopAttachment", function(id)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local attachment = Config.Attachments[id]
    local viesgeld = Player.Functions.GetItemByName("viesgeld")

    if viesgeld ~= nil then
        if viesgeld.amount < attachment.prijs then
            TriggerClientEvent("QBCore:Notify", source, "Je hebt niet genoeg vies geld bij je.", "error")
        else
            TriggerClientEvent("QBCore:Notify", source, "Je hebt een "..attachment.item.." gekocht!", "success")
            Player.Functions.RemoveItem("viesgeld", attachment.prijs)
            Player.Functions.AddItem(attachment.item, 1)
            TriggerClientEvent("zb-bmshop:client:emote", src)
        end
    else
        TriggerClientEvent("QBCore:Notify", source, "Je hebt niet genoeg vies geld bij je.", "error")
    end
end)

-- Dump
function dump(o)
    if type(o) == 'table' then
       local s = '{ '
       for k,v in pairs(o) do
          if type(k) ~= 'number' then k = '"'..k..'"' end
          s = s .. '['..k..'] = ' .. dump(v) .. ','
       end
       return s .. '} '
    else
       return tostring(o)
    end
end