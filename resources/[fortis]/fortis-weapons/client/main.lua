QBCore = nil

local isLoggedIn = true
local CurrentWeaponData = {}
local PlayerData = {}
local CanShoot = true

function DrawText3Ds(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

Citizen.CreateThread(function() 
    while true do
        Citizen.Wait(10)
        if QBCore == nil then
            TriggerEvent("QBCore:GetObject", function(obj) QBCore = obj end)    
            Citizen.Wait(200)
        end
    end
end) 

Citizen.CreateThread(function() 
    while true do
        if isLoggedIn then
            TriggerServerEvent("weapons:server:SaveWeaponAmmo")
        end
        Citizen.Wait(60000)
    end
end)
 
Citizen.CreateThread(function()
    Wait(1000)
    if QBCore.Functions.GetPlayerData() ~= nil then
        TriggerServerEvent("weapons:server:LoadWeaponAmmo")
        isLoggedIn = true
        PlayerData = QBCore.Functions.GetPlayerData()
    end 
end)

local MultiplierAmount = 0

Citizen.CreateThread(function()
    while true do
        if isLoggedIn then
            if CurrentWeaponData and next(CurrentWeaponData) then
                if IsPedShooting(PlayerPedId()) or IsControlJustPressed(0, 24) then
                    if CanShoot then
                        local weapon = GetSelectedPedWeapon(GetPlayerPed(-1))
                        local ammo = GetAmmoInPedWeapon(GetPlayerPed(-1), weapon)
                        if QBCore.Shared.Weapons[weapon]["name"] == "weapon_snowball" then
                            TriggerServerEvent('QBCore:Server:RemoveItem', "snowball", 1)
                        else
                            if ammo > 0 then
                                MultiplierAmount = MultiplierAmount + 1
                            end
                        end
                    else
                        TriggerEvent('inventory:client:CheckWeapon')
                        QBCore.Functions.Notify("Dit wapen is kapot en werkt niet...", "error")
                        MultiplierAmount = 0
                    end
                end
            end
        end
        Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function()
    while true do
        local ped = GetPlayerPed(-1)
        local player = PlayerId()
        local weapon = GetSelectedPedWeapon(ped)
        local ammo = GetAmmoInPedWeapon(ped, weapon)
        local sneeuwbalhash = 126349499
        N_0x4757f00bc6323cfe(sneeuwbalhash, 0.0001)
        if weapon ~= sneeuwbalhash then
            if ammo == 1 then
                DisableControlAction(0, 24, true) -- Attack
                DisableControlAction(0, 257, true) -- Attack 2
                if IsPedInAnyVehicle(ped) then
                    SetPlayerCanDoDriveBy(player, false)
                end
            else
                EnableControlAction(0, 24, true) -- Attack
		    	EnableControlAction(0, 257, true) -- Attack 2
                if IsPedInAnyVehicle(ped) then
                    SetPlayerCanDoDriveBy(player, true)
                end
            end
        elseif weapon == sneeuwbalhash then
            SetPlayerCanDoDriveBy(player, false)
            if IsPedShooting(PlayerPedId()) or IsControlJustPressed(0, 24) then
                TriggerServerEvent('QBCore:Server:RemoveItem', "snowball", 1)
            end
        end

        if IsPedShooting(ped) then
            if ammo < 2 then
				if weapon ~= sneeuwbalhash then
                    SetAmmoInClip(GetPlayerPed(-1), GetHashKey(QBCore.Shared.Weapons[weapon]["name"]), 1)
                    QBCore.Functions.Notify("Je wapen is leeg, herlaad je wapen met nieuwe kogels!", "error")
                end
            end 
        end
        
        Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function()
    while true do
        N_0x4757f00bc6323cfe(GetHashKey("WEAPON_FLASHLIGHT"), 0.1)
        if IsControlJustReleased(0, 24) or IsDisabledControlJustReleased(0, 24) then
            local weapon = GetSelectedPedWeapon(GetPlayerPed(-1))
            if weapon ~= -1569615261 then
                local ammo = GetAmmoInPedWeapon(GetPlayerPed(-1), weapon)
                if ammo > 0 then
                    TriggerServerEvent("weapons:server:UpdateWeaponAmmo", CurrentWeaponData, tonumber(ammo))
                else
                    TriggerEvent('inventory:client:CheckWeapon')
                    TriggerServerEvent("weapons:server:UpdateWeaponAmmo", CurrentWeaponData, 0)
                end
                if MultiplierAmount > 0 then
                    TriggerServerEvent("weapons:server:UpdateWeaponQuality", CurrentWeaponData, MultiplierAmount)
                    MultiplierAmount = 0
                end
            end
        end
        Citizen.Wait(1)
    end
end)

RegisterNetEvent('weapon:client:AddAmmo')
AddEventHandler('weapon:client:AddAmmo', function(type, amount, itemData)
    local ped = GetPlayerPed(-1)
    local weapon = GetSelectedPedWeapon(GetPlayerPed(-1))
    if itemData ~= nil then
        if QBCore.Shared.Weapons[weapon]["name"] ~= "weapon_unarmed" and QBCore.Shared.Weapons[weapon]["ammotype"] == type:upper() then
            local total = (GetAmmoInPedWeapon(GetPlayerPed(-1), weapon))
            local Skillbar = exports['fortis-skillbar']:GetSkillbarObject()
            local retval = GetMaxAmmoInClip(ped, weapon, 1)
            QBCore.Functions.Progressbar("taking_bullets", "Kogels inladen..", math.random(4000, 6000), false, true, {
                disableMovement = false,
                disableCarMovement = false,
                disableMouse = false,
                disableCombat = true,
            }, {}, {}, {}, function() -- Done
                if QBCore.Shared.Weapons[weapon] ~= nil then
                    SetAmmoInClip(ped, weapon, 0)
                    SetPedAmmo(ped, weapon, retval)
                    TriggerServerEvent("weapons:server:AddWeaponAmmo", itemData, retval)
                    TriggerServerEvent('QBCore:Server:RemoveItem', itemData.name, 1, itemData.slot)
                    TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items[itemData.name], "remove")
                    TriggerEvent('QBCore:Notify', retval.." kogels succesvol ingeladen!", "success")
					TriggerServerEvent("weapons:server:UpdateWeaponAmmo", CurrentWeaponData, retval)
                end
            end, function()
                QBCore.Functions.Notify("Geannuleerd..", "error")
            end)
        else
            QBCore.Functions.Notify("Je hebt momenteel geen wapen vast!", "error")
        end
    else
        QBCore.Functions.Notify("Je hebt momenteel geen wapen vast!", "error")
    end
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    TriggerServerEvent("weapons:server:LoadWeaponAmmo")
    isLoggedIn = true
end)

