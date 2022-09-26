QBCore = nil

Citizen.CreateThread(function() 
    if QBCore == nil then
        TriggerEvent("QBCore:GetObject", function(obj) QBCore = obj end)    
        Citizen.Wait(200)
    end
end)

Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

DoScreenFadeIn(100)

inBedDict = "misslamar1dead_body"
inBedAnim = "dead_idle"

getOutDict = 'switch@franklin@bed'
getOutAnim = 'sleep_getup_rubeyes'

kaas = false

isLoggedIn = false

isInHospitalBed = false
canLeaveBed = true

bedOccupying = nil
bedObject = nil
bedOccupyingData = nil
currentTp = nil
usedHiddenRev = false

isBleeding = 0
bleedTickTimer, advanceBleedTimer = 0, 0
fadeOutTimer, blackoutTimer = 0, 0

legCount = 0
armcount = 0
headCount = 0 

playerHealth = nil
playerArmour = nil

isDead = false

closestBed = nil
isIngecheckt = false

isStatusChecking = false
statusChecks = {}
statusCheckPed = nil
statusCheckTime = 0

isHealingPerson = false
healAnimDict = "mini@cpr@char_a@cpr_str"
healAnim = "cpr_pumpchest"

doctorsSet = false
doctorCount = 0

PlayerJob = {}
onDuty = false
 
BodyParts = {
    ['HEAD'] = { label = 'hoofd', causeLimp = false, isDamaged = false, severity = 0 },
    ['NECK'] = { label = 'nek', causeLimp = false, isDamaged = false, severity = 0 },
    ['SPINE'] = { label = 'rug', causeLimp = true, isDamaged = false, severity = 0 },
    ['UPPER_BODY'] = { label = 'boven rug', causeLimp = false, isDamaged = false, severity = 0 },
    ['LOWER_BODY'] = { label = 'onder rug', causeLimp = true, isDamaged = false, severity = 0 },
    ['LARM'] = { label = 'linker arm', causeLimp = false, isDamaged = false, severity = 0 },
    ['LHAND'] = { label = 'linker hand', causeLimp = false, isDamaged = false, severity = 0 },
    ['LFINGER'] = { label = 'linker vingers', causeLimp = false, isDamaged = false, severity = 0 },
    ['LLEG'] = { label = 'linker been', causeLimp = true, isDamaged = false, severity = 0 },
    ['LFOOT'] = { label = 'linker voet', causeLimp = true, isDamaged = false, severity = 0 },
    ['RARM'] = { label = 'rechter arm', causeLimp = false, isDamaged = false, severity = 0 },
    ['RHAND'] = { label = 'rechter hand', causeLimp = false, isDamaged = false, severity = 0 },
    ['RFINGER'] = { label = 'rechter vingers', causeLimp = false, isDamaged = false, severity = 0 },
    ['RLEG'] = { label = 'rechter been', causeLimp = true, isDamaged = false, severity = 0 },
    ['RFOOT'] = { label = 'rechter voet', causeLimp = true, isDamaged = false, severity = 0 },
} 

injured = {}
local belletje = false

QBCore = nil
Citizen.CreateThread(function() 
    while true do
        Citizen.Wait(10)
        if QBCore == nil then
            TriggerEvent("QBCore:GetObject", function(obj) QBCore = obj end)    
            Citizen.Wait(200)
        end
    end
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    Citizen.Wait(5000)
    QBCore.Functions.TriggerCallback('hospital:server:belletje', function(belstatus)
        belletje = belstatus
    end)

    PlayerData = QBCore.Functions.GetPlayerData()

    if PlayerData ~= nil and PlayerData.job.name == "ambulance" then
        local cayogarage = AddBlipForCoord(5007.86, -5195.16, 2.51)
        SetBlipSprite(cayogarage, 225)
        SetBlipAsShortRange(cayogarage, true)
        SetBlipScale(cayogarage, 0.8)
        SetBlipColour(cayogarage, 33)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Garage Cayo Perico")
        EndTextCommandSetBlipName(cayogarage)
    end

    if GetEntityMaxHealth(GetPlayerPed(-1)) ~= 200 then           
        SetEntityMaxHealth(GetPlayerPed(-1), 200)                 
        SetEntityHealth(GetPlayerPed(-1), 200) 
    end         
end)

