QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

local Plates = {}
cuffedPlayers = {}
PlayerStatus = {}
Casings = {}
BloodDrops = {}
FingerDrops = {}
local Objects = {}


Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(1000 * 60 * 10)
        local curCops = GetCurrentCops()
        TriggerClientEvent("police:SetCopCount", -1, curCops)
    end
end)

RegisterServerEvent('police:server:CheckBills')
AddEventHandler('police:server:CheckBills', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    QBCore.Functions.ExecuteSql(false, "SELECT * FROM `bills` WHERE `citizenid` = '"..Player.PlayerData.citizenid.."' AND `type` = 'police'", function(result)
        if result[1] ~= nil then
            local totalAmount = 0
			for k, v in pairs(result) do
				totalAmount = totalAmount + tonumber(v.amount)
            end
            Player.Functions.RemoveMoney("bank", totalAmount, "paid-all-bills")
            QBCore.Functions.ExecuteSql(false, "DELETE FROM `bills` WHERE `citizenid` = '"..Player.PlayerData.citizenid.."' AND `type` = 'police'")
            TriggerClientEvent('police:client:sendBillingMail', src, totalAmount)
            TriggerEvent('qb-moneysafe:server:DepositMoney', "police", totalAmount, "bills")
		end
	end)
end)

RegisterServerEvent('police:server:CuffPlayer')
AddEventHandler('police:server:CuffPlayer', function(playerId, isSoftcuff)
    local src = source
    local Player = QBCore.Functions.GetPlayer(source)
    local CuffedPlayer = QBCore.Functions.GetPlayer(playerId)
    if CuffedPlayer ~= nil then
        if Player.Functions.GetItemByName("handcuffs") ~= nil or Player.PlayerData.job.name == "police" then
            TriggerClientEvent("police:client:GetCuffed", CuffedPlayer.PlayerData.source, Player.PlayerData.source, isSoftcuff)           
        end
    end
end)

RegisterServerEvent('police:server:EscortPlayer')
AddEventHandler('police:server:EscortPlayer', function(playerId)
    local src = source
    local Player = QBCore.Functions.GetPlayer(source)
    local EscortPlayer = QBCore.Functions.GetPlayer(playerId)
    if EscortPlayer ~= nil then
        if (Player.PlayerData.job.name == "police" or Player.PlayerData.job.name == "ambulance" or Player.PlayerData.job.name == "doctor") or (EscortPlayer.PlayerData.metadata["ishandcuffed"] or EscortPlayer.PlayerData.metadata["isdead"] or EscortPlayer.PlayerData.metadata["inlaststand"]) then
            TriggerClientEvent("police:client:GetEscorted", EscortPlayer.PlayerData.source, Player.PlayerData.source)
        else
            TriggerClientEvent('chatMessage', src, "SYSTEEM", "error", "Persoon is niet dood of geboeid!")
        end
    end
end)

RegisterServerEvent('police:server:KidnapPlayer')
AddEventHandler('police:server:KidnapPlayer', function(playerId)
    local src = source
    local Player = QBCore.Functions.GetPlayer(source)
    local EscortPlayer = QBCore.Functions.GetPlayer(playerId)
    if EscortPlayer ~= nil then
        if EscortPlayer.PlayerData.metadata["ishandcuffed"] or EscortPlayer.PlayerData.metadata["isdead"] or EscortPlayer.PlayerData.metadata["inlaststand"] then
            TriggerClientEvent("police:client:GetKidnappedTarget", EscortPlayer.PlayerData.source, Player.PlayerData.source)
            TriggerClientEvent("police:client:GetKidnappedDragger", Player.PlayerData.source, EscortPlayer.PlayerData.source)
        else
            TriggerClientEvent('chatMessage', src, "SYSTEEM", "error", "Persoon is niet dood of geboeid!")
        end
    end
end)

RegisterServerEvent('police:server:SetPlayerOutVehicle')
AddEventHandler('police:server:SetPlayerOutVehicle', function(playerId)
    local src = source
    local Player = QBCore.Functions.GetPlayer(source)
    local EscortPlayer = QBCore.Functions.GetPlayer(playerId)
    if EscortPlayer ~= nil then
        if EscortPlayer.PlayerData.metadata["ishandcuffed"] or EscortPlayer.PlayerData.metadata["isdead"] then
            TriggerClientEvent("police:client:SetOutVehicle", EscortPlayer.PlayerData.source)
        elseif Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty then
            TriggerClientEvent("police:client:SetOutVehicle", EscortPlayer.PlayerData.source)
        else
            TriggerClientEvent('chatMessage', src, "SYSTEEM", "error", "Persoon is niet dood of geboeid!")
        end
    end
end)

RegisterServerEvent('police:server:PutPlayerInVehicle')
AddEventHandler('police:server:PutPlayerInVehicle', function(playerId)
    local src = source
    local Player = QBCore.Functions.GetPlayer(source)
    local EscortPlayer = QBCore.Functions.GetPlayer(playerId)
    if EscortPlayer ~= nil then
        if EscortPlayer.PlayerData.metadata["ishandcuffed"] or EscortPlayer.PlayerData.metadata["isdead"] then
            TriggerClientEvent("police:client:PutInVehicle", EscortPlayer.PlayerData.source)
        else
            TriggerClientEvent('chatMessage', src, "SYSTEEM", "error", "Persoon is niet dood of geboeid")
        end
    end
end)

RegisterServerEvent('police:server:BillPlayer')
AddEventHandler('police:server:BillPlayer', function(playerId, price)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local OtherPlayer = QBCore.Functions.GetPlayer(playerId)
    if Player.PlayerData.job.name == "police" then
        if OtherPlayer ~= nil then
            OtherPlayer.Functions.RemoveMoney("bank", price, "paid-bills")
            TriggerClientEvent('QBCore:Notify', OtherPlayer.PlayerData.source, "Je hebt een boete onvangen van €"..price)
        end
    end
end)

RegisterServerEvent('police:server:JailPlayer')
AddEventHandler('police:server:JailPlayer', function(playerId, time)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local OtherPlayer = QBCore.Functions.GetPlayer(playerId)
    local currentDate = os.date("*t")
    if currentDate.day == 31 then currentDate.day = 30 end

    if Player.PlayerData.job.name == "police" then
        if OtherPlayer ~= nil then
            OtherPlayer.Functions.SetMetaData("injail", time)
            OtherPlayer.Functions.SetMetaData("criminalrecord", {
                ["hasRecord"] = true,
                ["date"] = currentDate
            })
            TriggerClientEvent("police:client:SendToJail", OtherPlayer.PlayerData.source, time)
            TriggerClientEvent('QBCore:Notify', src, "Je hebt de persoon voor "..time.." maanden naar de gevangenis gestuurd!")
        end
    end
end)

