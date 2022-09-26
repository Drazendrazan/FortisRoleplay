QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

local WeaponAmmo = {}

QBCore.Functions.CreateCallback("weapons:server:GetConfig", function(source, cb)
    cb(Config.WeaponRepairPoints)
end)

RegisterServerEvent("weapons:server:AddWeaponAmmo")
AddEventHandler('weapons:server:AddWeaponAmmo', function(CurrentWeaponData, amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local amount = tonumber(amount)
    if CurrentWeaponData ~= nil then
        if Player.PlayerData.items[CurrentWeaponData.slot] ~= nil then
            Player.PlayerData.items[CurrentWeaponData.slot].info.ammo = amount
        end
        Player.Functions.SetInventory(Player.PlayerData.items)
    end
end)

RegisterServerEvent("weapons:server:UpdateWeaponAmmo")
AddEventHandler('weapons:server:UpdateWeaponAmmo', function(CurrentWeaponData, amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player ~= nil then
        if CurrentWeaponData ~= nil then
            if Player.PlayerData.items[CurrentWeaponData.slot] ~= nil then
                Player.PlayerData.items[CurrentWeaponData.slot].info.ammo = amount
            end
            Player.Functions.SetInventory(Player.PlayerData.items)
        end
    end
end)

QBCore.Functions.CreateCallback("weapon:server:GetWeaponAmmo", function(source, cb, WeaponData)
    local Player = QBCore.Functions.GetPlayer(source)
    local retval = 0
    if WeaponData ~= nil then
        if Player ~= nil then
            local ItemData = Player.Functions.GetItemBySlot(WeaponData.slot)
            if ItemData ~= nil then
                retval = ItemData.info.ammo ~= nil and ItemData.info.ammo or 0
            end
        end
    end
    cb(retval)
end)

QBCore.Functions.CreateUseableItem("pistol_ammo", function(source, item)
    TriggerClientEvent("weapon:client:AddAmmo", source, "AMMO_PISTOL", 12, item)
end)

QBCore.Functions.CreateUseableItem("rifle_ammo", function(source, item)
    TriggerClientEvent("weapon:client:AddAmmo", source, "AMMO_RIFLE", 30, item)
end)

QBCore.Functions.CreateUseableItem("smg_ammo", function(source, item)
    TriggerClientEvent("weapon:client:AddAmmo", source, "AMMO_SMG", 30, item)
end)

QBCore.Functions.CreateUseableItem("shotgun_ammo", function(source, item)
    TriggerClientEvent("weapon:client:AddAmmo", source, "AMMO_SHOTGUN", 10, item)
end)

QBCore.Functions.CreateUseableItem("mg_ammo", function(source, item)
    TriggerClientEvent("weapon:client:AddAmmo", source, "AMMO_MG", 30, item)
end)

QBCore.Functions.CreateUseableItem("sniper_ammo", function(source, item)
    TriggerClientEvent("weapon:client:AddAmmo", source, "AMMO_SNIPER", 10, item)
end)

function IsWeaponBlocked(WeaponName)
    local retval = false
    for _, name in pairs(Config.DurabilityBlockedWeapons) do
        if name == WeaponName then
            retval = true
            break
        end 
    end
    return retval
end

RegisterServerEvent('weapons:server:UpdateWeaponQuality')
AddEventHandler('weapons:server:UpdateWeaponQuality', function(data, RepeatAmount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local WeaponData = QBCore.Shared.Weapons[GetHashKey(data.name)]
    local WeaponSlot = Player.PlayerData.items[data.slot]
    local DecreaseAmount = Config.DurabilityMultiplier[data.name]

    if WeaponSlot ~= nil then
        if not IsWeaponBlocked(WeaponData.name) then
            if WeaponSlot.info.quality ~= nil then
                for i = 1, RepeatAmount, 1 do
                    if WeaponSlot.info.quality - DecreaseAmount > 0 then
                        WeaponSlot.info.quality = WeaponSlot.info.quality - DecreaseAmount
                    else
                        WeaponSlot.info.quality = 0
                        TriggerClientEvent('inventory:client:UseWeapon', src, data)
                        TriggerClientEvent('QBCore:Notify', src, "Je wapen is kapot, hij werkt niet!", "error")
                        break
                    end
                end
            else
                WeaponSlot.info.quality = 100
                for i = 1, RepeatAmount, 1 do
                    if WeaponSlot.info.quality - DecreaseAmount > 0 then
                        WeaponSlot.info.quality = WeaponSlot.info.quality - DecreaseAmount
                    else
                        WeaponSlot.info.quality = 0
                        TriggerClientEvent('inventory:client:UseWeapon', src, data)
                        TriggerClientEvent('QBCore:Notify', src, "Je wapen is kapot, hij werkt niet!", "error")
                        break
                    end
                end
            end
        end
    end

    Player.Functions.SetInventory(Player.PlayerData.items)
end)

QBCore.Commands.Add("setweaponhp", "Verander de durability van een wapen.", {{name="hp", help="Durability"}}, true, function(source, args)
    TriggerClientEvent('weapons:client:SetWeaponQuality', source, tonumber(args[1]))
end, "god")

RegisterServerEvent("weapons:server:SetWeaponQuality")
AddEventHandler("weapons:server:SetWeaponQuality", function(data, hp)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local WeaponData = QBCore.Shared.Weapons[GetHashKey(data.name)]
    local WeaponSlot = Player.PlayerData.items[data.slot]
    local DecreaseAmount = Config.DurabilityMultiplier[data.name]
    WeaponSlot.info.quality = hp
    Player.Functions.SetInventory(Player.PlayerData.items)
end)

-- ATTACHMENTS
QBCore.Functions.CreateUseableItem('pistol_defaultclip', function(source, item)
    TriggerClientEvent('weapons:client:EquipAttachment', source, item, 'defaultclip')
end)

QBCore.Functions.CreateUseableItem('pistol_extendedclip', function(source, item)
    TriggerClientEvent('weapons:client:EquipAttachment', source, item, 'extendedclip')
end)

QBCore.Functions.CreateUseableItem('pistol_flashlight', function(source, item)
    TriggerClientEvent('weapons:client:EquipAttachment', source, item, 'flashlight')
end)

QBCore.Functions.CreateUseableItem('pistol_suppressor', function(source, item)
    TriggerClientEvent('weapons:client:EquipAttachment', source, item, 'suppressor')
end)

QBCore.Functions.CreateUseableItem('pistol_luxuryfinish', function(source, item)
    TriggerClientEvent('weapons:client:EquipAttachment', source, item, 'luxuryfinish')
end)

QBCore.Functions.CreateUseableItem('combatpistol_defaultclip', function(source, item)
    TriggerClientEvent('weapons:client:EquipAttachment', source, item, 'defaultclip')
end)

QBCore.Functions.CreateUseableItem('combatpistol_extendedclip', function(source, item)
    TriggerClientEvent('weapons:client:EquipAttachment', source, item, 'extendedclip')
end)

QBCore.Functions.CreateUseableItem('combatpistol_luxuryfinish', function(source, item)
    TriggerClientEvent('weapons:client:EquipAttachment', source, item, 'luxuryfinish')
end)

QBCore.Functions.CreateUseableItem('appistol_defaultclip', function(source, item)
    TriggerClientEvent('weapons:client:EquipAttachment', source, item, 'defaultclip')
end)

QBCore.Functions.CreateUseableItem('appistol_extendedclip', function(source, item)
    TriggerClientEvent('weapons:client:EquipAttachment', source, item, 'extendedclip')
end)

QBCore.Functions.CreateUseableItem('appistol_luxuryfinish', function(source, item)
    TriggerClientEvent('weapons:client:EquipAttachment', source, item, 'luxuryfinish')
end)

QBCore.Functions.CreateUseableItem('pistol50_defaultclip', function(source, item)
    TriggerClientEvent('weapons:client:EquipAttachment', source, item, 'defaultclip')
end)

QBCore.Functions.CreateUseableItem('pistol50_extendedclip', function(source, item)
    TriggerClientEvent('weapons:client:EquipAttachment', source, item, 'extendedclip')
end)

QBCore.Functions.CreateUseableItem('pistol50_luxuryfinish', function(source, item)
    TriggerClientEvent('weapons:client:EquipAttachment', source, item, 'luxuryfinish')
end)

QBCore.Functions.CreateUseableItem('revolver_defaultclip', function(source, item)
    TriggerClientEvent('weapons:client:EquipAttachment', source, item, 'defaultclip')
end)

QBCore.Functions.CreateUseableItem('revolver_vipvariant', function(source, item)
    TriggerClientEvent('weapons:client:EquipAttachment', source, item, 'vipvariant')
end)

QBCore.Functions.CreateUseableItem('revolver_bodyguardvariant', function(source, item)
    TriggerClientEvent('weapons:client:EquipAttachment', source, item, 'bodyguardvariant')
end)

QBCore.Functions.CreateUseableItem('snspistol_defaultclip', function(source, item)
    TriggerClientEvent('weapons:client:EquipAttachment', source, item, 'defaultclip')
end)

QBCore.Functions.CreateUseableItem('snspistol_extendedclip', function(source, item)
    TriggerClientEvent('weapons:client:EquipAttachment', source, item, 'extendedclip')
end)

QBCore.Functions.CreateUseableItem('snspistol_grip', function(source, item)
    TriggerClientEvent('weapons:client:EquipAttachment', source, item, 'grip')
end)

QBCore.Functions.CreateUseableItem('heavypistol_defaultclip', function(source, item)
    TriggerClientEvent('weapons:client:EquipAttachment', source, item, 'defaultclip')
end)

QBCore.Functions.CreateUseableItem('heavypistol_extendedclip', function(source, item)
    TriggerClientEvent('weapons:client:EquipAttachment', source, item, 'extendedclip')
end)

QBCore.Functions.CreateUseableItem('heavypistol_grip', function(source, item)
    TriggerClientEvent('weapons:client:EquipAttachment', source, item, 'grip')
end)

QBCore.Functions.CreateUseableItem('vintagepistol_defaultclip', function(source, item)
    TriggerClientEvent('weapons:client:EquipAttachment', source, item, 'defaultclip')
end)

QBCore.Functions.CreateUseableItem('vintagepistol_extendedclip', function(source, item)
    TriggerClientEvent('weapons:client:EquipAttachment', source, item, 'extendedclip')
end)

QBCore.Functions.CreateUseableItem('combatpistol_defaultclip', function(source, item)
    TriggerClientEvent('weapons:client:EquipAttachment', source, item, 'defaultclip')
end)

QBCore.Functions.CreateUseableItem('microsmg_extendedclip', function(source, item)
    TriggerClientEvent('weapons:client:EquipAttachment', source, item, 'extendedclip')
end)

QBCore.Functions.CreateUseableItem('microsmg_scope', function(source, item)
    TriggerClientEvent('weapons:client:EquipAttachment', source, item, 'scope')
end)

QBCore.Functions.CreateUseableItem('appistol_defaultclip', function(source, item)
    TriggerClientEvent('weapons:client:EquipAttachment', source, item, 'defaultclip')
end)

QBCore.Functions.CreateUseableItem('microsmg_luxuryfinish', function(source, item)
    TriggerClientEvent('weapons:client:EquipAttachment', source, item, 'luxuryfinish')
end)

QBCore.Functions.CreateUseableItem('smg_defaultclip', function(source, item)
    TriggerClientEvent('weapons:client:EquipAttachment', source, item, 'defaultclip')
end)

QBCore.Functions.CreateUseableItem('smg_extendedclip', function(source, item)
    TriggerClientEvent('weapons:client:EquipAttachment', source, item, 'extendedclip')
end)

QBCore.Functions.CreateUseableItem('smg_drum', function(source, item)
    TriggerClientEvent('weapons:client:EquipAttachment', source, item, 'drum')
end)

QBCore.Functions.CreateUseableItem('smg_scope', function(source, item)
    TriggerClientEvent('weapons:client:EquipAttachment', source, item, 'scope')
end)

QBCore.Functions.CreateUseableItem('smg_luxuryfinish', function(source, item)
    TriggerClientEvent('weapons:client:EquipAttachment', source, item, 'luxuryfinish')
end)

QBCore.Functions.CreateUseableItem('assaultsmg_defaultclip', function(source, item)
    TriggerClientEvent('weapons:client:EquipAttachment', source, item, 'defaultclip')
end)

QBCore.Functions.CreateUseableItem('assaultsmg_extendedclip', function(source, item)
    TriggerClientEvent('weapons:client:EquipAttachment', source, item, 'extendedclip')
end)

QBCore.Functions.CreateUseableItem('assaultsmg_luxuryfinish', function(source, item)
    TriggerClientEvent('weapons:client:EquipAttachment', source, item, 'luxuryfinish')
end)

QBCore.Functions.CreateUseableItem('minismg_defaultclip', function(source, item)
    TriggerClientEvent('weapons:client:EquipAttachment', source, item, 'defaultclip')
end)

QBCore.Functions.CreateUseableItem('minismg_extendedclip', function(source, item)
    TriggerClientEvent('weapons:client:EquipAttachment', source, item, 'extendedclip')
end)

QBCore.Functions.CreateUseableItem('machinepistol_defaultclip', function(source, item)
    TriggerClientEvent('weapons:client:EquipAttachment', source, item, 'defaultclip')
end)

QBCore.Functions.CreateUseableItem('machinepistol_extendedclip', function(source, item)
    TriggerClientEvent('weapons:client:EquipAttachment', source, item, 'extendedclip')
end)

QBCore.Functions.CreateUseableItem('machinepistol_drum', function(source, item)
    TriggerClientEvent('weapons:client:EquipAttachment', source, item, 'drum')
end)

QBCore.Functions.CreateUseableItem('combatpdw_defaultclip', function(source, item)
    TriggerClientEvent('weapons:client:EquipAttachment', source, item, 'defaultclip')
end)

QBCore.Functions.CreateUseableItem('combatpdw_extendedclip', function(source, item)
    TriggerClientEvent('weapons:client:EquipAttachment', source, item, 'extendedclip')
end)

QBCore.Functions.CreateUseableItem('combatpistol_defaultclip', function(source, item)
    TriggerClientEvent('weapons:client:EquipAttachment', source, item, 'defaultclip')
end)

QBCore.Functions.CreateUseableItem('combatpdw_drum', function(source, item)
    TriggerClientEvent('weapons:client:EquipAttachment', source, item, 'drum')
end)

QBCore.Functions.CreateUseableItem('combatpdw_grip', function(source, item)
    TriggerClientEvent('weapons:client:EquipAttachment', source, item, 'grip')
end)

QBCore.Functions.CreateUseableItem('combatpdw_scope', function(source, item)
    TriggerClientEvent('weapons:client:EquipAttachment', source, item, 'scope')
end)

QBCore.Functions.CreateUseableItem('shotgun_suppressor', function(source, item)
    TriggerClientEvent('weapons:client:EquipAttachment', source, item, 'suppressor')
end)

QBCore.Functions.CreateUseableItem('pumpshotgun_luxuryfinish', function(source, item)
    TriggerClientEvent('weapons:client:EquipAttachment', source, item, 'luxuryfinish')
end)

QBCore.Functions.CreateUseableItem('sawnoffshotgun_luxuryfinish', function(source, item)
    TriggerClientEvent('weapons:client:EquipAttachment', source, item, 'luxuryfinish')
end)

QBCore.Functions.CreateUseableItem('assaultshotgun_defaultclip', function(source, item)
    TriggerClientEvent('weapons:client:EquipAttachment', source, item, 'defaultclip')
end)

QBCore.Functions.CreateUseableItem('assaultshotgun_extendedclip', function(source, item)
    TriggerClientEvent('weapons:client:EquipAttachment', source, item, 'extendedclip')
end)

QBCore.Functions.CreateUseableItem('heavyshotgun_defaultclip', function(source, item)
    TriggerClientEvent('weapons:client:EquipAttachment', source, item, 'defaultclip')
end)

QBCore.Functions.CreateUseableItem('heavyshotgun_extendedclip', function(source, item)
    TriggerClientEvent('weapons:client:EquipAttachment', source, item, 'extendedclip')
end)

QBCore.Functions.CreateUseableItem('heavyshotgun_drum', function(source, item)
    TriggerClientEvent('weapons:client:EquipAttachment', source, item, 'drum')
end)

QBCore.Functions.CreateUseableItem('assaultrifle_defaultclip', function(source, item)
    TriggerClientEvent('weapons:client:EquipAttachment', source, item, 'defaultclip')
end)

QBCore.Functions.CreateUseableItem('assaultrifle_extendedclip', function(source, item)
    TriggerClientEvent('weapons:client:EquipAttachment', source, item, 'extendedclip')
end)

QBCore.Functions.CreateUseableItem('assaultrifle_drum', function(source, item)
    TriggerClientEvent('weapons:client:EquipAttachment', source, item, 'drum')
end)

QBCore.Functions.CreateUseableItem('rifle_flashlight', function(source, item)
    TriggerClientEvent('weapons:client:EquipAttachment', source, item, 'flashlight')
end)

QBCore.Functions.CreateUseableItem('rifle_grip', function(source, item)
    TriggerClientEvent('weapons:client:EquipAttachment', source, item, 'grip')
end)

QBCore.Functions.CreateUseableItem('rifle_suppressor', function(source, item)
    TriggerClientEvent('weapons:client:EquipAttachment', source, item, 'suppressor')
end)

QBCore.Functions.CreateUseableItem('assaultrifle_luxuryfinish', function(source, item)
    TriggerClientEvent('weapons:client:EquipAttachment', source, item, 'luxuryfinish')
end)

QBCore.Functions.CreateUseableItem('carbinerifle_defaultclip', function(source, item)
    TriggerClientEvent('weapons:client:EquipAttachment', source, item, 'defaultclip')
end)

QBCore.Functions.CreateUseableItem('carbinerifle_extendedclip', function(source, item)
    TriggerClientEvent('weapons:client:EquipAttachment', source, item, 'extendedclip')
end)

QBCore.Functions.CreateUseableItem('carbinerifle_drum', function(source, item)
    TriggerClientEvent('weapons:client:EquipAttachment', source, item, 'drum')
end)

QBCore.Functions.CreateUseableItem('combatpdw_grip', function(source, item)
    TriggerClientEvent('weapons:client:EquipAttachment', source, item, 'grip')
end)

QBCore.Functions.CreateUseableItem('carbinerifle_scope', function(source, item)
    TriggerClientEvent('weapons:client:EquipAttachment', source, item, 'scope')
end)

QBCore.Functions.CreateUseableItem('carbinerifle_luxuryfinish', function(source, item)
    TriggerClientEvent('weapons:client:EquipAttachment', source, item, 'luxuryfinish')
end)

QBCore.Functions.CreateUseableItem('advancedrifle_defaultclip', function(source, item)
    TriggerClientEvent('weapons:client:EquipAttachment', source, item, 'defaultclip')
end)

QBCore.Functions.CreateUseableItem('advancedrifle_extendedclip', function(source, item)
    TriggerClientEvent('weapons:client:EquipAttachment', source, item, 'extendedclip')
end)

QBCore.Functions.CreateUseableItem('advancedrifle_luxuryfinish', function(source, item)
    TriggerClientEvent('weapons:client:EquipAttachment', source, item, 'luxuryfinish')
end)

QBCore.Functions.CreateUseableItem('assaultshotgun_extendedclip', function(source, item)
    TriggerClientEvent('weapons:client:EquipAttachment', source, item, 'extendedclip')
end)

QBCore.Functions.CreateUseableItem('specialcarbine_defaultclip', function(source, item)
    TriggerClientEvent('weapons:client:EquipAttachment', source, item, 'defaultclip')
end)

QBCore.Functions.CreateUseableItem('specialcarbine_extendedclip', function(source, item)
    TriggerClientEvent('weapons:client:EquipAttachment', source, item, 'extendedclip')
end)

QBCore.Functions.CreateUseableItem('specialcarbine_drum', function(source, item)
    TriggerClientEvent('weapons:client:EquipAttachment', source, item, 'drum')
end)

QBCore.Functions.CreateUseableItem('specialcarbine_luxuryfinish', function(source, item)
    TriggerClientEvent('weapons:client:EquipAttachment', source, item, 'luxuryfinish')
end)

QBCore.Functions.CreateUseableItem('specialcarbine_luxuryfinish', function(source, item)
    TriggerClientEvent('weapons:client:EquipAttachment', source, item, 'luxuryfinish')
end)

QBCore.Functions.CreateUseableItem('bullpuprifle_defaultclip', function(source, item)
    TriggerClientEvent('weapons:client:EquipAttachment', source, item, 'defaultclip')
end)

QBCore.Functions.CreateUseableItem('bullpuprifle_extendedclip', function(source, item)
    TriggerClientEvent('weapons:client:EquipAttachment', source, item, 'extendedclip')
end)

QBCore.Functions.CreateUseableItem('bullpuprifle_luxuryfinish', function(source, item)
    TriggerClientEvent('weapons:client:EquipAttachment', source, item, 'luxuryfinish')
end)

QBCore.Functions.CreateUseableItem('compactrifle_defaultclip', function(source, item)
    TriggerClientEvent('weapons:client:EquipAttachment', source, item, 'defaultclip')
end)

QBCore.Functions.CreateUseableItem('assaultrifle_luxuryfinish', function(source, item)
    TriggerClientEvent('weapons:client:EquipAttachment', source, item, 'luxuryfinish')
end)

QBCore.Functions.CreateUseableItem('compactrifle_extendedclip', function(source, item)
    TriggerClientEvent('weapons:client:EquipAttachment', source, item, 'extendedclip')
end)

QBCore.Functions.CreateUseableItem('compactrifle_drum', function(source, item)
    TriggerClientEvent('weapons:client:EquipAttachment', source, item, 'drum')
end)

QBCore.Functions.CreateUseableItem('carbinerifle_drum', function(source, item)
    TriggerClientEvent('weapons:client:EquipAttachment', source, item, 'drum')
end)

QBCore.Functions.CreateUseableItem('gusenberg_defaultclip', function(source, item)
    TriggerClientEvent('weapons:client:EquipAttachment', source, item, 'defaultclip')
end)

QBCore.Functions.CreateUseableItem('gusenberg_extendedclip', function(source, item)
    TriggerClientEvent('weapons:client:EquipAttachment', source, item, 'extendedclip')
end)

QBCore.Functions.CreateUseableItem('sniperrifle_defaultclip', function(source, item)
    TriggerClientEvent('weapons:client:EquipAttachment', source, item, 'defaultclip')
end)

QBCore.Functions.CreateUseableItem('sniper_scope', function(source, item)
    TriggerClientEvent('weapons:client:EquipAttachment', source, item, 'scope')
end)

QBCore.Functions.CreateUseableItem('snipermax_scope', function(source, item)
    TriggerClientEvent('weapons:client:EquipAttachment', source, item, 'scope')
end)

QBCore.Functions.CreateUseableItem('sniper_grip', function(source, item)
    TriggerClientEvent('weapons:client:EquipAttachment', source, item, 'grip')
end)

QBCore.Functions.CreateUseableItem('heavysniper_defaultclip', function(source, item)
    TriggerClientEvent('weapons:client:EquipAttachment', source, item, 'defaultclip')
end)

QBCore.Functions.CreateUseableItem('marksmanrifle_defaultclip', function(source, item)
    TriggerClientEvent('weapons:client:EquipAttachment', source, item, 'defaultclip')
end)

QBCore.Functions.CreateUseableItem('marksmanrifle_extendedclip', function(source, item)
    TriggerClientEvent('weapons:client:EquipAttachment', source, item, 'extendedclip')
end)

QBCore.Functions.CreateUseableItem('marksmanrifle_scope', function(source, item)
    TriggerClientEvent('weapons:client:EquipAttachment', source, item, 'scope')
end)

QBCore.Functions.CreateUseableItem('marksmanrifle_luxuryfinish', function(source, item)
    TriggerClientEvent('weapons:client:EquipAttachment', source, item, 'luxuryfinish')
end)

function HasAttachment(component, attachments)
    local retval = false
    local key = nil
    for k, v in pairs(attachments) do
        if v.component == component then
            key = k
            retval = true
        end
    end
    return retval, key
end

function GetAttachmentItem(weapon, component)
    local retval = nil
    for k, v in pairs(Config.WeaponAttachments[weapon]) do
        if v.component == component then
            retval = v.item
        end
    end
    return retval
end

RegisterServerEvent("weapons:server:EquipAttachment")
AddEventHandler("weapons:server:EquipAttachment", function(ItemData, CurrentWeaponData, AttachmentData)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local Inventory = Player.PlayerData.items
    local GiveBackItem = nil
    if Inventory[CurrentWeaponData.slot] ~= nil then
        if Inventory[CurrentWeaponData.slot].info.attachments ~= nil and next(Inventory[CurrentWeaponData.slot].info.attachments) ~= nil then
            local HasAttach, key = HasAttachment(AttachmentData.component, Inventory[CurrentWeaponData.slot].info.attachments)
            if not HasAttach then
                if CurrentWeaponData.name == "weapon_compactrifle" then
                    local component = "COMPONENT_COMPACTRIFLE_CLIP_03"
                    if AttachmentData.component == "COMPONENT_COMPACTRIFLE_CLIP_03" then
                        component = "COMPONENT_COMPACTRIFLE_CLIP_02"
                    end
                    for k, v in pairs(Inventory[CurrentWeaponData.slot].info.attachments) do
                        if v.component == component then
                            local has, key = HasAttachment(component, Inventory[CurrentWeaponData.slot].info.attachments)
                            local item = GetAttachmentItem(CurrentWeaponData.name:upper(), component)
                            GiveBackItem = tostring(item):lower()
                            table.remove(Inventory[CurrentWeaponData.slot].info.attachments, key)
                            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], "add")
                        end
                    end
                end
                table.insert(Inventory[CurrentWeaponData.slot].info.attachments, {
                    component = AttachmentData.component,
                    label = AttachmentData.label,
                })
                TriggerClientEvent("addAttachment", src, AttachmentData.component)
                Player.Functions.SetInventory(Player.PlayerData.items)
                Player.Functions.RemoveItem(ItemData.name, 1)
                SetTimeout(1000, function()
                    TriggerClientEvent('inventory:client:ItemBox', src, ItemData, "remove")
                end)
            else
                TriggerClientEvent("QBCore:Notify", src, "Je hebt al een "..AttachmentData.label:lower().." op je wapen zitten.", "error", 3500)
            end
        else
            Inventory[CurrentWeaponData.slot].info.attachments = {}
            table.insert(Inventory[CurrentWeaponData.slot].info.attachments, {
                component = AttachmentData.component,
                label = AttachmentData.label,
            })
            TriggerClientEvent("addAttachment", src, AttachmentData.component)
            Player.Functions.SetInventory(Player.PlayerData.items)
            Player.Functions.RemoveItem(ItemData.name, 1)
            SetTimeout(1000, function()
                TriggerClientEvent('inventory:client:ItemBox', src, ItemData, "remove")
            end)
        end
    end

    if GiveBackItem ~= nil then
        Player.Functions.AddItem(GiveBackItem, 1, false)
        GiveBackItem = nil
    end
end)

QBCore.Functions.CreateCallback('weapons:server:RemoveAttachment', function(source, cb, AttachmentData, ItemData)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local Inventory = Player.PlayerData.items
    local AttachmentComponent = Config.WeaponAttachments[ItemData.name:upper()][AttachmentData.attachment]

    if Inventory[ItemData.slot] ~= nil then
        if Inventory[ItemData.slot].info.attachments ~= nil and next(Inventory[ItemData.slot].info.attachments) ~= nil then
            local HasAttach, key = HasAttachment(AttachmentComponent.component, Inventory[ItemData.slot].info.attachments)
            if HasAttach then
                table.remove(Inventory[ItemData.slot].info.attachments, key)
                Player.Functions.SetInventory(Player.PlayerData.items)
                Player.Functions.AddItem(AttachmentComponent.item, 1)
                TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[AttachmentComponent.item], "add")
                TriggerClientEvent("QBCore:Notify", src, "Je hebt "..AttachmentComponent.label.." van je wapen verwijderd!", "error")
                cb(Inventory[ItemData.slot].info.attachments)
            else
                cb(false)
            end
        else
            cb(false)
        end
    else
        cb(false)
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