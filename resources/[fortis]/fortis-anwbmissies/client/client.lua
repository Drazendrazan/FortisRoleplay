QBCore = nil

Citizen.CreateThread(function() 
    if QBCore == nil then
        TriggerEvent("QBCore:GetObject", function(obj) QBCore = obj end)    
        Citizen.Wait(200)
    else
        Citizen.Wait(10000)
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

local PlayerJob = {}
local CurrentLocation = {}
local CurrentBlip = nil
local bezig = false
local voertuigspawned = false


-- NPC Missie -- 
RegisterNetEvent('anwb:client:ToggleNpc')
AddEventHandler('anwb:client:ToggleNpc', function()
    if QBCore.Functions.GetPlayerData().job.name == "mechanic" then
        if bezig then
            QBCore.Functions.Notify("Haal eerst het vorige voertuig op!", "error")
        else
            bezig = true
            
            local randomLocation = getRandomVehicleLocation()
            CurrentLocation.x = Config.Locations["towspots"][randomLocation].coords.x
            CurrentLocation.y = Config.Locations["towspots"][randomLocation].coords.y
            CurrentLocation.z = Config.Locations["towspots"][randomLocation].coords.z
            CurrentLocation.model = Config.Locations["towspots"][randomLocation].model
            CurrentLocation.id = randomLocation

            spawnCoords = {x =  CurrentLocation.x, y = CurrentLocation.y, z = CurrentLocation.z}

            CurrentBlip = AddBlipForCoord(CurrentLocation.x, CurrentLocation.y, CurrentLocation.z)
            SetBlipColour(CurrentBlip, 3)
            SetBlipRoute(CurrentBlip, true)
            SetBlipRouteColour(CurrentBlip, 3)

            TriggerEvent("anwb:client:missie")
        end
    end
end)

AddEventHandler("anwb:client:missie", function()
    while true do
        Citizen.Wait(1)
        local letsleep = true
        local voertuigcoords = GetEntityCoords(voertuig)
        local pos = GetEntityCoords(GetPlayerPed(-1))

        if not voertuigspawned and GetDistanceBetweenCoords(spawnCoords.x, spawnCoords.y, spawnCoords.z, pos.x, pos.y, pos.z, true) < 40.0 then
            letsleep = false
            local voertuigje = QBCore.Functions.SpawnVehicle(CurrentLocation.model, function(vehicle)
                voertuig = vehicle
                voertuigspawned = true
            end, spawnCoords, true)
        end

        if GetDistanceBetweenCoords(spawnCoords.x, spawnCoords.y, spawnCoords.z, pos.x, pos.y, pos.z, true) < 10.0 then
            letsleep = false
            if DoesBlipExist(CurrentBlip) then
                RemoveBlip(CurrentBlip)
                CurrentLocation = {}
                CurrentBlip = nil
            end
        end

        if GetDistanceBetweenCoords(voertuigcoords.x, voertuigcoords.y, voertuigcoords.z, -350.91, -144.31, 39.0, true) < 10.0 then
            letsleep = false
            deliverVehicle(voertuig)
            bezig = false
            voertuigspawned = false
            return
        end

        if letsleep then
            Citizen.Wait(1000)
        end
    end
end)

-- /tow --
RegisterNetEvent('qb-tow:client:TowVehicle')
AddEventHandler('qb-tow:client:TowVehicle', function()
    local berger = QBCore.Functions.GetClosestVehicle()
    if isTowVehicle(berger) then
        if CurrentTow == nil then
            QBCore.Functions.Notify("Selecteer je voertuig die je wilt koppelen aan je berger met E en op G om te annuleren", "primary")
            while true do
                Citizen.Wait(1)
                local pedPos = GetEntityCoords(GetPlayerPed(-1))
                local teBergen = QBCore.Functions.GetClosestVehicle()
                local teBergenLocatie = GetEntityCoords(teBergen)
                local bergenAfstand = GetDistanceBetweenCoords(pedPos, teBergenLocatie, false)

                if bergenAfstand <2 and teBergen ~= berger then
                    DrawMarker(20, teBergenLocatie.x, teBergenLocatie.y, teBergenLocatie.z + 2.0, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.5, 0.5, 0.5, 0, 204, 102, 100, false, true, 2, true, false, false, false)
                    if IsControlJustPressed(0, 38) then 
                        QBCore.Functions.Progressbar("towing_vehicle", "Voertuig opzetten..", 5000, false, true, {
                            disableMovement = true,
                            disableCarMovement = true,
                            disableMouse = false,
                            disableCombat = true,
                        }, {
                            animDict = "mini@repair",
                            anim = "fixing_a_ped",
                            flags = 16,
                        }, {}, {}, function() -- Done
                            StopAnimTask(GetPlayerPed(-1), "mini@repair", "fixing_a_ped", 1.0)
                            AttachEntityToEntity(teBergen, berger, GetEntityBoneIndexByName(berger, 'bodyshell'), 0.0, -1.5 + -0.85, 0.0 + 0.9, 0, 0, 0, 1, 1, 0, 1, 0, 1)
                            FreezeEntityPosition(teBergen, true)
                            CurrentTow = teBergen
                            if NpcOn then
                                RemoveBlip(CurrentBlip)
                                QBCore.Functions.Notify("Breng het voertuig naar het Hayes Depot!", "success", 5000)
                            end
                            QBCore.Functions.Notify("Voertuig opgezet!")
                        end, function() -- Cancel
                            StopAnimTask(GetPlayerPed(-1), "mini@repair", "fixing_a_ped", 1.0)
                            QBCore.Functions.Notify("Mislukt!", "error")
                        end)
                        break
                    end
                    if IsControlJustPressed(0, 47) then
                        break
                        QBCore.Functions.Notify("Geanuleerd!", "error")
                    end
                end
            end
        else 
            QBCore.Functions.Progressbar("untowing_vehicle", "Voertuig ontkoppelen..", 5000, false, true, {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            }, {
                animDict = "mini@repair",
                anim = "fixing_a_ped",
                flags = 16, 
            }, {}, {}, function() -- Done
                StopAnimTask(GetPlayerPed(-1), "mini@repair", "fixing_a_ped", 1.0)
                FreezeEntityPosition(CurrentTow, false)
                Citizen.Wait(250)

                if GetEntityModel(berger) == GetHashKey("flatbedm2") then
                    AttachEntityToEntity(CurrentTow, berger, 20, -1.0, -14.5, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
                else
                    AttachEntityToEntity(CurrentTow, berger, 20, -0.0, -3.0, 1.0, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
                end
                DetachEntity(CurrentTow, true, true)
                CurrentTow = nil
                QBCore.Functions.Notify("Voertuig ontkoppeld!")
                return
            end, function() -- Cancel
                StopAnimTask(GetPlayerPed(-1), "mini@repair", "fixing_a_ped", 1.0)
                QBCore.Functions.Notify("Mislukt!", "error")
            end)
        end
    else
        QBCore.Functions.Notify("Ga op de juiste plek staan net naast de cabine", "error")
    end
end)

--trailer
RegisterNetEvent('fortis-anwbmissies:client:trailer')
AddEventHandler('fortis-anwbmissies:client:trailer', function()
    if CurrentTow == veh then
        local trailer = QBCore.Functions.GetClosestVehicle()
        if IsTrailer(trailer) then
            QBCore.Functions.Notify("Selecteer je voertuig die je wilt koppelen aan je trailer met E en op G om te annuleren", "primary")
            while true do
                Wait(0)
                local pedPos = GetEntityCoords(GetPlayerPed(-1))
                local vehicle = QBCore.Functions.GetClosestVehicle()
                trailerAfstand = GetEntityCoords(trailer)
                local voertuigAfstand2 = GetEntityCoords(vehicle)
                local voertuigAfstand = GetDistanceBetweenCoords(pedPos, voertuigAfstand2, false)
                local pos = GetEntityCoords(vehicle)
                local afhaalAfstand = GetDistanceBetweenCoords(pedPos, trailerAfstand, false)
                if vehicle ~= 0 and vehicle ~= nil and voertuigAfstand <3 and vehicle ~= trailer then
                    DrawMarker(20, pos.x, pos.y, pos.z + 3.0, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.5, 0.5, 0.5, 0, 204, 102, 100, false, true, 2, true, false, false, false)
                    if IsControlJustPressed(0, 38) then
                        if afhaalAfstand <25 then
                            runTow(trailer, vehicle)
                            return
                        else
                            QBCore.Functions.Notify("Je kan niet vanaf zo ver een voertuig opzetten!", "error")
                            break
                        end
                    end
                else
                    if IsControlJustPressed(0, 47) then
                        QBCore.Functions.Notify("Voertuig selectie geannuleerd", "success")
                        break
                    end
                end
            end
        else
            QBCore.Functions.Notify("Ga eerst bij de trailer staan!", "error")
        end
    else
        while true do
            Wait(0)
            local pos = GetEntityCoords(GetPlayerPed(-1))
            local afhaalAfstand = GetDistanceBetweenCoords(pos, trailerAfstand, false)
            if afhaalAfstand <25 then
                derunTow(pos, afhaalAfstand)
                return      
            else
                QBCore.Functions.Notify("Voertuig ontkoppeling kan niet zo ver plaatsvinden", "error")
                break
            end
        end
    end
end)

RegisterNetEvent("fortis-anwbmissies:client:stopmotor")
AddEventHandler("fortis-anwbmissies:client:stopmotor", function()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    SetVehicleEngineOn(vehicle, false, true, true)
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        while PlayerData == nil do Wait(500) end
        while PlayerData.job == nil do Wait(500) end
        if PlayerData.job.name == "mechanic" then
            local pos = GetEntityCoords(PlayerPedId())
            for k,v in pairs(Config.Vooraad) do
                local distance = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Vooraad[k].x, Config.Vooraad[k].y, Config.Vooraad[k].z, false)
                if distance < 100 then
                    if distance <20 then
                        if distance <15.0 then
                            DrawMarker(2, Config.Vooraad[k].x, Config.Vooraad[k].y, Config.Vooraad[k].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.2, 0.3, 0.1, 28, 202, 155, 155, false, false, false, true, false, false, false)
                        end
                        if distance <1.5 then
                            QBCore.Functions.DrawText3D(Config.Vooraad[k].x, Config.Vooraad[k].y, Config.Vooraad[k].z + 0.10, "~g~E~w~ - Pak onderdelen")
                            if IsControlJustPressed(0, 38) then
                                OnderdelenGarage()
                                Menu.hidden = not Menu.hidden
                            end
                            Menu.renderGUI()
                        end
                    end
                else
                    Citizen.Wait(1000)
                end
            end
        else
            Citizen.Wait(5000)
        end
    end
end)

function OnderdelenGarage()
    lijstAantal = 1
    paginaNummer = 1
    ped = GetPlayerPed(-1)
    MenuTitle = "Beschikbare onderdelen:"
    ClearMenu()
    Menu.addButton("Beschikbare Onderdelen", "BeschikbareOnderdelen", nil)
    Menu.addButton("Sluiten", "closeMenuFull", nil)
end

function BeschikbareOnderdelen()
    ClearMenu()
    Menu.addButton("Standaard Uitrusting", "Standaarduitrusting", nil)
    Menu.addButton("Deur €250", "Deuren", nil)
    Menu.addButton("Band €200", "Banden", nil)
    Menu.addButton("Motorkap €350", "Motorkappen", nil)
    Menu.addButton("Brandstof €50", "Tanken", nil)
    -- Menu.addButton("Turbo €35.000", "Turbopakken", nil)
    Menu.addButton("Uitlaat €500", "UitlaatPakken", nil)
    -- Menu.addButton("Remmen €12.500", "RemmenPakken", nil)
    -- Menu.addButton("Tunerchip €15.000", "Tunerchippakken", nil)
    -- Menu.addButton("Nitro €7500", "Nitropakken", nil)
    -- Menu.addButton("Neon", "NeonKleurKeuze", nil)
    Menu.addButton("Sluiten", "closeMenuFull", nil)
end

function Tunerchippakken()
    closeMenuFull()
    TriggerServerEvent("fortis-anwbmissies:server:geeftunerofnitro", "tunerlaptop")
    QBCore.Functions.Notify("Je hebt 1 tunerchip gepakt, geef deze aan je klant en vergeet niet af te rekenen!", "success")
end

function Nitropakken() 
    closeMenuFull()
    TriggerServerEvent("fortis-anwbmissies:server:geeftunerofnitro", "nitrous")
    QBCore.Functions.Notify("Je hebt 1 fles nitro gepakt, geef deze aan je klant en vergeet niet af te rekenen!", "success")
end

function Standaarduitrusting()
    closeMenuFull()
    TriggerServerEvent("fortis-anwbmissies:server:geefuitrusting")
    QBCore.Functions.Notify("Je hebt je standaard uitrusting gepakt! Let op dat het niet toegestaan is dit meer dan nodig is te doen!", "error")
end

function Deuren()
    closeMenuFull()
    QBCore.Functions.Progressbar("untowing_vehicle", "Voorzichtig een deur aan het pakken..", 1000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "mini@repair",
        anim = "fixing_a_ped",
        flags = 16,
    }, {}, {}, function() -- Done
        StopAnimTask(GetPlayerPed(-1), "mini@repair", "fixing_a_ped", 1.0)
        pakDeur()
    end, function() -- Cancel
        ClearPedTasks(GetPlayerPed(-1))
        StopAnimTask(GetPlayerPed(-1), "mini@repair", "fixing_a_ped", 1.0)
        QBCore.Functions.Notify("Mislukt!", "error")
    end)
end

function pakDeur()
    local pos = GetEntityCoords(PlayerPedId(), true) 
    RequestAnimDict("anim@heists@box_carry@")
    loadAnimDict("anim@heists@box_carry@")
    TaskPlayAnim(PlayerPedId(), "anim@heists@box_carry@" ,"idle", 5.0, -1, -1, 50, 0, false, false, false)
    local model = GetHashKey("imp_prop_impexp_car_door_02a")
    RequestModel(model)
    while not HasModelLoaded(model) do Citizen.Wait(0) end
    local object = CreateObject(model, pos.x, pos.y, pos.z, true, true, true)

    AttachEntityToEntity(object, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), 0.0, 0.2, -0.5, -90.0, 0.0, 45.0, true, true, false, true, 1, true)

    while true do
        Citizen.Wait(1)
        if IsControlJustPressed(0, 38) then
            local targetVeh = QBCore.Functions.GetClosestVehicle()
            SetVehicleDoorOpen(targetVeh, 0, false, false)
            SetVehicleDoorOpen(targetVeh, 1, false, false)
            SetVehicleDoorOpen(targetVeh, 2, false, false)
            SetVehicleDoorOpen(targetVeh, 3, false, false)
            local curVehLocatie = GetEntityCoords(targetVeh)
            local pedPos = GetEntityCoords(PlayerPedId())
                if GetDistanceBetweenCoords(curVehLocatie, pedPos, true) < 4 then
                QBCore.Functions.Progressbar("untowing_vehicle", "Deur aan het monteren..", 5000, false, false, {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                }, {
                    animDict = "mini@repair",
                    anim = "fixing_a_ped",
                    flags = 16,
                }, {}, {}, function() -- Done
                    DeleteEntity(object)
                    StopAnimTask(PlayerPedId(), "anim@heists@box_carry@", "idle", 0)
                    ClearPedTasksImmediately(PlayerPedId())
                    SetVehicleDirtLevel(targetVeh, 0.0)
                    SetVehicleUndriveable(targetVeh, false)
                    WashDecalsFromVehicle(targetVeh, 1.0)
                    QBCore.Functions.Notify("Voertuig succesvol gerepareerd!")
                    SetVehicleFixed(targetVeh)
                    SetVehicleDoorShut(targetVeh, 0, false)
                    SetVehicleDoorShut(targetVeh, 1, false)
                    SetVehicleDoorShut(targetVeh, 2, false)
                    SetVehicleDoorShut(targetVeh, 3, false)
                end, function() -- Cancel
                    ClearPedTasks(GetPlayerPed(-1))
                    StopAnimTask(GetPlayerPed(-1), "mini@repair", "fixing_a_ped", 1.0)
                    QBCore.Functions.Notify("Mislukt!", "error")
                    SetVehicleDoorShut(targetVeh, 0, false)
                    SetVehicleDoorShut(targetVeh, 1, false)
                    SetVehicleDoorShut(targetVeh, 2, false)
                    SetVehicleDoorShut(targetVeh, 3, false)
                end)
                return
            end
        elseif IsControlJustPressed(0, 47) then
            DeleteEntity(object)
            StopAnimTask(PlayerPedId(), "anim@heists@box_carry@", "idle", 0)
            ClearPedTasksImmediately(PlayerPedId())
            QBCore.Functions.Notify("Geannuleerd!", "error")
            return
        end
    end