RegisterServerEvent('police:server:SetHandcuffStatus')
AddEventHandler('police:server:SetHandcuffStatus', function(isHandcuffed)
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
	if Player ~= nil then
		Player.Functions.SetMetaData("ishandcuffed", isHandcuffed)
	end
end)

RegisterServerEvent('heli:spotlight')
AddEventHandler('heli:spotlight', function(state)
	local serverID = source
	TriggerClientEvent('heli:spotlight', -1, serverID, state)
end)

RegisterServerEvent('police:server:FlaggedPlateTriggered')
AddEventHandler('police:server:FlaggedPlateTriggered', function(camId, plate, street1, street2, blipSettings)
    local src = source
    for k, v in pairs(QBCore.Functions.GetPlayers()) do
        local Player = QBCore.Functions.GetPlayer(v)
        if Player ~= nil then
            if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) then
                if street2 ~= nil then
                    TriggerClientEvent("112:client:SendPoliceAlert", v, "flagged", {
                        camId = camId,
                        plate = plate,
                        streetLabel = street1.. " "..street2,
                    }, blipSettings)
                else
                    TriggerClientEvent("112:client:SendPoliceAlert", v, "flagged", {
                        camId = camId,
                        plate = plate,
                        streetLabel = street1
                    }, blipSettings)
                end
            end
        end
	end
end)

RegisterServerEvent('police:server:PoliceAlertMessage')
AddEventHandler('police:server:PoliceAlertMessage', function(title, streetLabel, coords)
    local src = source

    for k, v in pairs(QBCore.Functions.GetPlayers()) do
        local Player = QBCore.Functions.GetPlayer(v)
        if Player ~= nil then 
            if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) then
                TriggerClientEvent("police:client:PoliceAlertMessage", v, title, streetLabel, coords)
            elseif Player.Functions.GetItemByName("radioscanner") ~= nil and math.random(1, 100) <= 50 then
                TriggerClientEvent("police:client:PoliceAlertMessage", v, title, streetLabel, coords)
            end
        end
    end
end)

RegisterServerEvent('police:server:GunshotAlert')
AddEventHandler('police:server:GunshotAlert', function(streetLabel, isAutomatic, fromVehicle, coords, vehicleInfo)
    local src = source

    for k, v in pairs(QBCore.Functions.GetPlayers()) do
        local Player = QBCore.Functions.GetPlayer(v)
        if Player ~= nil then 
            if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) then
                TriggerClientEvent("police:client:GunShotAlert", Player.PlayerData.source, streetLabel, isAutomatic, fromVehicle, coords, vehicleInfo)
            elseif Player.Functions.GetItemByName("radioscanner") ~= nil and math.random(1, 100) <= 50 then
                TriggerClientEvent("police:client:GunShotAlert", Player.PlayerData.source, streetLabel, isAutomatic, fromVehicle, coords, vehicleInfo)
            end
        end
    end
end)

RegisterServerEvent('police:server:VehicleCall')
AddEventHandler('police:server:VehicleCall', function(pos, msg, alertTitle, streetLabel, modelPlate, modelName)
    local src = source
    local alertData = {
        title = "Vehicle theft",
        coords = {x = pos.x, y = pos.y, z = pos.z},
        description = msg,
    }
    TriggerClientEvent("police:client:VehicleCall", -1, pos, alertTitle, streetLabel, modelPlate, modelName)
    TriggerClientEvent("qb-phone:client:addPoliceAlert", -1, alertData)
end)

RegisterServerEvent('police:server:HouseRobberyCall')
AddEventHandler('police:server:HouseRobberyCall', function(coords, message, gender, streetLabel)
    local src = source
    local alertData = {
        title = "Huisinbraak",
        coords = {x = coords.x, y = coords.y, z = coords.z},
        description = message,
    }
    TriggerClientEvent("police:client:HouseRobberyCall", -1, coords, message, gender, streetLabel)
    TriggerClientEvent("qb-phone:client:addPoliceAlert", -1, alertData)
end)

RegisterServerEvent('police:server:SendEmergencyMessage')
AddEventHandler('police:server:SendEmergencyMessage', function(coords, message)
    local src = source
    local MainPlayer = QBCore.Functions.GetPlayer(src)
    local alertData = {
        title = "112 Melding - "..MainPlayer.PlayerData.charinfo.phone,
        coords = {x = coords.x, y = coords.y, z = coords.z},
        description = message,
    }
    TriggerClientEvent("qb-phone:client:addPoliceAlert", -1, alertData)
    TriggerClientEvent('police:server:SendEmergencyMessageCheck', -1, MainPlayer, message, coords)
end)

RegisterServerEvent('police:server:SearchPlayer')
AddEventHandler('police:server:SearchPlayer', function(playerId)
    local src = source
    local SearchedPlayer = QBCore.Functions.GetPlayer(playerId)
    if SearchedPlayer ~= nil then 
        TriggerClientEvent('chatMessage', source, "SYSTEEM", "warning", "Persoon heeft €"..SearchedPlayer.PlayerData.money["cash"]..",- op zak..")
        TriggerClientEvent('QBCore:Notify', SearchedPlayer.PlayerData.source, "Je wordt gefouilleerd..")
    end
end)

RegisterServerEvent('police:server:SeizeCash')
AddEventHandler('police:server:SeizeCash', function(playerId)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local SearchedPlayer = QBCore.Functions.GetPlayer(playerId)
    if SearchedPlayer ~= nil then 
        local moneyAmount = SearchedPlayer.PlayerData.money["cash"]
        local info = {
            cash = moneyAmount,
        }
        SearchedPlayer.Functions.RemoveMoney("cash", moneyAmount, "police-cash-seized")
        Player.Functions.AddItem("moneybag", 1, false, info)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["moneybag"], "add")
        TriggerClientEvent('QBCore:Notify', SearchedPlayer.PlayerData.source, "Je geld is afgenomen..")
    end
end)

RegisterServerEvent('police:server:SeizeDriverLicense')
AddEventHandler('police:server:SeizeDriverLicense', function(playerId)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local SearchedPlayer = QBCore.Functions.GetPlayer(playerId)
    if SearchedPlayer ~= nil then
        local driverLicense = SearchedPlayer.PlayerData.metadata["licences"]["driver"]
        if driverLicense then
            local licenses = {
                ["driver"] = false,
                ["business"] = SearchedPlayer.PlayerData.metadata["licences"]["business"]
            }
            SearchedPlayer.Functions.SetMetaData("licences", licenses)
            TriggerClientEvent('QBCore:Notify', SearchedPlayer.PlayerData.source, "Your driving license has been confiscated..")
        else
            TriggerClientEvent('QBCore:Notify', src, "Can't confiscate driving license..", "error")
        end
    end
end)