Citizen.CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local health = GetEntityHealth(ped)
        local armor = GetPedArmour(ped)

        if not playerHealth then
            playerHealth = health
        end

        if not playerArmor then
            playerArmor = armor
        end

        local armorDamaged = (playerArmor ~= armor and armor < (playerArmor - Config.ArmorDamage) and armor > 0) -- Players armor was damaged
        local healthDamaged = (playerHealth ~= health) -- Players health was damaged

        local damageDone = (playerHealth - health)

        if armorDamaged or healthDamaged then
            local hit, bone = GetPedLastDamageBone(ped)
            local bodypart = Config.Bones[bone]
            local weapon = GetDamagingWeapon(ped)

            if hit and bodypart ~= 'NONE' then
                local checkDamage = true
                if damageDone >= Config.HealthDamage then
                    if weapon ~= nil then
                        if armorDamaged and (bodypart == 'SPINE' or bodypart == 'UPPER_BODY') or weapon == Config.WeaponClasses['NOTHING'] then
                            checkDamage = false -- Don't check damage if the it was a body shot and the weapon class isn't that strong
                            if armorDamaged then
                                TriggerServerEvent("hospital:server:SetArmor", GetPedArmour(GetPlayerPed(-1)))
                            end
                        end
    
                        if checkDamage then
    
                            if IsDamagingEvent(damageDone, weapon) then
                                CheckDamage(ped, bone, weapon, damageDone)
                            end
                        end
                    end
                elseif Config.AlwaysBleedChanceWeapons[weapon] then
                    if armorDamaged and (bodypart == 'SPINE' or bodypart == 'UPPER_BODY') or weapon == Config.WeaponClasses['NOTHING'] then
                        checkDamage = false -- Don't check damage if the it was a body shot and the weapon class isn't that strong
                    end
                    if math.random(100) < Config.AlwaysBleedChance and checkDamage then
                        ApplyBleed(1)
                    end
                end
            end

            CheckWeaponDamage(ped)
        end

        playerHealth = health
        playerArmor = armor

        if not isInHospitalBed then
            ProcessDamage(ped)
        end
        Citizen.Wait(100)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait((1000 * Config.MessageTimer))
        DoLimbAlert()
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        SetClosestBed()
        if isStatusChecking then
            statusCheckTime = statusCheckTime - 1
            if statusCheckTime <= 0 then
                statusChecks = {}
                isStatusChecking = false
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)  
        for k, v in pairs(Config.Locations["incheckPlekken"]) do
            while true do
                Citizen.Wait(1)
                if GetDistanceBetweenCoords(pos, Config.Locations["incheckPlekken"][k].x, Config.Locations["incheckPlekken"][k].y, Config.Locations["incheckPlekken"][k].z, false) <75 then
                    balies = k
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    Wait(2000)
    local blip = AddBlipForCoord(-254.88, 6324.5, 32.58)
    SetBlipSprite(blip, 61)
    SetBlipAsShortRange(blip, true)
    SetBlipScale(blip, 0.8)
    SetBlipColour(blip, 25)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Paleto Ziekenhuis")
    EndTextCommandSetBlipName(blip)
    Wait(2000)
    local blip = AddBlipForCoord(304.27, -600.33, 43.28)
    SetBlipSprite(blip, 61)
    SetBlipAsShortRange(blip, true)
    SetBlipScale(blip, 0.8)
    SetBlipColour(blip, 25)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Pillbox Ziekenhuis")
    EndTextCommandSetBlipName(blip)
    Wait(2000)
    local blip = AddBlipForCoord(1831.21, 3675.38, 34.27)
    SetBlipSprite(blip, 61)
    SetBlipAsShortRange(blip, true)
    SetBlipScale(blip, 0.8)
    SetBlipColour(blip, 25)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Sandy Ziekenhuis")
    EndTextCommandSetBlipName(blip)

    while true do 
        Citizen.Wait(1)
        Locatie()

        local pos = GetEntityCoords(GetPlayerPed(-1))
        if balies == 1 then
            local balies = 1
            if GetDistanceBetweenCoords(pos, Config.Locations["incheckPlekken"][1].x, Config.Locations["incheckPlekken"][1].y, Config.Locations["incheckPlekken"][1].z, true) < 1.5 then
                if belletje then
                    QBCore.Functions.DrawText3D(Config.Locations["incheckPlekken"][1].x, Config.Locations["incheckPlekken"][1].y, Config.Locations["incheckPlekken"][1].z, "~g~E~w~ - Arts Oproepen")
                else
                    QBCore.Functions.DrawText3D(Config.Locations["incheckPlekken"][1].x, Config.Locations["incheckPlekken"][1].y, Config.Locations["incheckPlekken"][1].z, "~g~E~w~ - Inchecken")
                end
                if IsControlJustReleased(0, Keys["E"]) then
                    if not isIngecheckt then
                        if belletje then
                            TriggerServerEvent("hospital:server:SendDoctorAlert", 1)
                            QBCore.Functions.Notify("Je hebt een melding gemaakt naar de Ambulanciers, zij zullen zo spoedig mogelijk naar het ziekenhuis toe komen!")
                            Wait(60000)
                        else  

                            QBCore.Functions.Progressbar("hospital_checkin", "Inchecken.....", 2000, false, false, {
                                disableMovement = true,
                                disableCarMovement = true,
                                disableMouse = false,
                                disableCombat = true,
                            }, {
                                ExecuteCommand("e clipboard")
                            }, {}, {}, function() -- Done
                                ExecuteCommand("e c")
                                local bedId = closestBed
                                isIngecheckt = true
                                if bedId ~= nil then 
                                    TriggerServerEvent("hospital:server:SendToBed", 1, bedId, true)
                                    Wait(2000)
                                    isIngecheckt = false
                                else
                                    QBCore.Functions.Notify("Alle bedden zijn momenteel bezet!", "error")
                                    Wait(2000)
                                    isIngecheckt = false
                                end
                            end)
                        end
                    else
                        QBCore.Functions.Notify("Je wordt al geholpen...", "error")
                    end
                end
            elseif (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["incheckPlekken"][1].x, Config.Locations["incheckPlekken"][1].y, Config.Locations["incheckPlekken"][1].z, true) < 4.5) then
                if belletje then
                    QBCore.Functions.DrawText3D(Config.Locations["incheckPlekken"][1].x, Config.Locations["incheckPlekken"][1].y, Config.Locations["incheckPlekken"][1].z, "Oproepen")
                else
                    QBCore.Functions.DrawText3D(Config.Locations["incheckPlekken"][1].x, Config.Locations["incheckPlekken"][1].y, Config.Locations["incheckPlekken"][1].z, "Inchecken")
                end
            end
        
            if closestBed ~= nil and not isInHospitalBed and not taken then
                isBezet()

                if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations[1]["beds"][closestBed].x, Config.Locations[1]["beds"][closestBed].y, Config.Locations[1]["beds"][closestBed].z, true) < 1.5 then
                    QBCore.Functions.DrawText3D(Config.Locations[1]["beds"][closestBed].x, Config.Locations[1]["beds"][closestBed].y, Config.Locations[1]["beds"][closestBed].z + 0.1, "~g~E~w~ - Om in bed te liggen")
                    if IsControlJustReleased(0, Keys["E"]) then
                        if GetAvailableBed(closestBed) ~= nil then 
                            TriggerServerEvent("hospital:server:SendToBed", balies, closestBed, false)
                        else
                            QBCore.Functions.Notify("Dit bed is bezet!", "error")
                        end
                    end
                end
            elseif closestBed == nil then
                closestBed = 1 
            end
        elseif balies == 2 then
            local balies = 2
            if GetDistanceBetweenCoords(pos, Config.Locations["incheckPlekken"][2].x, Config.Locations["incheckPlekken"][2].y, Config.Locations["incheckPlekken"][2].z, true) < 1.5 then
                if belletje then
                    QBCore.Functions.DrawText3D(Config.Locations["incheckPlekken"][2].x, Config.Locations["incheckPlekken"][2].y, Config.Locations["incheckPlekken"][2].z, "~g~E~w~ - Arts Oproepen")
                else
                    QBCore.Functions.DrawText3D(Config.Locations["incheckPlekken"][2].x, Config.Locations["incheckPlekken"][2].y, Config.Locations["incheckPlekken"][2].z, "~g~E~w~ - Inchecken")
                end
                if IsControlJustReleased(0, Keys["E"]) then
                    if not isIngecheckt then
                        if belletje then
                            TriggerServerEvent("hospital:server:SendDoctorAlert", balies)
                            QBCore.Functions.Notify("Je hebt een melding gemaakt naar de Ambulanciers, zij zullen zo spoedig mogelijk naar het ziekenhuis toe komen!")
                            Wait(60000)
                        else
                            QBCore.Functions.Progressbar("hospital_checkin", "Inchecken..", 2000, false, true, {
                                disableMovement = true,
                                disableCarMovement = true,
                                disableMouse = false,
                                disableCombat = true,
                            }, {}, {}, {}, function() -- Done
                                TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                                local bedId = closestBed
                                isIngecheckt = true
                                if bedId ~= nil then 
                                    TriggerServerEvent("hospital:server:SendToBed", 2, bedId, true)
                                    Wait(2000)
                                    isIngecheckt = false
                                else
                                    QBCore.Functions.Notify("Alle bedden zijn momenteel bezet!", "error")
                                    Wait(2000)
                                    isIngecheckt = false
                                end
                            end, function() -- Cancel
                                TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                                QBCore.Functions.Notify("Niet ingecheckt!", "error")
                                isIngecheckt = false
                            end)
                        end
                    else
                        QBCore.Functions.Notify("Je wordt al geholpen...", "error")
                    end
                end
            elseif (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["incheckPlekken"][balies].x, Config.Locations["incheckPlekken"][balies].y, Config.Locations["incheckPlekken"][balies].z, true) < 4.5) then
                if doctorCount > 2 then
                    QBCore.Functions.DrawText3D(Config.Locations["incheckPlekken"][2].x, Config.Locations["incheckPlekken"][2].y, Config.Locations["incheckPlekken"][2].z, "Oproepen")
                else
                    QBCore.Functions.DrawText3D(Config.Locations["incheckPlekken"][2].x, Config.Locations["incheckPlekken"][2].y, Config.Locations["incheckPlekken"][2].z, "Inchecken")
                end
            end
        
            if closestBed ~= nil and not isInHospitalBed then
                isBezet()

                if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations[2]["beds"][closestBed].x, Config.Locations[2]["beds"][closestBed].y, Config.Locations[2]["beds"][closestBed].z, true) < 2 then
                    QBCore.Functions.DrawText3D(Config.Locations[2]["beds"][closestBed].x, Config.Locations[2]["beds"][closestBed].y, Config.Locations[2]["beds"][closestBed].z + 0.1, "~g~E~w~ - Om in bed te liggen")
                    if IsControlJustReleased(0, Keys["E"]) then
                        if GetAvailableBed(closestBed) ~= nil then 
                            TriggerServerEvent("hospital:server:SendToBed", balies, closestBed, false)
                        else
                            QBCore.Functions.Notify("Dit bed is bezet!", "error")
                        end
                    end
                end
            elseif closestBed == nil then
                closestbed = 5
            end
        elseif balies == 3 then
            local balies = 3
            if GetDistanceBetweenCoords(pos, Config.Locations["incheckPlekken"][3].x, Config.Locations["incheckPlekken"][3].y, Config.Locations["incheckPlekken"][3].z, true) < 1.5 then
                if belletje then
                    QBCore.Functions.DrawText3D(Config.Locations["incheckPlekken"][3].x, Config.Locations["incheckPlekken"][3].y, Config.Locations["incheckPlekken"][3].z, "~g~E~w~ - Arts Oproepen")
                else
                    QBCore.Functions.DrawText3D(Config.Locations["incheckPlekken"][3].x, Config.Locations["incheckPlekken"][3].y, Config.Locations["incheckPlekken"][3].z, "~g~E~w~ - Inchecken")
                end
                if IsControlJustReleased(0, Keys["E"]) then
                    if not isIngecheckt then
                        if belletje then
                            TriggerServerEvent("hospital:server:SendDoctorAlert", balies)
                            QBCore.Functions.Notify("Je hebt een melding gemaakt naar de Ambulanciers, zij zullen zo spoedig mogelijk naar het ziekenhuis toe komen!")
                            Wait(60000)
                        else
                            QBCore.Functions.Progressbar("hospital_checkin", "Inchecken..", 2000, false, true, {
                                disableMovement = true,
                                disableCarMovement = true,
                                disableMouse = false,
                                disableCombat = true,
                            }, {}, {}, {}, function() -- Done
                                TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                                local bedId = closestBed
                                isIngecheckt = true
                                if bedId ~= nil then 
                                    TriggerServerEvent("hospital:server:SendToBed", 3, bedId, true)
                                    Wait(2000)
                                    isIngecheckt = false
                                else
                                    QBCore.Functions.Notify("Alle bedden zijn momenteel bezet!", "error")
                                    Wait(2000)
                                    isIngecheckt = false
                                end
                            end, function() -- Cancel
                                TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                                QBCore.Functions.Notify("Niet ingecheckt!", "error")
                                isIngecheckt = false
                            end)
                        end
                    else
                        QBCore.Functions.Notify("Je wordt al geholpen...", "error")
                    end
                end
            elseif (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["incheckPlekken"][3].x, Config.Locations["incheckPlekken"][3].y, Config.Locations["incheckPlekken"][3].z, true) < 4.5) then
                if doctorCount > 2 then
                    QBCore.Functions.DrawText3D(Config.Locations["incheckPlekken"][3].x, Config.Locations["incheckPlekken"][3].y, Config.Locations["incheckPlekken"][3].z, "Oproepen")
                else
                    QBCore.Functions.DrawText3D(Config.Locations["incheckPlekken"][3].x, Config.Locations["incheckPlekken"][3].y, Config.Locations["incheckPlekken"][3].z, "Inchecken")
                end
            end
        
            if closestBed ~= nil and not isInHospitalBed then
                isBezet()

                if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations[3]["beds"][closestBed].x, Config.Locations[3]["beds"][closestBed].y, Config.Locations[3]["beds"][closestBed].z, true) < 2 then
                    QBCore.Functions.DrawText3D(Config.Locations[3]["beds"][closestBed].x, Config.Locations[3]["beds"][closestBed].y, Config.Locations[3]["beds"][closestBed].z - 1.0, "~g~E~w~ - Om in bed te liggen")
                    if IsControlJustReleased(0, Keys["E"]) then
                        if GetAvailableBed(closestBed) ~= nil then 
                            TriggerServerEvent("hospital:server:SendToBed", balies, closestBed, false)
                        else
                            QBCore.Functions.Notify("Dit bed is bezet!", "error")
                        end
                    end
                end
            elseif closestBed == nil then
                closestbed = 5
            end
        else
            Citizen.Wait(1000)
        end
    end
