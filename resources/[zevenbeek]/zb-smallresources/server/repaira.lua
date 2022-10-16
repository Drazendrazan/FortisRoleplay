QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

autoDrift = {}


QBCore.Functions.CreateCallback('repaira:server:AnwbAantal', function(source, cb)
    local anwb = 0

    for k, v in pairs(QBCore.Functions.GetPlayers()) do
        local Player = QBCore.Functions.GetPlayer(v)
        if Player ~= nil then 
            if (Player.PlayerData.job.name == "mechanic" and Player.PlayerData.job.onduty) then
                anwb = anwb + 1
            end
        end
    end

    cb(anwb)
end)

RegisterNetEvent("zb-smallresources:server:slaAutoOp")
AddEventHandler("zb-smallresources:server:slaAutoOp", function(voertuig, plate, drift)
    local src = source
	local Player = QBCore.Functions.GetPlayer(src)
    local steam = Player.PlayerData.steam
    local drift = drift
    QBCore.Functions.ExecuteSql(false, "SELECT `drifttires` FROM `player_vehicles` WHERE `plate` = '"..plate.."'", function(result)
        if result[1].drifttires == 0 then
            QBCore.Functions.ExecuteSql(false, "UPDATE `player_vehicles` SET drifttires = ".. drift.." WHERE plate = '"..plate.."'")
        else
            QBCore.Functions.ExecuteSql(false, "UPDATE `player_vehicles` SET drifttires = ".. drift.." WHERE plate = '"..plate.."'")
        end
    end)
end) 

QBCore.Functions.CreateCallback('zb-smallresources:server:checkAuto', function(source, cb, voertuig, plate)
	local retval = false
	local Player = QBCore.Functions.GetPlayer(source)
    local steam = Player.PlayerData.steam
    local voertuig = voertuig
    QBCore.Functions.ExecuteSql(false, "SELECT `drifttires` FROM `player_vehicles` WHERE `plate` = '"..plate.."'", function(result)
        if result[1] ~= nil then
            cb(result)
        else
            cb(nil)
        end 
    end)
end)

RegisterNetEvent("zb-smallresources:server:betaalAuto")
AddEventHandler("zb-smallresources:server:betaalAuto", function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    Player.Functions.RemoveMoney("bank", 2000, "Voertuig voorzien van driftbanden")
end)

function getAutoDrift(src, veh)
    local retval = false
    local Player = QBCore.Functions.GetPlayer(src)
    local steam = Player.PlayerData.steam
    local voertuig = veh 

    for k, v in pairs(autoDrift) do
        if k == steam then
            if v.auto == voertuig then
                retval = true
            end
            if v.auto == nil then
                retval = nil
            end
        end 
        return retval
    end
end