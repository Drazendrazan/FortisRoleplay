QBCore = nil

Citizen.CreateThread(function() 
    if QBCore == nil then
        TriggerEvent("QBCore:GetObject", function(obj) QBCore = obj end)    
        Citizen.Wait(200)
    end
    PlayerData = QBCore.Functions.GetPlayerData()
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    isLoggedIn = true
    PlayerData = QBCore.Functions.GetPlayerData()
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate')
AddEventHandler('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerData.job = JobInfo
end)

portofoonOudeFrequentie = 0
portofoonFrequentie = 0
portofoonNaam = nil
portofoonProp = nil
portoPenisProp = nil

RegisterNetEvent("fortis-radio:client:openRadio")
AddEventHandler("fortis-radio:client:openRadio", function()
    SendNUIMessage({
        type = "open"
    })
    SetNuiFocus(true, true)

    local modelProp = GetHashKey('prop_cs_hand_radio')
    RequestModel(modelProp)

    while not HasModelLoaded(modelProp) do
        Citizen.Wait(150)
    end

    loadAnimDict("cellphone@")

    local Handle = CreateObject(modelProp, 0.0, 0.0, 0.0, true, true, false)

    local bone = GetPedBoneIndex(GetPlayerPed(-1), 28422)
    local unarmed = GetHashKey('weapon_unarmed')
    local offset = vector3(0.0, 0.0, 0.0)
    SetCurrentPedWeapon(GetPlayerPed(-1), unarmed, true)
    portofoonProp = AttachEntityToEntity(Handle, GetPlayerPed(-1), bone, offset.x, offset.y, offset.z, offset.x, offset.y, offset.z, true, false, false, false, 2, true)
    portoPenisProp = Handle

    SetModelAsNoLongerNeeded(Handle)

    TaskPlayAnim(GetPlayerPed(-1), "cellphone@", "cellphone_text_in", 4.0, -1, -1, 50, 0, false, false, false)
end)

RegisterNUICallback("sluit", function()
    SetNuiFocus(false, false)
    StopAnimTask(GetPlayerPed(-1), "cellphone@", "cellphone_text_in", 1.0)
    -- DetachEntity(portofoonProp, true, false)
    -- DeleteEntity(portofoonProp)
    -- print("dikke vette akkelow!")
    -- Citizen.InvokeNative(0xAE3CBE5BF394C9C9 , Citizen.PointerValueIntInitialized(portofoonProp))
    DeleteEntity(portoPenisProp)
    portofoonProp = nil
    ClearPedTasks(GetPlayerPed(-1))
end)

RegisterNUICallback("verbind", function(data)
    local frequentie = tonumber(data.frequentie)
    if frequentie >= 1 and frequentie <= 1000 and frequentie ~= portofoonFrequentie then
        QBCore.Functions.TriggerCallback("fortis-radio:server:checkRadioFrequentie", function(resultaat)
            if resultaat then
                exports["pma-voice"]:setVoiceProperty("radioEnabled", true)
                exports["pma-voice"]:setRadioChannel(frequentie)
                TriggerServerEvent("fortis-radio:server:verbindFrequentie", frequentie, data.naam, portofoonOudeFrequentie)
                portofoonFrequentie = frequentie
                portofoonOudeFrequentie = frequentie
                portofoonNaam = data.naam
            else
                QBCore.Functions.Notify("Je bent niet toegestaan deze frequentie te joinen!", "error")
            end
        end, frequentie)
    else
        QBCore.Functions.Notify("Ongeldige radio frequentie!", "error")
    end
end)

RegisterNUICallback("verbreek", function() 
    exports["pma-voice"]:removePlayerFromRadio()
    TriggerServerEvent("fortis-radio:server:verbreekFrequentie", portofoonFrequentie)
    SendNUIMessage({
        type = "verbreek"
    })
    portofoonFrequentie = 0
    portofoonOudeFrequentie = 0
    -- exports["pma-voice"]:setVoiceProperty("radioEnabled", false)
end)

RegisterNetEvent("qb-radio:onRadioDrop")
AddEventHandler("qb-radio:onRadioDrop", function()
    exports["pma-voice"]:removePlayerFromRadio()
    TriggerServerEvent("fortis-radio:server:verbreekFrequentie", portofoonFrequentie)
    SendNUIMessage({
        type = "verbreek"
    })
    portofoonFrequentie = 0
end)

RegisterNUICallback("ongeldig", function()
    QBCore.Functions.Notify("Ongeldige frequentie of je hebt geen naam ingevuld!", "error")
end)

RegisterNetEvent('qb-radio:onRadioDrop')
AddEventHandler('qb-radio:onRadioDrop', function()
    TriggerServerEvent("fortis-radio:server:verbreekFrequentie", portofoonFrequentie)
    SendNUIMessage({
        type = "verbreek"
    })
    portofoonFrequentie = 0
    exports["pma-voice"]:removePlayerFromRadio()
end)


RegisterNetEvent("fortis-radio:client:refreshLijst")
AddEventHandler("fortis-radio:client:refreshLijst", function(frequentie, lijst)
    if frequentie == portofoonFrequentie and frequentie ~= 0 then
        local kaas = {}
        table.insert(kaas, lijst)
        SendNUIMessage({
            type = "updateLijst",
            lijst = kaas
        })
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        while PlayerData == nil do Wait(500) end
        while PlayerData.job == nil do Wait(500) end

        if PlayerData.job.name == "police" or PlayerData.job.name == "ambulance" then
            if portofoonFrequentie ~= 0 then
                if IsControlJustPressed(0, 208) then -- Page up, kanaal omhoog
                    local frequentie = portofoonFrequentie + 1
                    if frequentie >= 1 and frequentie <= 1000 then
                        QBCore.Functions.TriggerCallback("fortis-radio:server:checkRadioFrequentie", function(resultaat)
                            if resultaat then
                                exports["pma-voice"]:setVoiceProperty("radioEnabled", true)
                                exports["pma-voice"]:setRadioChannel(frequentie)
                                TriggerServerEvent("fortis-radio:server:verbindFrequentie", frequentie, portofoonNaam, portofoonOudeFrequentie)
                                portofoonFrequentie = frequentie
                                portofoonOudeFrequentie = frequentie
                            else
                                QBCore.Functions.Notify("Je bent niet toegestaan deze frequentie te joinen!", "error")
                            end
                        end, frequentie)
                    else
                        QBCore.Functions.Notify("Er zijn geen kanalen meer boven het kanaal waar jij in zit!", "error")
                    end

                end
                if IsControlJustPressed(0, 207) then -- Page down, kanaal omlaag
                    local frequentie = portofoonFrequentie - 1
                    if frequentie >= 1 and frequentie <= 1000 then
                        QBCore.Functions.TriggerCallback("fortis-radio:server:checkRadioFrequentie", function(resultaat)
                            if resultaat then
                                exports["pma-voice"]:setVoiceProperty("radioEnabled", true)
                                exports["pma-voice"]:setRadioChannel(frequentie)
                                TriggerServerEvent("fortis-radio:server:verbindFrequentie", frequentie, portofoonNaam, portofoonOudeFrequentie)
                                portofoonFrequentie = frequentie
                                portofoonOudeFrequentie = frequentie
                            else
                                QBCore.Functions.Notify("Je bent niet toegestaan deze frequentie te joinen!", "error")
                            end
                        end, frequentie)
                    else
                        QBCore.Functions.Notify("Er zijn geen kanalen meer onder het kanaal waar jij in zit!", "error")
                    end

                end
            else
                Wait(1000)
            end
        else
            Wait(5000)
        end
    end
end)





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

 function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(5)
    end
end