end


function Banden()
    closeMenuFull()
    QBCore.Functions.Progressbar("untowing_vehicle", "Voorzichtig een band aan het pakken..", 1000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "mini@repair",
        anim = "fixing_a_ped",
        flags = 16,
    }, {}, {}, function() -- Done
        StopAnimTask(GetPlayerPed(-1), "mini@repair", "fixing_a_ped", 1.0)
        pakBand()
    end, function() -- Cancel
        ClearPedTasks(GetPlayerPed(-1))
        StopAnimTask(GetPlayerPed(-1), "mini@repair", "fixing_a_ped", 1.0)
        QBCore.Functions.Notify("Mislukt!", "error")
    end)
end

function pakBand()
    local pos = GetEntityCoords(PlayerPedId(), true) 
    RequestAnimDict("anim@heists@box_carry@")
    loadAnimDict("anim@heists@box_carry@")
    TaskPlayAnim(PlayerPedId(), "anim@heists@box_carry@" ,"idle", 5.0, -1, -1, 50, 0, false, false, false)
    local model = GetHashKey("prop_wheel_03")
    RequestModel(model)
    while not HasModelLoaded(model) do Citizen.Wait(0) end
    local object = CreateObject(model, pos.x, pos.y, pos.z, true, true, true)

    AttachEntityToEntity(object, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), 0.35, 0.14, -0.230, -165.0, 290.0, 0.0, true, true, false, true, 1, true)

    while true do
        Citizen.Wait(1)
        if IsControlJustPressed(0, 38) then
            local targetVeh = QBCore.Functions.GetClosestVehicle()
            local curVehLocatie = GetEntityCoords(targetVeh)
            local pedPos = GetEntityCoords(PlayerPedId())
            if GetDistanceBetweenCoords(curVehLocatie, pedPos, true) < 4 then
                local targetVeh = QBCore.Functions.GetClosestVehicle()

                QBCore.Functions.Progressbar("untowing_vehicle", "Band aan het monteren..", 5000, false, false, {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                }, {
                    animDict = "mini@repair",
                    anim = "fixing_a_ped",
                    flags = 16,
                }, {}, {}, function() -- Done
                    DeleteEntity(object)
                    StopAnimTask(PlayerPedId(), "anim@heists@box_carry@", "idle", 0)
                    ClearPedTasksImmediately(PlayerPedId())
                    SetVehicleDirtLevel(targetVeh, 0.0)
                    SetVehicleUndriveable(targetVeh, false)
                    WashDecalsFromVehicle(targetVeh, 1.0)
                    QBCore.Functions.Notify("Voertuig succesvol gerepareerd!")
                    SetVehicleFixed(targetVeh)
                end, function() -- Cancel
                    ClearPedTasks(GetPlayerPed(-1))
                    StopAnimTask(GetPlayerPed(-1), "mini@repair", "fixing_a_ped", 1.0)
                    QBCore.Functions.Notify("Mislukt!", "error")
                end)
                return
            end
        elseif IsControlJustPressed(0, 47) then
            DeleteEntity(object)
            StopAnimTask(PlayerPedId(), "anim@heists@box_carry@", "idle", 0)
            ClearPedTasksImmediately(PlayerPedId())
            QBCore.Functions.Notify("Geannuleerd!", "error")
            return
        end
    end