RegisterServerEvent('police:server:RobPlayer')
AddEventHandler('police:server:RobPlayer', function(playerId)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local SearchedPlayer = QBCore.Functions.GetPlayer(playerId)
    if SearchedPlayer ~= nil then 
        local money = SearchedPlayer.PlayerData.money["cash"]
        Player.Functions.AddMoney("cash", money, "police-player-robbed")
        SearchedPlayer.Functions.RemoveMoney("cash", money, "police-player-robbed")
        TriggerClientEvent('QBCore:Notify', SearchedPlayer.PlayerData.source, "Je bent overvallen van €"..money.."..")
    end
end)

RegisterServerEvent('police:server:UpdateBlips')
AddEventHandler('police:server:UpdateBlips', function()
    -- local src = source
    -- local dutyPlayers = {}
    -- for k, v in pairs(QBCore.Functions.GetPlayers()) do
    --     local Player = QBCore.Functions.GetPlayer(v)
    --     if Player ~= nil then 
    --         if ((Player.PlayerData.job.name == "police" or Player.PlayerData.job.name == "ambulance" or Player.PlayerData.job.name == "doctor") and Player.PlayerData.job.onduty) then
    --             table.insert(dutyPlayers, {
    --                 source = Player.PlayerData.source,
    --                 label = Player.PlayerData.metadata["callsign"],
	-- 				item = Player.Functions.GetItemByName('radio') ~= nil,
    --                 job = Player.PlayerData.job.name,
    --             })
    --         end
    --     end
    -- end
    -- TriggerClientEvent("police:client:UpdateBlips", -1, dutyPlayers)
end)

RegisterServerEvent('police:server:spawnObject')
AddEventHandler('police:server:spawnObject', function(type)
    local src = source
    local objectId = CreateObjectId()
    Objects[objectId] = type
    TriggerClientEvent("police:client:spawnObject", -1, objectId, type, src)
end)

RegisterServerEvent('police:server:deleteObject')
AddEventHandler('police:server:deleteObject', function(objectId)
    local src = source
    TriggerClientEvent('police:client:removeObject', -1, objectId)
end)

RegisterServerEvent('police:server:Impound')
AddEventHandler('police:server:Impound', function(plate, fullImpound, price)
    local src = source
    local price = price ~= nil and price or 0
    if IsVehicleOwned(plate) then
        if not fullImpound then
            exports['ghmattimysql']:execute('UPDATE player_vehicles SET state = @state, depotprice = @depotprice WHERE plate = @plate', {['@state'] = 0, ['@depotprice'] = price, ['@plate'] = plate})
            TriggerClientEvent('QBCore:Notify', src, "Voertuig is in het depot gezet voor €"..price.."!")
        else
            exports['ghmattimysql']:execute('UPDATE player_vehicles SET state = @state WHERE plate = @plate', {['@state'] = 2, ['@plate'] = plate})
            TriggerClientEvent('QBCore:Notify', src, "Voertuig is in de impound gezet!")
        end
    end
end)

RegisterServerEvent('evidence:server:UpdateStatus')
AddEventHandler('evidence:server:UpdateStatus', function(data)
    local src = source
    PlayerStatus[src] = data
end)

RegisterServerEvent('evidence:server:CreateBloodDrop')
AddEventHandler('evidence:server:CreateBloodDrop', function(citizenid, bloodtype, coords)
    local src = source
    local bloodId = CreateBloodId()
    BloodDrops[bloodId] = {dna = citizenid, bloodtype = bloodtype}
    TriggerClientEvent("evidence:client:AddBlooddrop", -1, bloodId, citizenid, bloodtype, coords)
end)

RegisterServerEvent('evidence:server:CreateFingerDrop')
AddEventHandler('evidence:server:CreateFingerDrop', function(coords)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local fingerId = CreateFingerId()
    FingerDrops[fingerId] = Player.PlayerData.metadata["fingerprint"]
    TriggerClientEvent("evidence:client:AddFingerPrint", -1, fingerId, Player.PlayerData.metadata["fingerprint"], coords)
end)

RegisterServerEvent('evidence:server:ClearBlooddrops')
AddEventHandler('evidence:server:ClearBlooddrops', function(blooddropList)
    if blooddropList ~= nil and next(blooddropList) ~= nil then 
        for k, v in pairs(blooddropList) do
            TriggerClientEvent("evidence:client:RemoveBlooddrop", -1, v)
            BloodDrops[v] = nil
        end
    end
end)

RegisterServerEvent('evidence:server:AddBlooddropToInventory')
AddEventHandler('evidence:server:AddBlooddropToInventory', function(bloodId, bloodInfo)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player.Functions.RemoveItem("empty_evidence_bag", 1) then
        if Player.Functions.AddItem("filled_evidence_bag", 1, false, bloodInfo) then
            TriggerClientEvent("inventory:client:ItemBox", src, QBCore.Shared.Items["filled_evidence_bag"], "add")
            TriggerClientEvent("evidence:client:RemoveBlooddrop", -1, bloodId)
            BloodDrops[bloodId] = nil
        end
    else
        TriggerClientEvent('QBCore:Notify', src, "Je hebt geen leeg bewijszakje bij je!", "error")
    end
end)

RegisterServerEvent('evidence:server:AddFingerprintToInventory')
AddEventHandler('evidence:server:AddFingerprintToInventory', function(fingerId, fingerInfo)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player.Functions.RemoveItem("empty_evidence_bag", 1) then
        if Player.Functions.AddItem("filled_evidence_bag", 1, false, fingerInfo) then
            TriggerClientEvent("inventory:client:ItemBox", src, QBCore.Shared.Items["filled_evidence_bag"], "add")
            TriggerClientEvent("evidence:client:RemoveFingerprint", -1, fingerId)
            FingerDrops[fingerId] = nil
        end
    else
        TriggerClientEvent('QBCore:Notify', src, "Je hebt geen leeg bewijszakje bij je!", "error")
    end
end)

RegisterServerEvent('evidence:server:CreateCasing')
AddEventHandler('evidence:server:CreateCasing', function(weapon, coords)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local casingId = CreateCasingId()
    local weaponInfo = QBCore.Shared.Weapons[weapon]
    local serieNumber = nil
    if weaponInfo ~= nil then 
        local weaponItem = Player.Functions.GetItemByName(weaponInfo["name"])
        if weaponItem ~= nil then
            if weaponItem.info ~= nil and  weaponItem.info ~= "" then 
                serieNumber = weaponItem.info.serie
            end
        end
    end
    TriggerClientEvent("evidence:client:AddCasing", -1, casingId, weapon, coords, serieNumber)
end)