RegisterNetEvent('weapons:client:SetCurrentWeapon')
AddEventHandler('weapons:client:SetCurrentWeapon', function(data, bool)
    if data ~= false then
        CurrentWeaponData = data
    else
        CurrentWeaponData = {}
    end
    CanShoot = bool
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload')
AddEventHandler('QBCore:Client:OnPlayerUnload', function()
    isLoggedIn = false

    for k, v in pairs(Config.WeaponRepairPoints) do
        Config.WeaponRepairPoints[k].IsRepairing = false
        Config.WeaponRepairPoints[k].RepairingData = {}
    end
end)

RegisterNetEvent('weapons:client:SetWeaponQuality')
AddEventHandler('weapons:client:SetWeaponQuality', function(amount)
    if CurrentWeaponData ~= nil and next(CurrentWeaponData) ~= nil then
        TriggerServerEvent("weapons:server:SetWeaponQuality", CurrentWeaponData, amount)
    end
end)

RegisterNetEvent("weapons:client:EquipAttachment")
AddEventHandler("weapons:client:EquipAttachment", function(ItemData, attachment)
    local ped = GetPlayerPed(-1)
    local weapon = GetSelectedPedWeapon(ped)
    local WeaponData = QBCore.Shared.Weapons[weapon]
    
    if weapon ~= GetHashKey("WEAPON_UNARMED") then
        WeaponData.name = WeaponData.name:upper()
        if Config.WeaponAttachments[WeaponData.name] ~= nil then
            if Config.WeaponAttachments[WeaponData.name][attachment] ~= nil then
                TriggerServerEvent("weapons:server:EquipAttachment", ItemData, CurrentWeaponData, Config.WeaponAttachments[WeaponData.name][attachment])
            else
                QBCore.Functions.Notify("Dit wapen ondersteunt dit onderdeel niet..", "error")
            end
        end
    else
        QBCore.Functions.Notify("Je hebt geen wapen in je hand!", "error")
    end
end)

RegisterNetEvent("addAttachment")
AddEventHandler("addAttachment", function(component)
    local ped = GetPlayerPed(-1)
    local weapon = GetSelectedPedWeapon(ped)
    local WeaponData = QBCore.Shared.Weapons[weapon]
    GiveWeaponComponentToPed(ped, GetHashKey(WeaponData.name), GetHashKey(component))
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