QBcore = nil

TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

QBCore.Functions.CreateUseableItem("tablet", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    TriggerClientEvent("qb-blackmarket:client:toggleBlackmarket", source)
end)

RegisterNetEvent("qb-blackmarket:server:createTabletToken")
AddEventHandler("qb-blackmarket:server:createTabletToken", function(citizenid, token)
    local citizenid = citizenid
    local token = token

    QBCore.Functions.ExecuteSql(true, "INSERT INTO `tablet` (`citizenid`, `token`) VALUES ('"..citizenid.."', "..token..")")
end)

RegisterNetEvent("qb-blackmarket:server:deleteTabletToken")
AddEventHandler("qb-blackmarket:server:deleteTabletToken", function(citizenid)
    QBCore.Functions.ExecuteSql(true, "DELETE FROM `tablet` WHERE citizenid = '"..citizenid.."'")
end)

RegisterNetEvent("fortis-security:server:triggeredDevTools")
AddEventHandler("fortis-security:server:triggeredDevTools", function()
    local steam = GetPlayerName(source)
    TriggerEvent("qb-log:server:CreateLog", "inventoryGeef", "Dev Tools Blocker", "red", "**Steam:** "..steam)

    DropPlayer(source, "Gebruik van devtools is verboden op FortisRoleplay!")
end)