end)  

function isBezet()
    bedId = closestBed
    closestBed = closestBed
    bezet = Config.Locations[balies]["beds"][bedId].taken
    if bezet then
        closestBed = closestBed + 1
        if closestBed >= 6 then
            closestBed = 6
            Citizen.Wait(500)
            closestBed = 2
        end
    else
        closestBed = closestBed
    end
end

function Locatie()
    local pos = GetEntityCoords(GetPlayerPed(-1))
    for k, v in pairs(Config.Locations["incheckPlekken"]) do
        if k ~= nil then
            if GetDistanceBetweenCoords(pos, Config.Locations["incheckPlekken"][k].x, Config.Locations["incheckPlekken"][k].y, Config.Locations["incheckPlekken"][k].z, false) <75 then
                balies = k
            end
        end
    end
end

function GetAvailableBed(closestBed)
    local pos = GetEntityCoords(GetPlayerPed(-1))
    local retval = nil

    for k, v in pairs(Config.Locations["incheckPlekken"]) do
        if GetDistanceBetweenCoords(pos, Config.Locations["incheckPlekken"][k].x, Config.Locations["incheckPlekken"][k].y, Config.Locations["incheckPlekken"][k].z, false) <75 then
            balies = k
        end
    end

    retval = closestBed

    if closestBed == nil then
        if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["incheckPlekken"][balies].x, Config.Locations["incheckPlekken"][balies].y, Config.Locations["incheckPlekken"][balies].z, true) < 1.5) then
            for k, v in pairs(Config.Locations[balies]["beds"]) do
                closestBed = closestBed
            end
        end
    end 
    return retval
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(7)
        if QBCore ~= nil then
            if isInHospitalBed and canLeaveBed then
                local pos = GetEntityCoords(GetPlayerPed(-1))

                QBCore.Functions.DrawText3D(pos.x, pos.y, pos.z, "~g~E~w~ - Opstaan")
                if IsControlJustReleased(0, Keys["E"]) then
                    LeaveBed()
                    FreezeEntityPosition(doctorPedje, false)
                    TaskGoStraightToCoord(doctorPedje, pos.x, pos.y, pos.z - 1, -1, -1, -1, -1)
                    Citizen.Wait(2000)
                    TaskGoStraightToCoord(doctorPedje, 316.52, -580.75, 43.27, -1, -1, -1, -1)
                    Citizen.Wait(2000)
                    TaskGoStraightToCoord(doctorPedje, 318.52, -575.75, 43.27, -1, -1, -1, -1)
                    Citizen.Wait(2000)
                    TaskGoStraightToCoord(doctorPedje, 323.28, -580.50, 43.28, -1, -1, -1, -1)
                    Citizen.Wait(1000)
                    SetEntityHeading(doctorPedje, 351.0)
                    Citizen.Wait(50000)
                    DeleteEntity(doctorPedje)
                end
            else
                Citizen.Wait(1000)
            end
        else
            Citizen.Wait(1000)
        end
    end