RegisterServerEvent('police:server:UpdateCurrentCops')
AddEventHandler('police:server:UpdateCurrentCops', function()
    local amount = 0
    for k, v in pairs(QBCore.Functions.GetPlayers()) do
        local Player = QBCore.Functions.GetPlayer(v)
        if Player ~= nil then 
            if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) then
                amount = amount + 1
            end
        end
    end
    TriggerClientEvent("police:SetCopCount", -1, amount)
end)

RegisterServerEvent('evidence:server:ClearCasings')
AddEventHandler('evidence:server:ClearCasings', function(casingList)
    if casingList ~= nil and next(casingList) ~= nil then 
        for k, v in pairs(casingList) do
            TriggerClientEvent("evidence:client:RemoveCasing", -1, v)
            Casings[v] = nil
        end
    end
end)

RegisterServerEvent('evidence:server:AddCasingToInventory')
AddEventHandler('evidence:server:AddCasingToInventory', function(casingId, casingInfo)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player.Functions.RemoveItem("empty_evidence_bag", 1) then
        if Player.Functions.AddItem("filled_evidence_bag", 1, false, casingInfo) then
            TriggerClientEvent("inventory:client:ItemBox", src, QBCore.Shared.Items["filled_evidence_bag"], "add")
            TriggerClientEvent("evidence:client:RemoveCasing", -1, casingId)
            Casings[casingId] = nil
        end
    else
        TriggerClientEvent('QBCore:Notify', src, "Je hebt geen leeg bewijszakje bij je!", "error")
    end
end)

RegisterServerEvent('police:server:showFingerprint')
AddEventHandler('police:server:showFingerprint', function(playerId)
    local src = source
    local Player = QBCore.Functions.GetPlayer(playerId)

    TriggerClientEvent('police:client:showFingerprint', playerId, src)
    TriggerClientEvent('police:client:showFingerprint', src, playerId)
end)

RegisterServerEvent('police:server:showFingerprintId')
AddEventHandler('police:server:showFingerprintId', function(sessionId)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local fid = Player.PlayerData.metadata["fingerprint"]

    TriggerClientEvent('police:client:showFingerprintId', sessionId, fid)
    TriggerClientEvent('police:client:showFingerprintId', src, fid)
end)

RegisterServerEvent('police:server:SetTracker')
AddEventHandler('police:server:SetTracker', function(targetId)
    local Target = QBCore.Functions.GetPlayer(targetId)
    local TrackerMeta = Target.PlayerData.metadata["tracker"]

    if TrackerMeta then
        Target.Functions.SetMetaData("tracker", false)
        TriggerClientEvent('QBCore:Notify', targetId, 'Je enkelband is afgedaan!', 'error', 5000)
        TriggerClientEvent('QBCore:Notify', source, 'Je hebt de enkelband afgedaan van '..Target.PlayerData.charinfo.firstname.." "..Target.PlayerData.charinfo.lastname, 'error', 5000)
        TriggerClientEvent('police:client:SetTracker', targetId, false)
    else
        Target.Functions.SetMetaData("tracker", true)
        TriggerClientEvent('QBCore:Notify', targetId, 'Je hebt een enkelband omgekregen.', 'error', 5000)
        TriggerClientEvent('QBCore:Notify', source, 'Je hebt een enkelband omgedaan bij '..Target.PlayerData.charinfo.firstname.." "..Target.PlayerData.charinfo.lastname, 'error', 5000)
        TriggerClientEvent('police:client:SetTracker', targetId, true)
    end
end)

RegisterServerEvent('police:server:SendTrackerLocation')
AddEventHandler('police:server:SendTrackerLocation', function(coords, requestId)
    local Target = QBCore.Functions.GetPlayer(source)
    local TrackerMeta = Target.PlayerData.metadata["tracker"]

    local msg = "De locatie van "..Target.PlayerData.charinfo.firstname.." "..Target.PlayerData.charinfo.lastname.." is gemarkeerd op de kaart."

    local alertData = {
        title = "Enkelband Locatie",
        coords = {x = coords.x, y = coords.y, z = coords.z},
        description = msg
    }

    TriggerClientEvent("police:client:TrackerMessage", requestId, msg, coords)
    TriggerClientEvent("qb-phone:client:addPoliceAlert", requestId, alertData)
end)

RegisterServerEvent('police:server:SendPoliceEmergencyAlert')
AddEventHandler('police:server:SendPoliceEmergencyAlert', function(streetLabel, coords, callsign)
    local alertData = {
        title = "Assistentie Collega",
        coords = {x = coords.x, y = coords.y, z = coords.z},
        description = "Noodknop ingedrukt door de ".. callsign .. " bij "..streetLabel,
    }
    TriggerClientEvent("police:client:PoliceEmergencyAlert", -1, callsign, streetLabel, coords)
    TriggerClientEvent("qb-phone:client:addPoliceAlert", -1, alertData)
end)

local Player = QBCore.Functions.GetPlayer(source)

RegisterServerEvent('police:server:verstuurHeliWaarschuwing')
AddEventHandler('police:server:verstuurHeliWaarschuwing', function()
    TriggerClientEvent("police:client:ontvangHeliMelding", -1)
end)

QBCore.Functions.CreateCallback('police:server:isPlayerDead', function(source, cb, playerId)
    local Player = QBCore.Functions.GetPlayer(playerId)
    cb(Player.PlayerData.metadata["isdead"])
end)

QBCore.Functions.CreateCallback('police:GetPlayerStatus', function(source, cb, playerId)
    local Player = QBCore.Functions.GetPlayer(playerId)
    local statList = {}
	if Player ~= nil then
        if PlayerStatus[Player.PlayerData.source] ~= nil and next(PlayerStatus[Player.PlayerData.source]) ~= nil then
            for k, v in pairs(PlayerStatus[Player.PlayerData.source]) do
                table.insert(statList, PlayerStatus[Player.PlayerData.source][k].text)
            end
        end
	end
    cb(statList)
end)

QBCore.Functions.CreateCallback('police:IsSilencedWeapon', function(source, cb, weapon)
    local Player = QBCore.Functions.GetPlayer(source)
    local itemInfo = Player.Functions.GetItemByName(QBCore.Shared.Weapons[weapon]["name"])
    local retval = false
    if itemInfo ~= nil then 
        if itemInfo.info ~= nil and itemInfo.info.attachments ~= nil then 
            for k, v in pairs(itemInfo.info.attachments) do
                if itemInfo.info.attachments[k].component == "COMPONENT_AT_AR_SUPP_02" or itemInfo.info.attachments[k].component == "COMPONENT_AT_AR_SUPP" or itemInfo.info.attachments[k].component == "COMPONENT_AT_PI_SUPP_02" or itemInfo.info.attachments[k].component == "COMPONENT_AT_PI_SUPP" then
                    retval = true
                end
            end
        end
    end
    cb(retval)
end)