end

function Motorkappen()
    closeMenuFull()
    QBCore.Functions.Progressbar("untowing_vehicle", "Voorzichtig een motorkap aan het pakken..", 1000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "mini@repair",
        anim = "fixing_a_ped",
        flags = 16,
    }, {}, {}, function() -- Done
        StopAnimTask(GetPlayerPed(-1), "mini@repair", "fixing_a_ped", 1.0)
        pakMotorkap()
    end, function() -- Cancel
        ClearPedTasks(GetPlayerPed(-1))
        StopAnimTask(GetPlayerPed(-1), "mini@repair", "fixing_a_ped", 1.0)
        QBCore.Functions.Notify("Mislukt!", "error")
    end)
end
 
function pakMotorkap()
    local pos = GetEntityCoords(PlayerPedId(), true) 
    RequestAnimDict("anim@heists@box_carry@")
    loadAnimDict("anim@heists@box_carry@")
    TaskPlayAnim(PlayerPedId(), "anim@heists@box_carry@" ,"idle", 5.0, -1, -1, 50, 0, false, false, false)
    local model = GetHashKey("imp_prop_impexp_bonnet_02a")
    RequestModel(model)
    while not HasModelLoaded(model) do Citizen.Wait(0) end
    local object = CreateObject(model, pos.x, pos.y, pos.z, true, true, true)

    AttachEntityToEntity(object, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), 0.15, 0.0, 0.0, -90.0, 180.0, 45.0, true, true, false, true, 1, true)

    while true do
        Citizen.Wait(1)
        if IsControlJustPressed(0, 38) then
            local targetVeh = QBCore.Functions.GetClosestVehicle()
            local curVehLocatie = GetEntityCoords(targetVeh)
            local pedPos = GetEntityCoords(PlayerPedId())
            SetVehicleDoorOpen(targetVeh, 4, false, false)
            if GetDistanceBetweenCoords(curVehLocatie, pedPos, true) < 4 then
                QBCore.Functions.Progressbar("untowing_vehicle", "Motorkap aan het monteren..", 5000, false, false, {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                }, {
                    animDict = "mini@repair",
                    anim = "fixing_a_ped",
                    flags = 16,
                }, {}, {}, function() -- Done
                    DeleteEntity(object)
                    StopAnimTask(PlayerPedId(), "anim@heists@box_carry@", "idle", 0)
                    ClearPedTasksImmediately(PlayerPedId())
                    SetVehicleDirtLevel(targetVeh, 0.0)
                    SetVehicleUndriveable(targetVeh, false)
                    WashDecalsFromVehicle(targetVeh, 1.0)
                    QBCore.Functions.Notify("Voertuig succesvol gerepareerd!")
                    SetVehicleFixed(targetVeh)
                    SetVehicleDoorShut(targetVeh, 4, true)
                end, function() -- Cancel
                    ClearPedTasks(GetPlayerPed(-1))
                    StopAnimTask(GetPlayerPed(-1), "mini@repair", "fixing_a_ped", 1.0)
                    QBCore.Functions.Notify("Mislukt!", "error")
                    SetVehicleDoorShut(targetVeh, 4, true)
                end)
                return
            else
                QBCore.Functions.Notify("Mislukt!", "error")
            end
        elseif IsControlJustPressed(0, 47) then
            DeleteEntity(object)
            StopAnimTask(PlayerPedId(), "anim@heists@box_carry@", "idle", 0)
            ClearPedTasksImmediately(PlayerPedId())
            QBCore.Functions.Notify("Geannuleerd!", "error")
            return
        end
    end