end)

RegisterNetEvent('hospital:client:Revive')
AddEventHandler('hospital:client:Revive', function()
    local player = PlayerPedId()

	if isDead then
		local playerPos = GetEntityCoords(player, true)
        NetworkResurrectLocalPlayer(playerPos, true, true, false)
        TriggerServerEvent("hospital:server:SetDeathStatus", false)
        isDead = false
        SetPedCanBeTargetted(GetPlayerPed(-1), true)
        SetPedCanBeTargettedByPlayer(GetPlayerPed(-1), -1, true)
        SetEntityInvincible(GetPlayerPed(-1), false)
    end

    if isInHospitalBed then
        loadAnimDict(inBedDict)
        TaskPlayAnim(player, inBedDict , inBedAnim, 8.0, 1.0, -1, 1, 0, 0, 0, 0 )
        SetEntityInvincible(GetPlayerPed(-1), true)
        SetPedCanBeTargetted(GetPlayerPed(-1), true)
        SetPedCanBeTargettedByPlayer(GetPlayerPed(-1), -1, true)
        --SetEntityHeading(player, bedOccupyingData.h - 180.0)
        canLeaveBed = true
    end

    TriggerServerEvent("hospital:server:RestoreWeaponDamage")

    SetEntityHealth(player, GetEntityMaxHealth(player))
    ClearPedBloodDamage(player)
    SetPlayerSprint(PlayerId(), true)

    ResetAll()
    
    QBCore.Functions.Notify("Je bent genezen!")
end)