QBCore.Functions.CreateCallback('police:GetDutyPlayers', function(source, cb)
    local dutyPlayers = {}
    for k, v in pairs(QBCore.Functions.GetPlayers()) do
        local Player = QBCore.Functions.GetPlayer(v)
        if Player ~= nil then 
            if ((Player.PlayerData.job.name == "police" or Player.PlayerData.job.name == "ambulance") and Player.PlayerData.job.onduty) then
                table.insert(dutyPlayers, {
                    source = Player.PlayerData.source,
                    label = Player.PlayerData.metadata["callsign"],
                    job = Player.PlayerData.job.name,
                })
            end
        end
    end
    cb(dutyPlayers)
end)

function CreateBloodId()
    if BloodDrops ~= nil then
		local bloodId = math.random(10000, 99999)
		while BloodDrops[caseId] ~= nil do
			bloodId = math.random(10000, 99999)
		end
		return bloodId
	else
		local bloodId = math.random(10000, 99999)
		return bloodId
	end
end

function CreateFingerId()
    if FingerDrops ~= nil then
		local fingerId = math.random(10000, 99999)
		while FingerDrops[caseId] ~= nil do
			fingerId = math.random(10000, 99999)
		end
		return fingerId
	else
		local fingerId = math.random(10000, 99999)
		return fingerId
	end
end

function CreateCasingId()
    if Casings ~= nil then
		local caseId = math.random(10000, 99999)
		while Casings[caseId] ~= nil do
			caseId = math.random(10000, 99999)
		end
		return caseId
	else
		local caseId = math.random(10000, 99999)
		return caseId
	end
end

function CreateObjectId()
    if Objects ~= nil then
		local objectId = math.random(10000, 99999)
		while Objects[caseId] ~= nil do
			objectId = math.random(10000, 99999)
		end
		return objectId
	else
		local objectId = math.random(10000, 99999)
		return objectId
	end
end

function IsVehicleOwned(plate)
    local val = false
	QBCore.Functions.ExecuteSql(true, "SELECT * FROM `player_vehicles` WHERE `plate` = '"..plate.."'", function(result)
		if (result[1] ~= nil) then
			val = true
		else
			val = false
		end
	end)
	return val
end

QBCore.Functions.CreateCallback('police:GetImpoundedVehicles', function(source, cb)
    local vehicles = {}
    exports['ghmattimysql']:execute('SELECT * FROM player_vehicles WHERE state = @state', {['@state'] = 2}, function(result)
        if result[1] ~= nil then
            vehicles = result
        end
        cb(vehicles)
    end)
end)

QBCore.Functions.CreateCallback('police:IsPlateFlagged', function(source, cb, plate)
    local retval = false
    if Plates ~= nil and Plates[plate] ~= nil then
        if Plates[plate].isflagged then
            retval = true
        end
    end
    cb(retval)
end)

QBCore.Functions.CreateCallback('police:GetCops', function(source, cb)
    local amount = 0
    
    for k, v in pairs(QBCore.Functions.GetPlayers()) do
        local Player = QBCore.Functions.GetPlayer(v)
        if Player ~= nil then 
            if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) then
                amount = amount + 1
            end
        end
    end
	cb(amount)
end)

QBCore.Commands.Add("setpolice", "Maakt iemand een politiemedewerker.", {{name="id", help="ID"}}, true, function(source, args)
    local Player = QBCore.Functions.GetPlayer(tonumber(args[1]))
    local Myself = QBCore.Functions.GetPlayer(source)
    if Player ~= nil then 
        if (Myself.PlayerData.job.name == "police" and Myself.PlayerData.job.onduty) and IsHighCommand(Myself.PlayerData.citizenid) then
            Player.Functions.SetJob("police")
        end
    end
end)

QBCore.Commands.Add("spijkermat", "Plaatst een spijkermat.", {}, false, function(source, args)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player ~= nil then 
        if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) then
            TriggerClientEvent('police:client:SpawnSpikeStrip', source)
        end
    end
end)


QBCore.Commands.Add("kickpolice", "Ontslaat een politiemedewerker.", {{name="id", help="ID"}}, true, function(source, args)
    local Player = QBCore.Functions.GetPlayer(tonumber(args[1]))
    local Myself = QBCore.Functions.GetPlayer(source)
    if Player ~= nil then 
        if (Myself.PlayerData.job.name == "police" and Myself.PlayerData.job.onduty) and IsHighCommand(Myself.PlayerData.citizenid) then
            Player.Functions.SetJob("unemployed")
        end
    end
end)

function IsHighCommand(citizenid)
    local retval = false
    for k, v in pairs(Config.ArmoryWhitelist) do
        if v == citizenid then
            retval = true
        end
    end
    return retval
end

QBCore.Commands.Add("pobject", "Plaatst en/of verwijderd een object.", {{name="type", help="object"}}, true, function(source, args)
    local Player = QBCore.Functions.GetPlayer(source)
    local type = args[1]:lower()
    if Player.PlayerData.job.name == "police" then
        if type == "pion" then
            TriggerClientEvent("police:client:spawnCone", source)
        elseif type == "barier" then
            TriggerClientEvent("police:client:spawnBarier", source)
        elseif type == "schotten" then
            TriggerClientEvent("police:client:spawnSchotten", source)
        elseif type == "tent" then
            TriggerClientEvent("police:client:spawnTent", source)
        elseif type == "light" then
            TriggerClientEvent("police:client:spawnLight", source)
        elseif type == "delete" then
            TriggerClientEvent("police:client:deleteObject", source)
        end
    else
        TriggerClientEvent('chatMessage', source, "SYSTEEM", "error", "Dit commando is voor hulpdiensten!")
    end
end)

QBCore.Commands.Add("cuff", "Boeit de dichtsbijzijnde speler", {}, false, function(source, args)
	local Player = QBCore.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == "police" then
        TriggerClientEvent("police:client:CuffPlayer", source)
    else
        TriggerClientEvent('chatMessage', source, "SYSTEEM", "error", "Dit commando is voor hulpdiensten!")
    end
end)

QBCore.Commands.Add("palert", "Maakt een melding voor de politie.", {{name="alert", help="De melding die je wilt maken."}}, false, function(source, args)
    local Player = QBCore.Functions.GetPlayer(source)
    
    if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) then
        if args[1] ~= nil then
            local msg = table.concat(args, " ")
            TriggerClientEvent("chatMessage", -1, "POLITIE MELDING", "error", msg)
            TriggerEvent("qb-log:server:CreateLog", "112", "Politie Melding", "blue", "**"..GetPlayerName(source).."** (CitizenID: "..Player.PlayerData.citizenid.." | ID: "..source..") **Alert:** " ..msg, false)
            TriggerClientEvent('police:PlaySound', -1)
        else
            TriggerClientEvent('chatMessage', source, "SYSTEEM", "error", "Je hebt geen meldingbeschrijving gemaakt!")
        end
    else
        TriggerClientEvent('chatMessage', source, "SYSTEEM", "error", "Dit commando is voor hulpdiensten!")
    end