end

function Tanken()
    closeMenuFull()
    QBCore.Functions.Progressbar("untowing_vehicle", "Een jerry can aan het pakken..", 1000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "mini@repair", 
        anim = "fixing_a_ped",
        flags = 16,
    }, {}, {}, function() -- Done
        StopAnimTask(GetPlayerPed(-1), "mini@repair", "fixing_a_ped", 1.0)
        pakTanken()
    end, function() -- Cancel
        ClearPedTasks(GetPlayerPed(-1))
        StopAnimTask(GetPlayerPed(-1), "mini@repair", "fixing_a_ped", 1.0)
        QBCore.Functions.Notify("Mislukt!", "error")
    end)
end
 
function pakTanken()
    local pos = GetEntityCoords(PlayerPedId(), true) 
    RequestAnimDict("missheistdocksprep1hold_cellphone")
    loadAnimDict("missheistdocksprep1hold_cellphone")
    TaskPlayAnim(PlayerPedId(), "missheistdocksprep1hold_cellphone", "static", 5.0, -1, -1, 50, 0, false, false, false)
    local model = GetHashKey("prop_jerrycan_01a")
    RequestModel(model)
    while not HasModelLoaded(model) do Citizen.Wait(0) end
    local object = CreateObject(model, pos.x, pos.y, pos.z, true, true, true)

    AttachEntityToEntity(object, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 18905), 0.59, 0.0, 0.0, 0.0, 266.0, 90.0, true, true, false, true, 1, true)

    while true do
        Citizen.Wait(1)
        if IsControlJustPressed(0, 38) then
            local curVeh = QBCore.Functions.GetClosestVehicle()
            local curVehLocatie = GetEntityCoords(curVeh)
            local pedPos = GetEntityCoords(PlayerPedId())
            if GetDistanceBetweenCoords(curVehLocatie, pedPos, true) < 4 then
                DeleteEntity(object)
                StopAnimTask(PlayerPedId(), "missheistdocksprep1hold_cellphone", "static", 0)
                loadAnimDict("timetable@gardener@filling_can")
                TaskPlayAnim(ped, "timetable@gardener@filling_can", "gar_ig_5_filling_can", 2.0, 8.0, -1, 31, 0, 0, 0, 0)
                QBCore.Functions.Progressbar("reful_boat", "Tank bijvullen...", 3500, false, false, {
                    disableMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                }, {}, {}, {}, function() -- Done
                    exports['LegacyFuel']:SetFuel(curVeh, 100)
                    QBCore.Functions.Notify('De tank is gevuld!', 'success')
                end, function() -- Cancel
                    QBCore.Functions.Notify('Mislukt!', 'error')
                end)
                return
            end
        elseif IsControlJustPressed(0, 47) then
            DeleteEntity(object)
            StopAnimTask(PlayerPedId(), "anim@heists@box_carry@", "idle", 0)
            ClearPedTasksImmediately(PlayerPedId())
            QBCore.Functions.Notify("Geannuleerd!", "error")
            return
        end
    end
end

function Turbopakken()
    closeMenuFull()
    QBCore.Functions.Progressbar("untowing_vehicle", "Een turbo aan het pakken..", 1000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "mini@repair", 
        anim = "fixing_a_ped",
        flags = 16,
    }, {}, {}, function() -- Done
        StopAnimTask(GetPlayerPed(-1), "mini@repair", "fixing_a_ped", 1.0)
        pakturbo()
    end, function() -- Cancel
        ClearPedTasks(GetPlayerPed(-1))
        StopAnimTask(GetPlayerPed(-1), "mini@repair", "fixing_a_ped", 1.0)
        QBCore.Functions.Notify("Mislukt!", "error")
    end)
end

function pakturbo()
    local pos = GetEntityCoords(PlayerPedId(), true) 
    RequestAnimDict("anim@heists@box_carry@")
    loadAnimDict("anim@heists@box_carry@")
    TaskPlayAnim(PlayerPedId(), "anim@heists@box_carry@" ,"idle", 5.0, -1, -1, 50, 0, false, false, false)
    local model = GetHashKey("hei_prop_heist_box")
    RequestModel(model)
    while not HasModelLoaded(model) do Citizen.Wait(0) end
    local object = CreateObject(model, pos.x, pos.y, pos.z, true, true, true)

    AttachEntityToEntity(object, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 60309), 0.025, 0.08, 0.255, -145.0, 290.0, 0.0, true, true, false, true, 1, true)

    while true do
        Citizen.Wait(1)
        if IsControlJustPressed(0, 38) then
            local curVeh = QBCore.Functions.GetClosestVehicle()
            local kenteken = GetVehicleNumberPlateText(curVeh)
            local spawnNaam = GetDisplayNameFromVehicleModel(GetEntityModel(curVeh))
            local hash = GetHashKey(spawnNaam)
            QBCore.Functions.TriggerCallback("fortis-anwbmissies:server:check", function(resultaat)
                print(resultaat)
                if resultaat ~= annuleren then
                    if GetVehicleClass(curVeh) ~= 18 then
                        local curVehLocatie = GetEntityCoords(curVeh)
                        local pedPos = GetEntityCoords(PlayerPedId())
                        if GetDistanceBetweenCoords(curVehLocatie, pedPos, true) < 4 then
                            if resultaat[1] == false then
                                var = true
                                titlevar = "Turbo installeren..."
                                mogelijk = true
                            elseif resultaat[1] ~= nil then
                                var = false
                                titlevar = "Turbo deinstalleren..."
                                mogelijk = true
                            end
                            if resultaat == "straatvoertuig" then
                                mogelijk = false
                            end                    
                            Citizen.Wait(300)

                            if mogelijk then
                                QBCore.Functions.Progressbar("reful_boat", ""..titlevar.."", 1000, false, false, {
                                    disableMovement = true,
                                    disableMouse = false,
                                    disableCombat = true,
                                }, {}, {}, {}, function() -- Done
                                    ToggleVehicleMod(curVeh, 18, var)
                                    DeleteEntity(object)
                                    StopAnimTask(PlayerPedId(), "anim@heists@box_carry@", "idle", 0)
                                    Citizen.Wait(250)
                                    local props = QBCore.Functions.GetVehicleProperties(curVeh)
                                    TriggerServerEvent('fortis-anwbmissies:server:updateVehicleStatus', kenteken,  props)
                                    ClearPedTasksImmediately(PlayerPedId())
                                    QBCore.Functions.Notify("Druk op G om het de turbo weg te leggen!")
                                end, function() -- Cancel
                                    QBCore.Functions.Notify('Mislukt!', 'error')
                                end)
                            else
                                QBCore.Functions.Notify("Turbo's kunnen niet op niet geregistreerde voertuigen geplaatst worden!", 'error')
                            end
                        end
                    else
                        QBCore.Functions.Notify("Aan dit voertuig doen we geen aanpassingen!", "error")
                    end
                end
            end, kenteken, hash, spawnNaam)

        elseif IsControlJustPressed(0, 47) then
            DeleteEntity(object)
            StopAnimTask(PlayerPedId(), "anim@heists@box_carry@", "idle", 0)
            ClearPedTasksImmediately(PlayerPedId())
            QBCore.Functions.Notify("Geannuleerd!", "error")
            return
        end
    end