RegisterNetEvent('hospital:client:setBel')
AddEventHandler('hospital:client:setBel', function(belstatus)
    belletje = belstatus
end)

RegisterNetEvent('hospital:client:SetPain')
AddEventHandler('hospital:client:SetPain', function()
    ApplyBleed(math.random(1,4))
    if not BodyParts[Config.Bones[24816]].isDamaged then
        BodyParts[Config.Bones[24816]].isDamaged = true
        BodyParts[Config.Bones[24816]].severity = math.random(1, 4)
        table.insert(injured, {
            part = Config.Bones[24816],
            label = BodyParts[Config.Bones[24816]].label,
            severity = BodyParts[Config.Bones[24816]].severity
        })
    end

    if not BodyParts[Config.Bones[40269]].isDamaged then
        BodyParts[Config.Bones[40269]].isDamaged = true
        BodyParts[Config.Bones[40269]].severity = math.random(1, 4)
        table.insert(injured, {
            part = Config.Bones[40269],
            label = BodyParts[Config.Bones[40269]].label,
            severity = BodyParts[Config.Bones[40269]].severity
        })
    end

    TriggerServerEvent('hospital:server:SyncInjuries', {
        limbs = BodyParts,
        isBleeding = tonumber(isBleeding)
    })
end)

RegisterNetEvent('hospital:client:KillPlayer')
AddEventHandler('hospital:client:KillPlayer', function()
    SetEntityHealth(GetPlayerPed(-1), 0)
end)

RegisterNetEvent('hospital:client:HealInjuries')
AddEventHandler('hospital:client:HealInjuries', function(type)
    if type == "full" then
        ResetAll()
    else
        ResetPartial()
    end
    TriggerServerEvent("hospital:server:RestoreWeaponDamage")
    QBCore.Functions.Notify("Je wonden zijn geholpen!")
end)