end)

QBCore.Commands.Add("escort", "Escort a person", {}, false, function(source, args)
	local Player = QBCore.Functions.GetPlayer(source)
    TriggerClientEvent("police:client:EscortPlayer", source)
end)

QBCore.Commands.Add("databank", "Activeert de politie databank.", {}, false, function(source, args)
	local Player = QBCore.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == "police" then
        TriggerClientEvent("police:client:toggleDatabank", source)
    else
        TriggerClientEvent('chatMessage', source, "SYSTEEM", "error", "Dit commando is voor hulpdiensten!")
    end
end)

QBCore.Commands.Add("roepnummer", "Verandert je roepnummer.", {{name="roepnummer", help="Je roepnummer, bijv [10-91]"}}, false, function(source, args)
	local Player = QBCore.Functions.GetPlayer(source)
    Player.Functions.SetMetaData("callsign", table.concat(args, " "))
    local roepnummertje = table.concat(args, " ")
    TriggerClientEvent('QBCore:Notify', source, "Je roepnummer is: "..roepnummertje, "success")
end)


QBCore.Commands.Add("verwijdercasings", "Haalt alle kogelhulzen weg, pak de nuttige eerst op!", {}, false, function(source, args)
	local Player = QBCore.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == "police" then
        TriggerClientEvent("evidence:client:ClearCasingsInArea", source)
    else
        TriggerClientEvent('chatMessage', source, "SYSTEEM", "error", "Dit commando is voor hulpdiensten!")
    end
end)

-- QBCore.Commands.Add("jail", "Stuurt een persoon naar de gevangenis.", {{name="id", help="ID"},{name="time", help="Tijd dat ze mogen rotten, in maanden."}}, true, function(source, args)
-- 	local Player = QBCore.Functions.GetPlayer(source)
--     if Player.PlayerData.job.name == "police" then
--         local playerId = tonumber(args[1])
--         local time = tonumber(args[2])
--         if time > 0 then
--             TriggerClientEvent("police:client:JailCommand", source, playerId, time)
--         else
--             TriggerClientEvent('chatMessage', source, "SYSTEEM", "error", "Tijd moet meer dan 0 maanden zijn.")
--         end
--     else
--         TriggerClientEvent('chatMessage', source, "SYSTEEM", "error", "Dit commando is voor hulpdiensten!")
--     end
-- end)

-- QBCore.Commands.Add("unjail", "Haalt een persoon uit de gevangenis.", {{name="id", help="ID"}}, true, function(source, args)
-- 	local Player = QBCore.Functions.GetPlayer(source)
--     if Player.PlayerData.job.name == "police" then
--         local playerId = tonumber(args[1])
--         TriggerClientEvent("prison:client:UnjailPerson", playerId)
--     else
--         TriggerClientEvent('chatMessage', source, "SYSTEEM", "error", "Dit commando is voor hulpdiensten!")
--     end
-- end)

QBCore.Commands.Add("verwijderbloed", "Haalt alle bloedsporen in de omgeving weg, pak eerst de nuttige sporen op!", {}, false, function(source, args)
	local Player = QBCore.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == "police" then
        TriggerClientEvent("evidence:client:ClearBlooddropsInArea", source)
    else
        TriggerClientEvent('chatMessage', source, "SYSTEEM", "error", "Dit commando is voor hulpdiensten!")
    end
end)

QBCore.Commands.Add("neemgeld", "Neemt al het geld van de dichtsbijzijnde persoon in beslag.", {}, false, function(source, args)
	local Player = QBCore.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty then
        TriggerClientEvent("police:client:SeizeCash", source)
    else
        TriggerClientEvent('chatMessage', source, "SYSTEEM", "error", "Dit commando is voor hulpdiensten!")
    end
end)

QBCore.Commands.Add("cam", "Bekijk een beveiligingscamera", {{name="camid", help="Camera ID"}}, false, function(source, args)
	local Player = QBCore.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == "police" then
        TriggerClientEvent("police:client:ActiveCamera", source, tonumber(args[1]))
    else
        TriggerClientEvent('chatMessage', source, "SYSTEEM", "error", "Dit commando is voor hulpdiensten!")
    end
end)

QBCore.Commands.Add("markeer", "Signaleer een voertuig.", {{name="plate", help="Kentekenplaat"}, {name="reason", help="Reden van het signaleren van het voertuig."}}, true, function(source, args)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if Player.PlayerData.job.name == "police" then
        local reason = {}
        for i = 2, #args, 1 do
            table.insert(reason, args[i])
        end
        Plates[args[1]:upper()] = {
            isflagged = true,
            reason = table.concat(reason, " ")
        }
        TriggerClientEvent('QBCore:Notify', src, "Kentekenplaat ("..args[1]:upper()..") is gesignaleerd voor: "..table.concat(reason, " "))
    else
        TriggerClientEvent('chatMessage', src, "SYSTEEM", "error", "Dit commando is voor hulpdiensten!")
    end
end)

QBCore.Commands.Add("onmarkeer", "Verwijderd de signalering van een voertuig.", {{name="plate", help="Kentekenplaat"}}, true, function(source, args)
	local Player = QBCore.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == "police" then
        if Plates ~= nil and Plates[args[1]:upper()] ~= nil then
            if Plates[args[1]:upper()].isflagged then
                Plates[args[1]:upper()].isflagged = false
                TriggerClientEvent('QBCore:Notify', source, "Het signalement van ("..args[1]:upper()..") is succesvol verwijderd!")
            else
                TriggerClientEvent('chatMessage', source, "SYSTEEM", "error", "Voertuig staat niet gesignaleerd!")
            end
        else
            TriggerClientEvent('chatMessage', source, "SYSTEEM", "error", "Voertuig staat niet gesignaleerd!")
        end
    else
        TriggerClientEvent('chatMessage', source, "SYSTEEM", "error", "Dit commando is voor hulpdiensten!")
    end
end)

QBCore.Commands.Add("plateinfo", "Plaatst een signalering op een voertuig.", {{name="plate", help="Kentekenplaat"}}, true, function(source, args)
	local Player = QBCore.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == "police" then
        if Plates ~= nil and Plates[args[1]:upper()] ~= nil then
            if Plates[args[1]:upper()].isflagged then
                TriggerClientEvent('chatMessage', source, "Meldkamer", "normal", "Het voertuig ("..args[1]:upper()..") is gesignaleerd voor: "..Plates[args[1]:upper()].reason)
            else
                TriggerClientEvent('chatMessage', source, "SYSTEEM", "error", "Voertuig is niet gemarkeerd!")
            end
        else
            TriggerClientEvent('chatMessage', source, "SYSTEEM", "error", "Voertuig is niet gemarkeerd!")
        end
    else
        TriggerClientEvent('chatMessage', source, "SYSTEEM", "error", "Dit commando is voor hulpdiensten!")
    end
end)