end

function UitlaatPakken()
    closeMenuFull()
    QBCore.Functions.Progressbar("untowing_vehicle", "Een uitlaat aan het pakken..", 1000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "mini@repair", 
        anim = "fixing_a_ped",
        flags = 16,
    }, {}, {}, function() -- Done
        StopAnimTask(GetPlayerPed(-1), "mini@repair", "fixing_a_ped", 1.0)
        paktuitlaat()
    end, function() -- Cancel
        ClearPedTasks(GetPlayerPed(-1))
        StopAnimTask(GetPlayerPed(-1), "mini@repair", "fixing_a_ped", 1.0)
        QBCore.Functions.Notify("Mislukt!", "error")
    end)
end

function paktuitlaat()
    local pos = GetEntityCoords(PlayerPedId(), true) 
    RequestAnimDict("anim@heists@box_carry@")
    loadAnimDict("anim@heists@box_carry@")
    TaskPlayAnim(PlayerPedId(), "anim@heists@box_carry@" ,"idle", 5.0, -1, -1, 50, 0, false, false, false)
    local model = GetHashKey("prop_car_exhaust_01")
    RequestModel(model)
    while not HasModelLoaded(model) do Citizen.Wait(0) end
    local object = CreateObject(model, pos.x, pos.y, pos.z, true, true, true)

    AttachEntityToEntity(object, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), 0.15, 0.0, 0.0, -90.0, 180.0, 45.0, true, true, false, true, 1, true)

    while true do
        Citizen.Wait(1)
        if IsControlJustPressed(0, 38) then
            local curVeh = QBCore.Functions.GetClosestVehicle()
            local curVehLocatie = GetEntityCoords(curVeh)
            local pedPos = GetEntityCoords(PlayerPedId())
            if GetDistanceBetweenCoords(curVehLocatie, pedPos, true) < 4 then
                QBCore.Functions.Progressbar("reful_boat", "De uitlaat aan het moneteren...", 4500, false, false, {
                    disableMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                }, {}, {}, {}, function() -- Done
                    DeleteEntity(object)
                    StopAnimTask(PlayerPedId(), "anim@heists@box_carry@", "idle", 0)
                    ClearPedTasksImmediately(PlayerPedId())
                    SetVehicleDirtLevel(curVeh, 0.0)
                    SetVehicleUndriveable(curVeh, false)
                    WashDecalsFromVehicle(curVeh, 1.0)
                    QBCore.Functions.Notify("Uilaat succesvol geplaatst!")
                    SetVehicleFixed(curVeh)
                end, function() -- Cancel
                    QBCore.Functions.Notify('Mislukt!', 'error')
                end)
                return
            end
        elseif IsControlJustPressed(0, 47) then
            DeleteEntity(object)
            StopAnimTask(PlayerPedId(), "anim@heists@box_carry@", "idle", 0)
            ClearPedTasksImmediately(PlayerPedId())
            QBCore.Functions.Notify("Geannuleerd!", "error")
            return
        end
    end
end

function RemmenPakken()
    closeMenuFull()
    QBCore.Functions.Progressbar("untowing_vehicle", "Een remschoen aan het pakken..", 1000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "mini@repair", 
        anim = "fixing_a_ped",
        flags = 16,
    }, {}, {}, function() -- Done
        StopAnimTask(GetPlayerPed(-1), "mini@repair", "fixing_a_ped", 1.0)
        paktremmen()
    end, function() -- Cancel
        ClearPedTasks(GetPlayerPed(-1))
        StopAnimTask(GetPlayerPed(-1), "mini@repair", "fixing_a_ped", 1.0)
        QBCore.Functions.Notify("Mislukt!", "error")
    end)
end

function paktremmen()
    local pos = GetEntityCoords(PlayerPedId(), true) 
    RequestAnimDict("anim@heists@box_carry@")
    loadAnimDict("anim@heists@box_carry@")
    TaskPlayAnim(PlayerPedId(), "anim@heists@box_carry@" ,"idle", 5.0, -1, -1, 50, 0, false, false, false)
    local model = GetHashKey("imp_prop_impexp_brake_caliper_01a")
    RequestModel(model)
    while not HasModelLoaded(model) do Citizen.Wait(0) end
    local object = CreateObject(model, pos.x, pos.y, pos.z, true, true, true)

    AttachEntityToEntity(object, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), 0.15, 0.0, 0.0, -90.0, 180.0, 45.0, true, true, false, true, 1, true)

    while true do
        Citizen.Wait(1)
        if IsControlJustPressed(0, 38) then
            local curVeh = QBCore.Functions.GetClosestVehicle()
            local kenteken = GetVehicleNumberPlateText(curVeh)
            local spawnNaam = GetDisplayNameFromVehicleModel(GetEntityModel(curVeh))
            local hash = GetHashKey(spawnNaam)
            QBCore.Functions.TriggerCallback("fortis-anwbmissies:server:check", function(resultaat)
                if resultaat ~= annuleren then
                    if GetVehicleClass(curVeh) ~= 18 then
                        local curVehLocatie = GetEntityCoords(curVeh)
                        local pedPos = GetEntityCoords(PlayerPedId())
                        if GetDistanceBetweenCoords(curVehLocatie, pedPos, true) < 4 then

                            if resultaat[2] == -1 then
                                var = true
                                titlevar = "Rem upgrade installeren..."
                            elseif resultaat[2] == 0 then
                                var = false
                                titlevar = "Rem upgrade deinstalleren..."
                            end
                            if resultaat == "straatvoertuig" then
                                mogelijk = false
                            end
                        
                            Citizen.Wait(300)
                            if mogelijk ~= false then
                                QBCore.Functions.Progressbar("reful_boat", ""..titlevar.."", 7500, false, false, {
                                    disableMovement = true,
                                    disableMouse = false,
                                    disableCombat = true,
                                }, {}, {}, {}, function() -- Done
                                    SetVehicleModKit(curVeh, 0)
                                    if var == false then
                                        SetVehicleMod(curVeh, 12, -1, true)
                                        QBCore.Functions.Notify("Remmen standaard gemaakt!")
                                    
                                    elseif var == true then
                                        SetVehicleMod(curVeh, 12, 0, true)
                                        QBCore.Functions.Notify("Remmen upgrade geplaatst!")
                                    end
                                    local props = QBCore.Functions.GetVehicleProperties(curVeh)    
                                    StopAnimTask(PlayerPedId(), "anim@heists@box_carry@", "idle", 0)
                                    Citizen.Wait(250)
                                    local props = QBCore.Functions.GetVehicleProperties(curVeh)
                                    TriggerServerEvent('fortis-anwbmissies:server:updateVehicleStatus', kenteken,  props)
                                    ClearPedTasksImmediately(PlayerPedId())
                                end, function() -- Cancel
                                    QBCore.Functions.Notify('Mislukt!', 'error')
                                end)
                                return
                            else
                                QBCore.Functions.Notify('Remmen kunnen niet op niet geregistreerde voertuigen geplaatst worden!', 'error')
                            end
                        end
                    else
                        QBCore.Functions.Notify("Aan dit voertuig doen we geen aanpassingen!", "error")
                    end
                end                
            end, kenteken, hash, spawnNaam)
        elseif IsControlJustPressed(0, 47) then
            DeleteEntity(object)
            StopAnimTask(PlayerPedId(), "anim@heists@box_carry@", "idle", 0)
            ClearPedTasksImmediately(PlayerPedId())
            QBCore.Functions.Notify("Geannuleerd!", "error")
            return
        end
    end
