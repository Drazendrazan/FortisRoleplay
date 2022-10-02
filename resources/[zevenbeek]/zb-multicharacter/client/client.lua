QBCore = nil
Citizen.CreateThread(function()
    while QBCore == nil do
        TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
        Citizen.Wait(0)
    end
end)

local charPed = nil
local cam = nil

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if NetworkIsSessionStarted() then
			TriggerEvent("zb-multicharacter:client:kiesKarakter")
			return
		end
	end
end)

-- Laad karakters
function getKarakters()
    QBCore.Functions.TriggerCallback("zb-multicharacter:server:getKarakters", function(result)
        SendNUIMessage({
            type = "sendKarakters",
            karakters = result
        })
    end)
end


RegisterNetEvent("zb-multicharacter:client:kiesKarakter")
AddEventHandler("zb-multicharacter:client:kiesKarakter", function()
    if charPed ~= nil then
        DeleteEntity(charPed)
    end
    local interior = GetInteriorAtCoords(8.00, 529.50, 171.50)
    PinInteriorInMemory(interior)
    while not IsInteriorReady(interior) do
        Citizen.Wait(5)
    end
    FreezeEntityPosition(GetPlayerPed(-1), true)
    SetEntityCoords(GetPlayerPed(-1), 3.28, 524.51, 170.50)
    SetEntityInvincible(GetPlayerPed(-1), true)
    SetEntityVisible(GetPlayerPed(-1), false, 0)
    Citizen.Wait(10)
    skyCam(true)
    SendLoadingScreenMessage(json.encode({type = "sluit"}))
    Wait(1500)
    ShutdownLoadingScreenNui()
    SendNUIMessage({
        type = "showLaadscherm"
    })
    TriggerEvent("zb-smallresources:client:geenHPbar")
    SetNuiFocus(true, true)
    NetworkSetTalkerProximity(0.0)
    getKarakters()
end)

function skyCam(bool)
    SetRainFxIntensity(0.0)
    TriggerEvent('qb-weathersync:client:DisableSync')
    SetWeatherTypePersist('EXTRASUNNY')
    SetWeatherTypeNow('EXTRASUNNY')
    SetWeatherTypeNowPersist('EXTRASUNNY')
    NetworkOverrideClockTime(12, 0, 0)

    if bool then
        DoScreenFadeIn(1000)
        SetTimecycleModifier('hud_def_blur')
        SetTimecycleModifierStrength(0.0)
        FreezeEntityPosition(GetPlayerPed(-1), false)
        cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
        SetCamCoord(cam, 8.00, 529.50, 171.00)
        SetCamRot(cam, 0.0, 0.0, 205.0, 2)
        RenderScriptCams(true, true, 1)
    else
        SetTimecycleModifier('default')
        SetCamActive(cam, false)
        DestroyCam(cam, true)
        RenderScriptCams(0, 0, 1, 1, 1)
        FreezeEntityPosition(GetPlayerPed(-1), false)
    end
end

-- Karakter aanklikken (laten aanlopen)
RegisterNUICallback("selectKarakter", function(data)
    if charPed ~= nil then
        SetEntityAsNoLongerNeeded(charPed)
    end

    QBCore.Functions.TriggerCallback("zb-multicharacter:server:getSkin", function(model, data)
        model = model ~= nil and tonumber(model) or false
        if model ~= nil then
            Citizen.CreateThread(function()
                RequestModel(model)
                while not HasModelLoaded(model) do
                    Citizen.Wait(0)
                end
                charPed = CreatePed(2, model, 5.41, 526.71, 170.61, 292.50, false, true)
                SetPedComponentVariation(charPed, 0, 0, 0, 2)
                FreezeEntityPosition(charPed, false)
                SetEntityInvincible(charPed, true)
                PlaceObjectOnGroundProperly(charPed)
                SetBlockingOfNonTemporaryEvents(charPed, true)
                data = json.decode(data)
                TriggerEvent('qb-clothing:client:loadPlayerClothing', data, charPed)
                TaskGoStraightToCoord(charPed, 8.99, 527.52, 170.65, -1, -1, 30.00, -1)
                Wait(3200)
                SendNUIMessage({
                    type = "karakterReadySelected"
                })
            end)
        else
            Citizen.CreateThread(function()
                local randommodels = {
                    "mp_m_freemode_01",
                    "mp_f_freemode_01",
                }
                local model = GetHashKey(randommodels[math.random(1, #randommodels)])
                RequestModel(model)
                while not HasModelLoaded(model) do
                    Citizen.Wait(0)
                end
                charPed = CreatePed(2, model, 5.41, 526.71, 170.61, 292.50, false, true)
                SetPedComponentVariation(charPed, 0, 0, 0, 2)
                FreezeEntityPosition(charPed, false)
                SetEntityInvincible(charPed, true)
                PlaceObjectOnGroundProperly(charPed)
                SetBlockingOfNonTemporaryEvents(charPed, true)
                TaskGoStraightToCoord(charPed, 8.99, 527.52, 170.65, -1, -1, 30.00, -1)
            end)
        end
    end, data.citizenid)
end)

RegisterNUICallback("speelKarakter", function(data)
    SendNUIMessage({
        type = "hide"
    })

    local randomAnimatie = math.random(1, #Config.startAnimaties)
    local randomAnimatie = Config.startAnimaties[randomAnimatie]

    loadAnimDict(randomAnimatie["dict"])
    TaskPlayAnim(charPed, randomAnimatie["dict"], randomAnimatie["anim"], 8.0, 1.0, -1, 2, 0, false, false, false)
    Wait(2000)
    DoScreenFadeOut(200)
    TriggerServerEvent("zb-multicharacter:server:loadUserData", data["data"])
    SetEntityAsMissionEntity(charPed, true, true)
    DeleteEntity(charPed)
    SetNuiFocus(false, false)
    TriggerEvent("zb-hud:client:laadHudZienChar")
    SetEntityInvincible(GetPlayerPed(-1), false)
    FreezeEntityPosition(GetPlayerPed(-1), false)
end)

RegisterNUICallback("maakNieuwKarakter", function(rawData)
    if string.find(rawData["data"].voornaam:lower(), "<script") or string.find(rawData["data"].achternaam:lower(), "<script") then
        TriggerServerEvent("zb-multicharacter:server:banSpelerHacker")
    else
        local tmp_birthdate = rawData["data"].dag .. "-" .. rawData["data"].maand .. "-" .. rawData["data"].jaar
        local cData = {
            ["firstname"] = rawData["data"].voornaam,
            ["lastname"] = rawData["data"].achternaam,
            ["birthdate"] = tmp_birthdate,
            ["nationality"] = rawData["data"].nationaliteit,
            ["gender"] = rawData["data"].geslacht,
            ["new"] = true,
            ["cid"] = 0
        }

        DoScreenFadeOut(150)
        TriggerEvent("zb-hud:client:laadHudZienChar")
        TriggerServerEvent("zb-multicharacter:server:maakNieuwKarakter", cData)
        Citizen.Wait(500)
    end
end)

RegisterNetEvent("zb-multicharacter:client:closeNUI")
AddEventHandler("zb-multicharacter:client:closeNUI", function()
    SetNuiFocus(false, false)
end)


RegisterNUICallback("verwijderKarakter", function(data)
    TriggerServerEvent("zb-multicharacter:server:deleteCharacter", data["data"].citizenid)
end)



-- Losse functies
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