QBCore.Commands.Add("depot", "Stuurt een voertuig naar de impound.", {{name="prijs", help="De prijs om hem weer uit de impound te halen."}}, false, function(source, args)
	local Player = QBCore.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == "police" or Player.PlayerData.job.name == "mechanic" then
        local aantalANWB = GetCurrentANWB()
        if Player.PlayerData.job.name ~= "mechanic" then
            if aantalANWB < 1 then
                TriggerClientEvent("police:client:ImpoundVehicle", source, false, tonumber(args[1]))
            else
                TriggerClientEvent('QBCore:Notify', source, "Er is genoeg ANWB in dienst, bel de ANWB!", "error")
            end
        else
            TriggerClientEvent("police:client:ImpoundVehicle", source, false, tonumber(args[1]))
        end
    else
        TriggerClientEvent('chatMessage', source, "SYSTEEM", "error", "Dit commando is voor hulpdiensten!")
    end
end)

QBCore.Commands.Add("impound", "Neemt een voertuig in beslag.", {}, false, function(source, args)
	local Player = QBCore.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == "police" then
        TriggerClientEvent("police:client:ImpoundVehicle", source, true)
    else
        TriggerClientEvent('chatMessage', source, "SYSTEEM", "error", "Dit commando is voor hulpdiensten!")
    end
end)

QBCore.Commands.Add("betaaltow", "Betaalt een bergnet medewerker.", {{name="id", help="Speler ID"}}, true, function(source, args)
	local Player = QBCore.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == "police" or Player.PlayerData.job.name == "ambulance" then
        local playerId = tonumber(args[1])
        local OtherPlayer = QBCore.Functions.GetPlayer(playerId)
        if OtherPlayer ~= nil then
            if OtherPlayer.PlayerData.job.name == "tow" then
                OtherPlayer.Functions.AddMoney("bank", 500, "police-tow-paid")
                TriggerClientEvent('chatMessage', OtherPlayer.PlayerData.source, "SYSTEEM", "warning", "Je hebt 500 euro ontvangen voor je werk!")
                TriggerClientEvent('QBCore:Notify', source, 'Je hebt de bergnet medewerker betaald')
            else
                TriggerClientEvent('QBCore:Notify', source, 'Persoon is geen bergnet medewerker.', "error")
            end
        end
    else
        TriggerClientEvent('chatMessage', source, "SYSTEEM", "error", "Dit commando is voor hulpdiensten!")
    end
end)

QBCore.Commands.Add("betaaladvocaat", "Betaalt een advocaat 1000 euro.", {{name="id", help="Speler ID"}}, true, function(source, args)
	local Player = QBCore.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == "police" or Player.PlayerData.job.name == "judge" then
        local playerId = tonumber(args[1])
        local OtherPlayer = QBCore.Functions.GetPlayer(playerId)
        if OtherPlayer ~= nil then
            if OtherPlayer.PlayerData.job.name == "lawyer" then
                OtherPlayer.Functions.AddMoney("bank", 1000, "police-lawyer-paid")
                TriggerClientEvent('chatMessage', OtherPlayer.PlayerData.source, "SYSTEEM", "warning", "Je hebt 1000 euro ontvangen voor je werk!")
                TriggerClientEvent('QBCore:Notify', source, 'Je hebt een advocaat betaald!')
            else
                TriggerClientEvent('QBCore:Notify', source, 'Persoon is geen advocaat!', "error")
            end
        end
    else
        TriggerClientEvent('chatMessage', source, "SYSTEEM", "error", "Dit commando is voor hulpdiensten!")
    end
end)

QBCore.Commands.Add("radar", "Zet de politieradar aan.", {}, false, function(source, args)
	local Player = QBCore.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == "police" then
        TriggerClientEvent("wk:toggleRadar", source)
    else
        TriggerClientEvent('chatMessage', source, "SYSTEEM", "error", "Dit commando is voor hulpdiensten!")
    end
end)

QBCore.Functions.CreateUseableItem("handcuffs", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent("police:client:CuffPlayerSoft", source)
    end
end)

-- QBCore.Commands.Add("112", "Maakt een 112 melding inclusief locatie voor de hulpdiensten.", {{name="message", help="Meldingomschrijving"}}, true, function(source, args)
--     local message = table.concat(args, " ")
--     local Player = QBCore.Functions.GetPlayer(source)

--     if Player.Functions.GetItemByName("phone") ~= nil then
--         TriggerClientEvent("police:client:SendEmergencyMessage", source, message)
--         TriggerEvent("qb-log:server:CreateLog", "112", "112 Melding", "blue", "**"..GetPlayerName(source).."** (CitizenID: "..Player.PlayerData.citizenid.." | ID: "..source..") **Melding:** " ..message, false)
--     else
--         TriggerClientEvent('QBCore:Notify', source, 'Je hebt geen telefoon!', 'error')
--     end
-- end)

-- QBCore.Commands.Add("112a", "Maakt een anonieme 112 melding zonder locatie.", {{name="message", help="Meldingomschrijving"}}, true, function(source, args)
--     local message = table.concat(args, " ")
--     local Player = QBCore.Functions.GetPlayer(source)

--     if Player.Functions.GetItemByName("phone") ~= nil then
--         TriggerClientEvent("police:client:CallAnim", source)
--         TriggerClientEvent('police:client:Send112AMessage', -1, message)
--     else
--         TriggerClientEvent('QBCore:Notify', source, 'Je hebt geen telefoon!', 'error')
--     end
-- end)

-- QBCore.Commands.Add("112r", "Reageert op een 112 melding.", {{name="id", help="ID"}, {name="bericht", help="Bericht"}}, true, function(source, args)
--     local Player = QBCore.Functions.GetPlayer(source)
--     local OtherPlayer = QBCore.Functions.GetPlayer(tonumber(args[1]))
--     table.remove(args, 1)
--     local message = table.concat(args, " ")
--     local Prefix = "POLICE"
--     if (Player.PlayerData.job.name == "ambulance" or Player.PlayerData.job.name == "doctor") then
--         Prefix = "AMBULANCE"
--     end
--     if OtherPlayer ~= nil then 
--         TriggerClientEvent('chatMessage', OtherPlayer.PlayerData.source, "("..Prefix..") " ..Player.PlayerData.charinfo.firstname .. " " .. Player.PlayerData.charinfo.lastname, "error", message)
--         TriggerClientEvent("police:client:EmergencySound", OtherPlayer.PlayerData.source)
--         TriggerClientEvent("police:client:CallAnim", source)
--     end
-- end)