end

function NeonKleurKeuze()
    ClearMenu()
    Menu.addButton("Roze €6.250", "Rozeneon", nil)
    Menu.addButton("Rood €6.500", "Rodeneon", nil)
    Menu.addButton("Wit €7.000", "Witteneon", nil)
    Menu.addButton("Geel €7.500", "Geleneon", nil)
    Menu.addButton("Blauw €8.000", "Blauweneon", nil)
    Menu.addButton("Rood €8.500", "Rodeneon", nil)
    Menu.addButton("Blacklight €10.000", "Blacklight", nil)
    Menu.addButton("Sluiten", "closeMenuFull", nil)
end

function Witteneon()
    ClearMenu()
    r = 222
    g = 222
    b = 225
    Neonpakken()
end
function Blauweneon()
    ClearMenu()
    r = 2
    g = 21
    b = 255
    Neonpakken()
end
function Geleneon()
    ClearMenu()
    r = 255
    g = 255
    b = 0
    Neonpakken()
end
function Rodeneon()
    ClearMenu()
    r = 255
    g = 1
    b = 1
    Neonpakken()
end
function Rozeneon()
    ClearMenu()
    r = 255
    g = 5
    b = 190
    Neonpakken()
end
function Blacklight()
    ClearMenu()
    r = 15
    g = 3
    b = 255
    Neonpakken()
end

function Neonpakken()
    closeMenuFull()
    QBCore.Functions.Progressbar("untowing_vehicle", "Neon aan het pakken..", 1000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "mini@repair", 
        anim = "fixing_a_ped",
        flags = 16,
    }, {}, {}, function() -- Done
        StopAnimTask(GetPlayerPed(-1), "mini@repair", "fixing_a_ped", 1.0)
        paktneon()
    end, function() -- Cancel
        ClearPedTasks(GetPlayerPed(-1))
        StopAnimTask(GetPlayerPed(-1), "mini@repair", "fixing_a_ped", 1.0)
        QBCore.Functions.Notify("Mislukt!", "error")
    end)
end

function paktneon()
    local pos = GetEntityCoords(PlayerPedId(), true) 
    RequestAnimDict("anim@heists@box_carry@")
    loadAnimDict("anim@heists@box_carry@")
    TaskPlayAnim(PlayerPedId(), "anim@heists@box_carry@" ,"idle", 5.0, -1, -1, 50, 0, false, false, false)
    local model = GetHashKey("hei_prop_heist_box")
    RequestModel(model)
    while not HasModelLoaded(model) do Citizen.Wait(0) end
    local object = CreateObject(model, pos.x, pos.y, pos.z, true, true, true)

    AttachEntityToEntity(object, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 60309), 0.025, 0.08, 0.255, -145.0, 290.0, 0.0, true, true, false, true, 1, true)

    while true do
        Citizen.Wait(1)
        if IsControlJustPressed(0, 38) then
            local curVeh = QBCore.Functions.GetClosestVehicle()
            local kenteken = GetVehicleNumberPlateText(curVeh)
            local spawnNaam = GetDisplayNameFromVehicleModel(GetEntityModel(curVeh))
            local hash = GetHashKey(spawnNaam)
            QBCore.Functions.TriggerCallback("fortis-anwbmissies:server:check", function(resultaat)
                if resultaat ~= annuleren then
                    if GetVehicleClass(curVeh) ~= 18 then
                        local curVehLocatie = GetEntityCoords(curVeh)
                        local pedPos = GetEntityCoords(PlayerPedId())
                        if GetDistanceBetweenCoords(curVehLocatie, pedPos, true) < 4 then
                            if resultaat ~= "straatvoertuig" then
                                if resultaat[3][1] == false then
                                    var = true
                                    titlevar = "Neon aan het installeren..."
                                    mogelijk = true
                                elseif resultaat[3][1] == 1 then
                                    var = false
                                    titlevar = "Neon aan het verwijderen..."
                                    mogelijk = true
                                end 
                            elseif resultaat == "straatvoertuig" then
                                mogelijk = false
                            end

                            Citizen.Wait(300)
                            if mogelijk then
                                QBCore.Functions.Progressbar("reful_boat", ""..titlevar.."", 1000, false, true, {
                                    disableMovement = true,
                                    disableMouse = false,
                                    disableCombat = true,
                                }, {}, {}, {}, function() -- Done
                                    if var == true then
                                        SetVehicleNeonLightEnabled(curVeh, 0, true)
                                        SetVehicleNeonLightEnabled(curVeh, 1, true)
                                        SetVehicleNeonLightEnabled(curVeh, 2, true)
                                        SetVehicleNeonLightEnabled(curVeh, 3, true)
                                    elseif var == false then
                                        SetVehicleNeonLightEnabled(curVeh, 0, false)
                                        SetVehicleNeonLightEnabled(curVeh, 1, false)
                                        SetVehicleNeonLightEnabled(curVeh, 2, false)
                                        SetVehicleNeonLightEnabled(curVeh, 3, false)
                                    end
                                    SetVehicleNeonLightsColour(curVeh, r, g, b)
                                    DeleteEntity(object)
                                    StopAnimTask(PlayerPedId(), "anim@heists@box_carry@", "idle", 0)
                                    Citizen.Wait(250)
                                    local props = QBCore.Functions.GetVehicleProperties(curVeh)
                                    TriggerServerEvent('fortis-anwbmissies:server:updateVehicleStatus', kenteken,  props)
                                    ClearPedTasksImmediately(PlayerPedId())
                                end, function() -- Cancel
                                    QBCore.Functions.Notify('Mislukt!', 'error')
                                end)
                                return
                            else
                                QBCore.Functions.Notify('Neon kan niet op niet geregistreerde voertuigen geplaatst worden!', 'error')
                            end
                        end
                    else
                        QBCore.Functions.Notify("Aan dit voertuig doen we geen aanpassingen!", "error")
                    end
                end
            end, kenteken, hash, spawnNaam)

        elseif IsControlJustPressed(0, 47) then
            DeleteEntity(object)
            StopAnimTask(PlayerPedId(), "anim@heists@box_carry@", "idle", 0)
            ClearPedTasksImmediately(PlayerPedId())
            QBCore.Functions.Notify("Geannuleerd!", "error")
            return
        end
    end
end

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

function closeMenuFull()
    Menu.hidden = true
    currentGarage = nil
    ClearMenu()
end

derunTow = function(coords)
    QBCore.Functions.Progressbar("untowing_vehicle", "Voertuig ontkoppelen..", 5000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "mini@repair",
        anim = "fixing_a_ped",
        flags = 16,
    }, {}, {}, function() -- Done
        StopAnimTask(GetPlayerPed(-1), "mini@repair", "fixing_a_ped", 1.0)
        FreezeEntityPosition(CurrentTow, false)
        Citizen.Wait(250)
        DetachEntity(CurrentTow, true, true)
        local heading = GetEntityHeading(GetPlayerPed(-1))
        local pedPos = GetEntityCoords(GetPlayerPed(-1))
        SetEntityCoords(CurrentTow, pedPos.x, pedPos.y - 0.5, pedPos.z)
        SetEntityHeading(CurrentTow, heading)
        CurrentTow = nil
    end, function() -- Cancel
        StopAnimTask(GetPlayerPed(-1), "mini@repair", "fixing_a_ped", 1.0)
        QBCore.Functions.Notify("Mislukt!", "error")
    end)
end 

