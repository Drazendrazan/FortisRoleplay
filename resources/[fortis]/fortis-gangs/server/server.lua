QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

QBCore.Functions.CreateCallback("fortis-gangs:server:vraagGang", function(source, cb)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if Player.PlayerData.job.name == "benzon" or Player.PlayerData.job.name == "bratva" or Player.PlayerData.job.name == "gebroedersw" or Player.PlayerData.job.name == "gotti" then
        cb(true, Player.PlayerData.job.name)
    else
        cb(false, false)
    end
end)

-- QBCore.Functions.CreateCallback("fortis-gangs:server:checkGeld", function(source, cb)
--     local Player = QBCore.Functions.GetPlayer(source)

--     if Player.PlayerData.money["bank"] >= 300 then
--         Player.Functions.RemoveMoney("bank", 300, "Guiliano auto reparatie")
--         cb(true)
--     else
--         cb(false)
--     end
-- end)