QBCore.Commands.Add("enkelband", "Doet een enkelband om bij de dichtsbijzijnde speler.", {}, false, function(source, args)
    local Player = QBCore.Functions.GetPlayer(source)

    if Player.PlayerData.job.name == "police" then
        TriggerClientEvent("police:client:CheckDistance", source)
    else
        TriggerClientEvent('chatMessage', source, "SYSTEEM", "error", "Dit commando is voor hulpdiensten!")
    end
end)

QBCore.Commands.Add("enkelbandlocatie", "Verwijderd de enkelband van het ingevoerde BSN.", {{"bsn", "BSN"}}, true, function(source, args)
    local Player = QBCore.Functions.GetPlayer(source)
    
    if Player.PlayerData.job.name == "police" then
        if args[1] ~= nil then
            local citizenid = args[1]
            local Target = QBCore.Functions.GetPlayerByCitizenId(citizenid)

            if Target ~= nil then
                if Target.PlayerData.metadata["tracker"] then
                    TriggerClientEvent("police:client:SendTrackerLocation", Target.PlayerData.source, source)
                else
                    TriggerClientEvent('QBCore:Notify', source, 'Deze persoon heeft geen enkelband om!', 'error')
                end
            end
        end
    else
        TriggerClientEvent('chatMessage', source, "SYSTEEM", "error", "Dit commando is voor hulpdiensten!")
    end
end)

QBCore.Commands.Add("noodknop", "Drukt de noodknop in voor alle collega's.", {}, false, function(source, args)
    local Player = QBCore.Functions.GetPlayer(source)
    if ((Player.PlayerData.job.name == "police") and Player.PlayerData.job.onduty) then
        TriggerClientEvent("police:client:SendPoliceEmergencyAlert", source)
    end
end)

QBCore.Commands.Add("neemdna", "Pakt de DNA code van het ingevoerde ID.", {{"id", "ID"}}, true, function(source, args)
    local Player = QBCore.Functions.GetPlayer(source)
    local OtherPlayer = QBCore.Functions.GetPlayer(tonumber(args[1]))
    if ((Player.PlayerData.job.name == "police") and Player.PlayerData.job.onduty) and OtherPlayer ~= nil then
        if Player.Functions.RemoveItem("empty_evidence_bag", 1) then
            local info = {
                label = "DNA Voorbeeld",
                type = "dna",
                dnalabel = DnaHash(OtherPlayer.PlayerData.citizenid),
            }
            if Player.Functions.AddItem("filled_evidence_bag", 1, false, info) then
                TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items["filled_evidence_bag"], "add")
            end
        else
            TriggerClientEvent('QBCore:Notify', source, "Je hebt geen leeg bewijszakje!", "error")
        end
    end
end)

QBCore.Functions.CreateUseableItem("moneybag", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        if item.info ~= nil and item.info ~= "" then
            if Player.PlayerData.job.name ~= "police" then
                if Player.Functions.RemoveItem("moneybag", 1, item.slot) then
                    Player.Functions.AddMoney("cash", tonumber(item.info.cash), "used-moneybag")
                end
            end
        end
    end
end)

function GetCurrentCops()
    local amount = 0
    for k, v in pairs(QBCore.Functions.GetPlayers()) do
        local Player = QBCore.Functions.GetPlayer(v)
        if Player ~= nil then 
            if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) then
                amount = amount + 1
            end
        end
    end
    return amount
end

QBCore.Functions.CreateCallback('police:server:IsPoliceForcePresent', function(source, cb)
    local retval = false
    for k, v in pairs(QBCore.Functions.GetPlayers()) do
        local Player = QBCore.Functions.GetPlayer(v)
        if Player ~= nil then 
            for _, citizenid in pairs(Config.ArmoryWhitelist) do
                if citizenid == Player.PlayerData.citizenid then
                    retval = true
                    break
                end
            end
        end
    end
    cb(retval)
end)

QBCore.Functions.CreateCallback('police:server:HasPoliceJob', function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
	if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) then
		cb(true)
	else
		cb(false)
	end
end)

function DnaHash(s)
    local h = string.gsub(s, ".", function(c)
		return string.format("%02x", string.byte(c))
	end)
    return h
end

RegisterServerEvent('police:server:SyncSpikes')
AddEventHandler('police:server:SyncSpikes', function(table)
    TriggerClientEvent('police:client:SyncSpikes', -1, table)
end)

local agentoverval = false


-- Agent overval scoreboard systeempje
QBCore.Commands.Add("agentoverval", "Zet de timer van agent overval voor 2 uur op pauze.", {}, false, function(source, args)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty then
        if not agentoverval then
            TriggerEvent("qb-scoreboard:server:SetActivityBusy", "agent", true)
            TriggerEvent("qb-scoreboard:server:agentOvervalTimer")
            TriggerClientEvent('QBCore:Notify', source, "Je hebt de timer gestart, deze timer loopt 2 uur!", "success")
            agentoverval = true
        else
            TriggerClientEvent('QBCore:Notify', source, "Er staat al een timer aan!", "error")
        end
    else
        TriggerClientEvent('QBCore:Notify', source, "Dit commando is alleen voor hulpdiensten!", "error")
    end
end)

RegisterServerEvent("police:server:stopAgentovervalTimer")
AddEventHandler("police:server:stopAgentovervalTimer", function()
    agentoverval = false
end)

RegisterServerEvent('ZoneActivated')
AddEventHandler('ZoneActivated', function(speed, radius, x, y, z)
    TriggerClientEvent('Zone', -1, speed, radius, x, y, z)
end)

RegisterServerEvent('Disable')
AddEventHandler('Disable', function(blip)
    TriggerClientEvent('RemoveBlip', -1)
end)

function GetCurrentANWB()
    local anwb = 0
    for k, v in pairs(QBCore.Functions.GetPlayers()) do
        local Player = QBCore.Functions.GetPlayer(v)
        if Player ~= nil then 
            if (Player.PlayerData.job.name == "mechanic" and Player.PlayerData.job.onduty) then
                anwb = anwb + 1
            end
        end
    end
    return anwb
end

QBCore.Functions.CreateCallback("police:server:checkAnwb", function(source, cb)
    local anwb = 0
    for k, v in pairs(QBCore.Functions.GetPlayers()) do
        local Player = QBCore.Functions.GetPlayer(v)
        if Player ~= nil then 
            if Player.PlayerData.job.name == "mechanic" and Player.PlayerData.job.onduty == true then
                anwb = anwb + 1
            end
        end
    end
    cb(anwb)
end) 