runTow = function(vehicle, veh)
    if not IsPedInAnyVehicle(GetPlayerPed(-1)) then
        if veh ~= CurrentTow then
            local towPos = GetEntityCoords(vehicle)
            local targetPos = GetEntityCoords(veh)
            if GetDistanceBetweenCoords(towPos.x, towPos.y, towPos.z, targetPos.x, targetPos.y, targetPos.z, true) < 30.0 then
                QBCore.Functions.Progressbar("towing_vehicle", "Voertuig opzetten..", 5000, false, true, {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                }, {
                    animDict = "mini@repair",
                    anim = "fixing_a_ped",
                    flags = 16,
                }, {}, {}, function() -- Done
                    StopAnimTask(GetPlayerPed(-1), "mini@repair", "fixing_a_ped", 1.0)
                    AttachEntityToEntity(veh, vehicle, GetEntityBoneIndexByName(vehicle, 'bodyshell'), 0.0, 1.5 + -0.85, -0.55 + 0.9, 0, 0, 0, 1, 1, 0, 1, 0, 1)
                    SetEntityHeading(veh, GetEntityHeading(vehicle))
                    FreezeEntityPosition(veh, true)
                    CurrentTow = veh
                    if NpcOn then
                        RemoveBlip(CurrentBlip)
                        QBCore.Functions.Notify("Breng het voertuig naar het Hayes Depot!", "success", 5000)
                    end
                    QBCore.Functions.Notify("Ga als je het voeruig wilt afhalen staan waar het voertuig moet komen", "success", 5000)
                end, function() -- Cancel
                    StopAnimTask(GetPlayerPed(-1), "mini@repair", "fixing_a_ped", 1.0)
                    QBCore.Functions.Notify("Mislukt!", "error")
                end)
            end
        end
    end
end

function deliverVehicle(voertuig)
    DeleteVehicle(voertuig)
    CurrentTow = nil
    TriggerServerEvent("qb-tow:server:krijggeld")
end

function getVehicleInDirection(coordFrom, coordTo)
	local rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 10, PlayerPedId(), 0)
	local a, b, c, d, vehicle = GetRaycastResult(rayHandle)
	return vehicle
end