RegisterNetEvent('hospital:client:SendToBed')
AddEventHandler('hospital:client:SendToBed', function(data, id, isRevive)
    bedOccupying = id
    bedOccupyingData = data

    SetBedCam()
    Citizen.CreateThread(function ()
        Citizen.Wait(5)
        local player = PlayerPedId()
        local pos = GetEntityCoords(player)
        local heading = GetEntityHeading(GetPlayerPed(-1))
        if isRevive then
            isInHospitalBed = true
            canLeaveBed = false
            QBCore.Functions.Notify("Je wordt geholpen..")

            if balies == 1 then
                local hash = GetHashKey('s_m_m_doctor_01')
                RequestModel(hash)
                
                while not HasModelLoaded(hash) do
                    Wait(1)
                end

                doctorPedje = CreatePed(4, hash, pos.x - 1, pos.y, pos.z - 2.0, heading - 90, false, true)

                FreezeEntityPosition(doctorPedje, true)    
                SetEntityInvincible(doctorPedje, true)
                SetBlockingOfNonTemporaryEvents(doctorPedje, true)

                loadAnimDict("anim@amb@clubhouse@tutorial@bkr_tut_ig3@")
                TaskPlayAnim(doctorPedje, "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 8.0, -8, -1, 16, 0, 0, 0, 0)
            end

            Citizen.Wait(Config.AIHealTimer * 1000)
            TriggerEvent("hospital:client:Revive")
            canLeaveBed = true
            isInHospitalBed = true

        else
            canLeaveBed = true
            isInHospitalBed = true
        end
    end)
end)

RegisterNetEvent('hospital:client:SetBed')
AddEventHandler('hospital:client:SetBed', function(balies, bedId, variabele)
    Config.Locations[balies]["beds"][bedId].taken = variabele
end)


RegisterNetEvent('hospital:client:RespawnAtHospital')
AddEventHandler('hospital:client:RespawnAtHospital', function()
    TriggerServerEvent("hospital:server:RespawnAtHospital")
    local IsHandcuffed = exports['police']:IsHandcuffed()
    if IsHandcuffed then
        TriggerEvent("police:client:GetCuffed", -1, true)
    end
    TriggerEvent("police:client:DeEscort")
end)

RegisterNetEvent('hospital:client:SendBillEmail')
AddEventHandler('hospital:client:SendBillEmail', function(amount)
    SetTimeout(math.random(2500, 4000), function()
        local gender = "meneer"
        if QBCore.Functions.GetPlayerData().charinfo.gender == 1 then
            gender = "mevrouw"
        end
        local charinfo = QBCore.Functions.GetPlayerData().charinfo
        TriggerServerEvent('un-phone:server:sendNewMail', {
            sender = "Pillbox",
            subject = "Ziekenhuis Kosten",
            message = "Beste " .. gender .. " " .. charinfo.lastname .. ",<br /><br />Hierbij ontvangt u een e-mail met de kosten van het laatste ziekenhuis bezoek.<br />De uiteindelijke kosten zijn geworden: <strong>€"..amount.."</strong><br /><br />Nog veel beterschap gewenst!",
            button = {}
        })
    end)
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate')
AddEventHandler('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    exports.spawnmanager:setAutoSpawn(false)
    isLoggedIn = true
    QBCore.Functions.GetPlayerData(function(PlayerData)
        PlayerJob = PlayerData.job
        SetPedArmour(GetPlayerPed(-1), PlayerData.metadata["armor"])
        isDead = PlayerData.metadata["isdead"]
        if isDead then 
            deathTime = Config.DeathTime
            DeathTimer()
        end
    end) 
end)

RegisterNetEvent('hospital:client:SetDoctorCount')
AddEventHandler('hospital:client:SetDoctorCount', function(amount)
    doctorCount = amount
end)

RegisterNetEvent('QBCore:Client:SetDuty')
AddEventHandler('QBCore:Client:SetDuty', function(duty)
    onDuty = duty
    Wait(300)
    TriggerServerEvent("hospital:server:SetDoctor")
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload')
AddEventHandler('QBCore:Client:OnPlayerUnload', function()
    isLoggedIn = false
    TriggerServerEvent("hospital:server:SetDeathStatus", false)
    TriggerServerEvent("hospital:server:SetArmor", GetPedArmour(GetPlayerPed(-1)))
    if bedOccupying ~= nil then 
        TriggerServerEvent("hospital:server:LeaveBed", bedOccupyingData)
    end
    isDead = false
    deathTime = 0
    SetEntityInvincible(GetPlayerPed(-1), false)
    SetPedArmour(GetPlayerPed(-1), 0)
    ResetAll()
end)

-- Melding maken

RegisterNetEvent('ambulance:client:SendEmergencyMessage')
AddEventHandler('ambulance:client:SendEmergencyMessage', function(message)
    local coords = GetEntityCoords(GetPlayerPed(-1))
    
    TriggerServerEvent("ambulance:server:SendEmergencyMessage", coords, message)
    TriggerEvent("police:client:CallAnim")
end)

RegisterNetEvent('ambulance:server:SendEmergencyMessageCheck')
AddEventHandler('ambulance:server:SendEmergencyMessageCheck', function(MainPlayer, message, coords)
    local PlayerData = QBCore.Functions.GetPlayerData()
    if ((PlayerData.job.name == "ambulance")) then
        if PlayerData.job.onduty then
            TriggerEvent('chatMessage', "Ambulance Melding - " .. MainPlayer.PlayerData.charinfo.phone, "warning", message)
            TriggerEvent("police:client:EmergencySound")
            local transG = 250
            local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
            SetBlipSprite(blip, 280)
            SetBlipColour(blip, 4)
            SetBlipDisplay(blip, 4)
            SetBlipAlpha(blip, transG)
            SetBlipScale(blip, 0.9)
            SetBlipAsShortRange(blip, false)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentString("Ambulance Melding")
            EndTextCommandSetBlipName(blip)
            while transG ~= 0 do
                Wait(180 * 4)
                transG = transG - 1
                SetBlipAlpha(blip, transG)
                if transG == 0 then
                    SetBlipSprite(blip, 2)
                    RemoveBlip(blip)
                    return
                end
            end
        end
    end
end)



function GetDamagingWeapon(ped)
    for k, v in pairs(Config.Weapons) do
        if HasPedBeenDamagedByWeapon(ped, k, 0) then
            ClearEntityLastDamageEntity(ped)
            return v
        end
    end

    return nil
end

function IsDamagingEvent(damageDone, weapon)
    math.randomseed(GetGameTimer())
    local luck = math.random(100)
    local multi = damageDone / Config.HealthDamage

    return luck < (Config.HealthDamage * multi) or (damageDone >= Config.ForceInjury or multi > Config.MaxInjuryChanceMulti or Config.ForceInjuryWeapons[weapon])
end

function DoLimbAlert()
    local player = PlayerPedId()
    if not isDead then
        if #injured > 0 then
            local limbDamageMsg = ''
            if #injured <= Config.AlertShowInfo then
                for k, v in pairs(injured) do
                    limbDamageMsg = limbDamageMsg .. "Jouw " .. v.label .. " voelt "..Config.WoundStates[v.severity]
                    if k < #injured then
                        limbDamageMsg = limbDamageMsg .. " | "
                    end
                end
            else
                limbDamageMsg = "Je hebt pijn op veel plekken.."
            end
            QBCore.Functions.Notify(limbDamageMsg, "primary", 5000)
        end
    end
end

function DoBleedAlert()
    local player = PlayerPedId()
    if not isDead and tonumber(isBleeding) > 0 then
        QBCore.Functions.Notify("Je bent "..Config.BleedingStates[tonumber(isBleeding)].label, "error", 5000)
    end
end

function IsInjuryCausingLimp()
    for k, v in pairs(BodyParts) do
        if v.causeLimp and v.isDamaged then
            return true
        end
    end

    return false
end

function SetClosestBed() 
    local pos = GetEntityCoords(GetPlayerPed(-1), true)
    local current = nil
    local dist = 1.5
    
    for k, v in pairs(Config.Locations["incheckPlekken"]) do
        if GetDistanceBetweenCoords(pos, Config.Locations["incheckPlekken"][k].x, Config.Locations["incheckPlekken"][k].y, Config.Locations["incheckPlekken"][k].z, false) <75 then
            balies = k
        end
    end
    if balies == nil then
        balies = 1
    end

    for k, v in pairs(Config.Locations[balies]["beds"]) do
        if current ~= nil then

            local bed = Config.Locations[balies]["beds"][k].x
            local bed2 = Config.Locations[balies]["beds"][k].y
            local bed3 = Config.Locations[balies]["beds"][k].z

            if GetDistanceBetweenCoords(pos, bed, bed2, bed3, true) < dist then
                dist = GetDistanceBetweenCoords(pos, Config.Locations[balies]["beds"][k].x, Config.Locations[balies]["beds"][k].y, Config.Locations[balies]["beds"][k].z, true)
                goede = k
            end

        elseif current == nil then
            dist = GetDistanceBetweenCoords(pos, Config.Locations[balies]["beds"][k].x, Config.Locations[balies]["beds"][k].y, Config.Locations[balies]["beds"][k].z, true)
            current = k
        end
    end
    if current ~= closestBed and not isInHospitalBed then
        closestBed = goede

    end
end

function ResetPartial()
    for k, v in pairs(BodyParts) do
        if v.isDamaged and v.severity <= 2 then
            v.isDamaged = false
            v.severity = 0
        end
    end

    for k, v in pairs(injured) do
        if v.severity <= 2 then
            v.severity = 0
            table.remove(injured, k)
        end
    end

    if isBleeding <= 2 then
        isBleeding = 0
        bleedTickTimer = 0
        advanceBleedTimer = 0
        fadeOutTimer = 0
        blackoutTimer = 0
    end
    
    TriggerServerEvent('hospital:server:SyncInjuries', {
        limbs = BodyParts,
        isBleeding = tonumber(isBleeding)
    })

    ProcessRunStuff(PlayerPedId())
    DoLimbAlert()
    DoBleedAlert()

    TriggerServerEvent('hospital:server:SyncInjuries', {
        limbs = BodyParts,
        isBleeding = tonumber(isBleeding)
    })
end

function ResetAll()
    isBleeding = 0
    bleedTickTimer = 0
    advanceBleedTimer = 0
    fadeOutTimer = 0
    blackoutTimer = 0
    onDrugs = 0
    wasOnDrugs = false
    onPainKiller = 0
    wasOnPainKillers = false
    injured = {}

    for k, v in pairs(BodyParts) do
        v.isDamaged = false
        v.severity = 0
    end
    
    TriggerServerEvent('hospital:server:SyncInjuries', {
        limbs = BodyParts,
        isBleeding = tonumber(isBleeding)
    })

    CurrentDamageList = {}
    TriggerServerEvent('hospital:server:SetWeaponDamage', CurrentDamageList)

    ProcessRunStuff(PlayerPedId())
    DoLimbAlert()
    DoBleedAlert()

    TriggerServerEvent('hospital:server:SyncInjuries', {
        limbs = BodyParts,
        isBleeding = tonumber(isBleeding)
    })
    TriggerServerEvent("QBCore:Server:SetMetaData", "hunger", 100)
    TriggerServerEvent("QBCore:Server:SetMetaData", "thirst", 100)
	TriggerServerEvent("QBCore:Server:SetMetaData", "stress", 0)
end

function SetBedCam()
    local player = PlayerPedId()

    DoScreenFadeOut(1000)

    while not IsScreenFadedOut() do
        Citizen.Wait(100)
    end

	if IsPedDeadOrDying(player) then
		local playerPos = GetEntityCoords(player, true)
		NetworkResurrectLocalPlayer(playerPos, true, true, false)
    end
    bedObject = GetClosestObjectOfType(bedOccupyingData.x, bedOccupyingData.y, bedOccupyingData.z, 1.0, bedOccupyingData.model, false, false, false)
    FreezeEntityPosition(bedObject, true)

    SetEntityCoords(player, bedOccupyingData.x, bedOccupyingData.y, bedOccupyingData.z + 0.)
    --SetEntityInvincible(PlayerPedId(), true)
    Citizen.Wait(500)
    FreezeEntityPosition(player, true)

    loadAnimDict(inBedDict)

    TaskPlayAnim(player, inBedDict , inBedAnim, 8.0, 1.0, -1, 1, 0, 0, 0, 0 )
    SetEntityHeading(player, bedOccupyingData.h)

    cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
    SetCamActive(cam, true)
    RenderScriptCams(true, false, 1, true, true)
    AttachCamToPedBone(cam, player, 31085, 0, 1.0, 1.0 , true)
    SetCamFov(cam, 90.0)
    SetCamRot(cam, -45.0, 0.0, GetEntityHeading(player) + 180, true)

    DoScreenFadeIn(1000)

    Citizen.Wait(1000)
    FreezeEntityPosition(player, true)
end

function LeaveBed()
    local player = PlayerPedId()

    RequestAnimDict(getOutDict)
    while not HasAnimDictLoaded(getOutDict) do
        Citizen.Wait(0)
    end
    
    FreezeEntityPosition(player, false)
    SetEntityInvincible(player, false)
    SetEntityHeading(player, bedOccupyingData.h + 90)
    TaskPlayAnim(player, getOutDict , getOutAnim, 100.0, 1.0, -1, 8, -1, 0, 0, 0)
    Citizen.Wait(4000)
    ClearPedTasks(player)
    TriggerServerEvent('hospital:server:LeaveBed', balies, bedOccupying)
    FreezeEntityPosition(bedObject, true)

    
    RenderScriptCams(0, true, 200, true, true)
    DestroyCam(cam, false)

    bedOccupying = nil
    bedObject = nil
    bedOccupyingData = nil
    isInHospitalBed = false
end

function MenuOutfits()
    ped = GetPlayerPed(-1);
    MenuTitle = "Outfits"
    ClearMenu()
    Menu.addButton("Mijn Outfits", "OutfitsLijst", nil)
    Menu.addButton("Sluit Menu", "closeMenuFull", nil) 
end

function changeOutfit()
	Wait(200)
    loadAnimDict("clothingshirt")    	
	TaskPlayAnim(GetPlayerPed(-1), "clothingshirt", "try_shirt_positive_d", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
	Wait(3100)
	TaskPlayAnim(GetPlayerPed(-1), "clothingshirt", "exit", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
end

function OutfitsLijst()
    QBCore.Functions.TriggerCallback('apartments:GetOutfits', function(outfits)
        ped = GetPlayerPed(-1);
        MenuTitle = "My Outfits :"
        ClearMenu()

        if outfits == nil then
            QBCore.Functions.Notify("Je hebt geen outfits opgeslagen...", "error", 3500)
            closeMenuFull()
        else
            for k, v in pairs(outfits) do
                Menu.addButton(outfits[k].outfitname, "optionMenu", outfits[k]) 
            end
        end
        Menu.addButton("Terug", "MenuOutfits",nil)
    end)
end

function optionMenu(outfitData)
    ped = GetPlayerPed(-1);
    MenuTitle = "What now?"
    ClearMenu()

    Menu.addButton("Kies Outfit", "selectOutfit", outfitData) 
    Menu.addButton("Verwijder Outfit", "removeOutfit", outfitData) 
    Menu.addButton("Terug", "OutfitsLijst",nil)
end

function selectOutfit(oData)
    TriggerServerEvent('clothes:selectOutfit', oData.model, oData.skin)
    QBCore.Functions.Notify(oData.outfitname.." gekozen", "success", 2500)
    closeMenuFull()
    changeOutfit()
end

function removeOutfit(oData)
    TriggerServerEvent('clothes:removeOutfit', oData.outfitname)
    QBCore.Functions.Notify(oData.outfitname.." is verwijderd", "success", 2500)
    closeMenuFull()
end

function closeMenuFull()
    Menu.hidden = true
    currentGarage = nil
    ClearMenu()
end

function GetClosestPlayer()
    local closestPlayers = QBCore.Functions.GetPlayersFromCoords()
    local closestDistance = -1
    local closestPlayer = -1
    local coords = GetEntityCoords(GetPlayerPed(-1))

    for i=1, #closestPlayers, 1 do
        if closestPlayers[i] ~= PlayerId() then
            local pos = GetEntityCoords(GetPlayerPed(closestPlayers[i]))
            local distance = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, coords.x, coords.y, coords.z, true)

            if closestDistance == -1 or closestDistance > distance then
                closestPlayer = closestPlayers[i]
                closestDistance = distance
            end
        end
	end

	return closestPlayer, closestDistance
end

function DrawText3D(x, y, z, text)
	SetTextScale(0.3, 0.3)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 400
    DrawRect(0.0, 0.0+0.0110, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

function loadAnimDict(dict)
	while(not HasAnimDictLoaded(dict)) do
		RequestAnimDict(dict)
		Citizen.Wait(1)
	end
end