function getRandomVehicleLocation()
    local randomVehicle = math.random(1, #Config.Locations["towspots"])
    while (randomVehicle == LastVehicle) do
        Citizen.Wait(10)
        randomVehicle = math.random(1, #Config.Locations["towspots"])
    end
    return randomVehicle
end

function isTowVehicle(vehicle)
    local retval = false
    for k, v in pairs(Config.Vehicles) do
        if GetEntityModel(vehicle) == GetHashKey(k) then
            retval = true
        end
    end
    return retval
end

function IsTrailer(trailer)
    local retval = false 
    for k, v in pairs(Config.Trailers) do
        if GetEntityModel(trailer) == GetHashKey(k) then
            retval = true
        end
    end
    return retval
end

function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end 

-- Coords for the first elevator prop (doesnt need heading)
local elevator2BaseX = -374.6
local elevator2BaseY = -95.3
local elevator2BaseZ = 37.95
-----

-- Coords for the secondlevator prop
local elevatorBaseX = -373.1
local elevatorBaseY = -90.93
local elevatorBaseZ = 37.95
local elevator2BaseHeading = -20.0
-----


local elevatorProp = nil
local elevatorUp = false
local elevatorDown = false
local elevator2Prop = nil
local elevator2Up = false
local elevator2Down = false
local la_nacelle_estelle_la = false

function deleteObject(object)
	return Citizen.InvokeNative(0x539E0AE3E6634B9F, Citizen.PointerValueIntInitialized(object))
end

function createObject(model, x, y, z)
	RequestModel(model)
	while (not HasModelLoaded(model)) do
		Citizen.Wait(0)
	end
	return CreateObject(model, x, y, z, true, true, false)
end

function spawnProp(propName, x, y, z)
	local model = GetHashKey(propName)
	
	if IsModelValid(model) then
		local pos = GetEntityCoords(GetPlayerPed(-1), true)
		local forward = 5.0
		local heading = GetEntityHeading(GetPlayerPed(-1))
		local xVector = forward * math.sin(math.rad(heading)) * -1.0
		local yVector = forward * math.cos(math.rad(heading))
        
		elevatorProp = createObject(model, x, y, z)
		local propNetId = ObjToNet(elevatorProp)
		SetNetworkIdExistsOnAllMachines(propNetId, true)
		NetworkSetNetworkIdDynamic(propNetId, true)
		SetNetworkIdCanMigrate(propNetId, true)
        
		SetEntityLodDist(elevatorProp, 0xFFFF)
		SetEntityCollision(elevatorProp, true, true)
		FreezeEntityPosition(elevatorProp, true)
		SetEntityCoords(elevatorProp, x, y, z, false, false, false, false)
        SetEntityHeading(elevatorProp, elevator2BaseHeading)
	end
end

function spawnProp2(propName, x, y, z)
	local model = GetHashKey(propName)
	
	if IsModelValid(model) then
		local pos = GetEntityCoords(GetPlayerPed(-1), true)
		local forward = 5.0
		local heading = GetEntityHeading(GetPlayerPed(-1))
		local xVector = forward * math.sin(math.rad(heading)) * -1.0
		local yVector = forward * math.cos(math.rad(heading))
        
		elevator2Prop = createObject(model, x, y, z)
		local propNetId = ObjToNet(elevator2Prop)
		SetNetworkIdExistsOnAllMachines(propNetId, true)
		NetworkSetNetworkIdDynamic(propNetId, true)
		SetNetworkIdCanMigrate(propNetId, true)
		SetEntityLodDist(elevator2Prop, 0xFFFF)
		SetEntityCollision(elevator2Prop, true, true)
		FreezeEntityPosition(elevator2Prop, true)
		SetEntityCoords(elevator2Prop, x, y, z, false, false, false, false)
		SetEntityHeading(elevator2Prop, elevator2BaseHeading)
	end
end
 

function Main()
    lijstAantal = 1
    paginaNummer = 1
    ped = GetPlayerPed(-1)
    MenuTitle = "Lift bediening:"
    ClearMenu()
    Menu.addButton("Lift bediening", "BeschikbareOnderdelen1", nil)
    Menu.addButton("Sluiten", "closeMenuFull", nil)
end

function BeschikbareOnderdelen1()
    ClearMenu()
    Menu.addButton("Omhoog", "Omhoog2", nil)
    Menu.addButton("Stoppen", "Stoppen2", nil)
    Menu.addButton("Omlaag", "Omlaag2", nil)
    Menu.addButton("Spawn RECHTS", "spawnrechts", nil)
    Menu.addButton("Delete RECHTS (altijd doen als je klaar bent)", "DEBUGRECHTS", nil)
    Menu.addButton("Sluiten", "closeMenuFull", nil)

    if Config.debug then
        Menu.addButton("DEBUG", "DEBUG", nil)
	end
end

function Omhoog2()
    if elevatorProp ~= nil then
        elevatorDown = false
        elevatorUp = true
        elevatorStop = false
    end
end

function Stoppen2()
    if elevatorProp ~= nil then
        elevatorUp = false
        elevatorDown = false
    end
end

function Omlaag2()
    if elevatorProp ~= nil then
        elevatorUp = false
        elevatorDown = true
        elevatorStop = false
    end
end

function DEBUG()
    deleteObject(elevatorProp)
    deleteObject(elevator2Prop)
end

-- 2e lift \/

function Main2()
    lijstAantal = 1
    paginaNummer = 1
    ped = GetPlayerPed(-1)
    MenuTitle = "Lift bediening:"
    ClearMenu()
    Menu.addButton("Lift bediening", "BeschikbareOnderdelen2", nil)
    Menu.addButton("Sluiten", "closeMenuFull", nil)
end

function BeschikbareOnderdelen2()
    ClearMenu()
    Menu.addButton("Omhoog", "Omhoog", nil)
    Menu.addButton("Stoppen", "Stoppen", nil)
    Menu.addButton("Omlaag", "Omlaag", nil)
    Menu.addButton("Sluiten", "closeMenuFull", nil)
    Menu.addButton("Spawn LINKS", "spawnlinks", nil)
    Menu.addButton("Delete LINKS (altijd doen als je klaar bent)", "DEBUGlinks", nil)

    if Config.debug then
        Menu.addButton("DEBUG", "DEBUG2", nil)
	end
end

function Omhoog()
    if elevator2Prop ~= nil then
        elevator2Down = false
        elevator2Up = true
        elevator2Stop = false
    end
end

function Stoppen()
    if elevator2Prop ~= nil then
        elevator2Up = false
        elevator2Down = false
    end
end

function Omlaag()
    if elevator2Prop ~= nil then
        elevator2Up = false
        elevator2Down = true
        elevator2Stop = false
    end
end

function DEBUGlinks()
    DeleteEntity(elevator2Prop)
    -- deleteObject(elevatorProp)
end

function spawnrechts()
    spawnProp("nacelle", elevatorBaseX, elevatorBaseY, elevatorBaseZ)
end

function DEBUGRECHTS()
    DeleteEntity(elevatorProp)
    -- deleteObject(elevatorProp)
end

function spawnlinks()
    spawnProp2("nacelle", elevator2BaseX, elevator2BaseY, elevator2BaseZ)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

		local elevatorCoords = GetEntityCoords(elevatorProp, false)


		if elevatorUp then
			if elevatorCoords.z < Config.max then
				if (elevatorCoords.z > Config.beforemax) then
					elevatorBaseZ = elevatorBaseZ + Config.speed_up_slow 
					SetEntityCoords(elevatorProp, elevatorBaseX, elevatorBaseY, elevatorBaseZ, false, false, false, false)
				else
					elevatorBaseZ = elevatorBaseZ + Config.speed_up
					SetEntityCoords(elevatorProp, elevatorBaseX, elevatorBaseY, elevatorBaseZ, false, false, false, false)
				end
			end
		end
		
		if elevatorDown then
			if elevatorCoords.z > Config.min then
				if (elevatorCoords.z < Config.beforemin) then
					elevatorBaseZ = elevatorBaseZ - Config.speed_down_slow
					SetEntityCoords(elevatorProp, elevatorBaseX, elevatorBaseY, elevatorBaseZ, false, false, false, false)
				else
					elevatorBaseZ = elevatorBaseZ - Config.speed_down
					SetEntityCoords(elevatorProp, elevatorBaseX, elevatorBaseY, elevatorBaseZ, false, false, false, false)
				end 
			end
		end

		local elevator2Coords = GetEntityCoords(elevator2Prop, false)
		if elevator2Up then
			if elevator2Coords.z < Config.max then
				if (elevator2Coords.z > Config.beforemax) then
					elevator2BaseZ = elevator2BaseZ + Config.speed_up_slow
					SetEntityCoords(elevator2Prop, elevator2BaseX, elevator2BaseY, elevator2BaseZ, false, false, false, false)
				else
					elevator2BaseZ = elevator2BaseZ + Config.speed_up
					SetEntityCoords(elevator2Prop, elevator2BaseX, elevator2BaseY, elevator2BaseZ, false, false, false, false)
				end
			end
        end

		if elevator2Down then
			if elevator2Coords.z > Config.min then
				if (elevator2Coords.z < Config.beforemin) then
					elevator2BaseZ = elevator2BaseZ - Config.speed_down_slow 
					SetEntityCoords(elevator2Prop, elevator2BaseX, elevator2BaseY, elevator2BaseZ, false, false, false, false)
				else
					elevator2BaseZ = elevator2BaseZ - Config.speed_up
					SetEntityCoords(elevator2Prop, elevator2BaseX, elevator2BaseY, elevator2BaseZ, false, false, false, false)
				end
			end
		end
    end
end)

local open = false

-- key controls
Citizen.CreateThread(function()
    while true do
        local pos = GetEntityCoords(GetPlayerPed(-1), false)
        if (Vdist(-369.13, -91.20, 39.01, pos.x, pos.y, pos.z - 1) < 10) then 
            Citizen.Wait(1)
            if QBCore.Functions.GetPlayerData().job.name == "mechanic" then

                if (Vdist(-369.13, -91.20, 39.01, pos.x, pos.y, pos.z - 1) < 2.5) then 
                    QBCore.Functions.DrawText3D(-369.13, -91.20, 39.01 + 0.10, "~g~E~w~ - Bedien lift")
                end

		        if (Vdist(-370.79, -95.72, 39.01, pos.x, pos.y, pos.z - 1) < 2.5) then 
                    QBCore.Functions.DrawText3D(-370.79, -95.72, 39.01 + 0.10, "~g~E~w~ - Bedien lift")
                end

		        if (Vdist(-369.13, -91.20, 39.01, pos.x, pos.y, pos.z - 1) < 1.5) then 
		        	if IsControlJustReleased(1, Config.Open_key) then 
		        		garage_menu = not garage_menu 
		        		Main() 
                        Menu.hidden = not Menu.hidden
		        	end
                    Menu.renderGUI()
		        elseif (Vdist(-370.79, -95.72, 39.01, pos.x, pos.y, pos.z - 1) < 1.5) then
		        	if IsControlJustReleased(1, Config.Open_key) then 
		        		garage_menu = not garage_menu
		        		Main2()
                        Menu.hidden = not Menu.hidden
		        	end
                    Menu.renderGUI()
		        else
		        	if (prevMenu == nil) then
		        		-- Menu.Switch(nil, "")
                        if menuOpen == true then
                            -- closeMenuFull()
                        end
		        		menuOpen = false
		        		if garage_menu then
		        			garage_menu = false
		        		end
		        		currentOption = 1
		        	elseif not (prevMenu == nil) then
		        		if not Menus[prevMenu].previous == nil then
		        			currentOption = 1
		        			Menu.Switch(nil, prevMenu)
		        		else
		        			if Menus[prevMenu].optionCount < currentOption then
		        				currentOption = Menus[prevMenu].optionCount
		        			end
		        			Menu.Switch(Menus[prevMenu].previous, prevMenu)
		        		end
		        	end
		        end
            
                if garage_menu then
		        	DisableControlAction(1, 22, true)
		        	DisableControlAction(1, 0, true)
		        	DisableControlAction(1, 27, true)
		        	DisableControlAction(1, 140, true)
		        	DisableControlAction(1, 141, true)
		        	DisableControlAction(1, 142, true)
		        	DisableControlAction(1, 20, true)
                
		        	DisableControlAction(1, 187, true)
                
		        	DisableControlAction(1, 80, true)
		        	DisableControlAction(1, 95, true)
		        	DisableControlAction(1, 96, true)
		        	DisableControlAction(1, 97, true)
		        	DisableControlAction(1, 98, true)
                
		        	DisableControlAction(1, 81, true)
		        	DisableControlAction(1, 82, true)
		        	DisableControlAction(1, 83, true)
		        	DisableControlAction(1, 84, true)
		        	DisableControlAction(1, 85, true)
                
		        	DisableControlAction(1, 74, true)
                
		        	HideHelpTextThisFrame()
		        	SetCinematicButtonActive(false)
                    -- Menu.DisplayCurMenu()
                end
            else
                Citizen.Wait(1000)
            end
        else
            Citizen.Wait(1000)
        end
    end
end)