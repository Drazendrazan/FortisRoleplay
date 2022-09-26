
QBCore = nil

Citizen.CreateThread(function() 
    if QBCore == nil then
        TriggerEvent("QBCore:GetObject", function(obj) QBCore = obj end)    
        Citizen.Wait(200)
    end
    PlayerData = QBCore.Functions.GetPlayerData()
end)

local box = nil
local showlib = 'anim@mp_fireworks'
local animlib = 'anim@mp_fireworks'
local firecoords = {x = 683.10, y = 570.52, z = 156.35} -- top podium
local firecoords2 = {x = 670.76, y = 574.32, z = 151.35} -- top podium
local firecoords3 = {x = 696.76, y = 566.32, z = 151.35} -- top podium
local firecoords4 = {x = 586.17, y = 528.98, z = 149.74} -- pilaar rechts vanaf podium
local firecoords5 = {x = 731.56, y = 476.46, z = 149.74} -- pilaar links vanaf podium
local vuurwerkreeks1 = {x = 716.05, y = 518.86, z = 131.84} -- reeks
local vuurwerkreeks2 = {x = 699.53, y = 517.14, z = 131.84} -- reeks
local vuurwerkreeks3 = {x = 695.05, y = 517.15, z = 131.84} -- reeks
local vuurwerkreeks4 = {x = 678.74, y = 519.1, z = 131.84} -- reeks
local vuurwerkreeks5 = {x = 674.23, y = 520.15, z = 131.84} -- reeks
local vuurwerkreeks6 = {x = 658.8, y = 525.83, z = 131.84} -- reeks
local vuurwerkreeks7 = {x = 654.77, y = 527.85, z = 131.84} -- reeks
local vuurwerkreeks8 = {x = 641.17, y = 536.81, z = 131.85} -- reeks
local vuurwerkreeks9 = {x = 637.33, y = 539.63, z = 131.85} -- reeks
local vuurwerkreeks10 = {x = 625.91, y = 551.63, z = 131.84} -- reeks


RegisterNetEvent("vuurwerk:client:startShow")
AddEventHandler("vuurwerk:client:startShow", function(muziek)
	if muziek then
		local geluid = "https://www.youtube.com/watch?v=Jez2HDFnz8I&list=PLeYBLPxSB6snO-GncD274qu4ReH4a7OB8&index=14&ab_channel=DeFeestkrakers-Topic"
		-- local locatie = {x = 659.511, y = 532.07, z = 130.24}
		local locatie = GetEntityCoords(PlayerPedId())
		TriggerServerEvent('vuurwerk:server:playMusic', geluid, currentData, locatie)
	end
	Citizen.Wait(19000)

	-- -- podium
	TriggerEvent("vuurwerk:client:Show1", 15)
	TriggerEvent("vuurwerk:client:Show2", 10)
	TriggerEvent("vuurwerk:client:Show3", 15)

    -- ----------------------------------------
	-- -- pilaren links en rechts
	TriggerEvent("vuurwerk:client:Show4", 30)
	TriggerEvent("vuurwerk:client:Show5", 30)
	-- ----------------------------------------
	-- -- vuurwerk reeks
	Citizen.Wait(17000)
	TriggerEvent("vuurwerk:client:ShowReeks", 20)
	Citizen.Wait(10000)
	TriggerEvent("vuurwerk:client:Show1", 15)
	TriggerEvent("vuurwerk:client:Show2", 10)
	TriggerEvent("vuurwerk:client:Show3", 15)
	TriggerEvent("vuurwerk:client:Show4", 30)
	TriggerEvent("vuurwerk:client:Show5", 30)
	Citizen.Wait(17000)
	TriggerEvent("vuurwerk:client:ShowReeks", 20)
	Citizen.Wait(10000)
	TriggerEvent("vuurwerk:client:Show1", 15)
	TriggerEvent("vuurwerk:client:Show2", 10)
	TriggerEvent("vuurwerk:client:Show3", 15)
	TriggerEvent("vuurwerk:client:Show4", 30)
	TriggerEvent("vuurwerk:client:Show5", 30)
	Citizen.Wait(17000)
	TriggerEvent("vuurwerk:client:ShowReeks", 20)
	-- print("reeks")
	---------------------------------------
end)

AddEventHandler("vuurwerk:client:Show1", function(amount)
	RequestAnimDict(showlib)

	while not HasAnimDictLoaded(showlib) do
		Citizen.Wait(1)
    end
        
	if not HasNamedPtfxAssetLoaded("scr_indep_fireworks") then
		RequestNamedPtfxAsset("scr_indep_fireworks")
		while not HasNamedPtfxAssetLoaded("scr_indep_fireworks") do
		   Wait(1)
		end
	end

	Citizen.Wait(1000)
	repeat
	UseParticleFxAssetNextCall("scr_indep_fireworks")
	local part1 = StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_shotburst", firecoords.x, firecoords.y, firecoords.z, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
	amount = amount - 1
	Citizen.Wait(2000)
	until(amount == 0)
end)

AddEventHandler("vuurwerk:client:Show2", function(amount)
	RequestAnimDict(showlib)

	while not HasAnimDictLoaded(showlib) do
		Citizen.Wait(1)
    end
        
	if not HasNamedPtfxAssetLoaded("scr_indep_fireworks") then
		RequestNamedPtfxAsset("scr_indep_fireworks")
		while not HasNamedPtfxAssetLoaded("scr_indep_fireworks") do
		   Wait(1)
		end
	end

	Citizen.Wait(1000)
	repeat
	UseParticleFxAssetNextCall("scr_indep_fireworks")
	local part1 = StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_starburst", firecoords2.x, firecoords2.y, firecoords2.z, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
	amount = amount - 1
	Citizen.Wait(2000)
	until(amount == 0)
end)

AddEventHandler("vuurwerk:client:Show3", function(amount)
	RequestAnimDict(showlib)

	while not HasAnimDictLoaded(showlib) do
		Citizen.Wait(1)
    end
        
	if not HasNamedPtfxAssetLoaded("scr_indep_fireworks") then
		RequestNamedPtfxAsset("scr_indep_fireworks")
		while not HasNamedPtfxAssetLoaded("scr_indep_fireworks") do
		   Wait(1)
		end
	end

	Citizen.Wait(1000)
	repeat
	UseParticleFxAssetNextCall("scr_indep_fireworks")
	local part1 = StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_trailburst", firecoords3.x, firecoords3.y, firecoords3.z, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
	amount = amount - 1
	Citizen.Wait(2000)
	until(amount == 0)
end)

AddEventHandler("vuurwerk:client:Show4", function(amount)
	RequestAnimDict(showlib)

	while not HasAnimDictLoaded(showlib) do
		Citizen.Wait(1)
    end
        
	if not HasNamedPtfxAssetLoaded("scr_indep_fireworks") then
		RequestNamedPtfxAsset("scr_indep_fireworks")
		while not HasNamedPtfxAssetLoaded("scr_indep_fireworks") do
		   Wait(1)
		end
	end

	Citizen.Wait(500)
	repeat
	UseParticleFxAssetNextCall("scr_indep_fireworks")
	local part1 = StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_trailburst", firecoords4.x, firecoords4.y, firecoords4.z, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
	amount = amount - 1
	Citizen.Wait(500)
	until(amount == 0)
end)

AddEventHandler("vuurwerk:client:Show5", function(amount)
	RequestAnimDict(showlib)

	while not HasAnimDictLoaded(showlib) do
		Citizen.Wait(1)
    end
        
	if not HasNamedPtfxAssetLoaded("scr_indep_fireworks") then
		RequestNamedPtfxAsset("scr_indep_fireworks")
		while not HasNamedPtfxAssetLoaded("scr_indep_fireworks") do
		   Wait(1)
		end
	end
 
	Citizen.Wait(500)
	repeat
	UseParticleFxAssetNextCall("scr_indep_fireworks")
	local part1 = StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_trailburst", firecoords5.x, firecoords5.y, firecoords5.z, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
	amount = amount - 1
	Citizen.Wait(500)
	until(amount == 0)
end)

AddEventHandler("vuurwerk:client:ShowReeks", function(amount)
	RequestAnimDict(showlib)

	while not HasAnimDictLoaded(showlib) do
		Citizen.Wait(1)
    end
        
	if not HasNamedPtfxAssetLoaded("scr_indep_fireworks") then
		RequestNamedPtfxAsset("scr_indep_fireworks")
		while not HasNamedPtfxAssetLoaded("scr_indep_fireworks") do
		   Wait(1)
		end
	end
 
	UseParticleFxAssetNextCall("scr_indep_fireworks")
	local part1 = StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_trailburst", vuurwerkreeks1.x, vuurwerkreeks1.y, vuurwerkreeks1.z, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
	UseParticleFxAssetNextCall("scr_indep_fireworks")
	Citizen.Wait(125)
	local part2 = StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_trailburst", vuurwerkreeks2.x, vuurwerkreeks2.y, vuurwerkreeks2.z, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
	UseParticleFxAssetNextCall("scr_indep_fireworks")
	Citizen.Wait(125)
	local part3 = StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_trailburst", vuurwerkreeks3.x, vuurwerkreeks3.y, vuurwerkreeks3.z, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
	UseParticleFxAssetNextCall("scr_indep_fireworks")
	Citizen.Wait(125)
	local part4 = StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_trailburst", vuurwerkreeks4.x, vuurwerkreeks4.y, vuurwerkreeks4.z, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
	UseParticleFxAssetNextCall("scr_indep_fireworks")
	Citizen.Wait(125)
	local part5 = StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_trailburst", vuurwerkreeks5.x, vuurwerkreeks5.y, vuurwerkreeks5.z, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
	UseParticleFxAssetNextCall("scr_indep_fireworks")
	Citizen.Wait(125)
	local part6 = StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_trailburst", vuurwerkreeks6.x, vuurwerkreeks6.y, vuurwerkreeks6.z, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
	UseParticleFxAssetNextCall("scr_indep_fireworks")
	Citizen.Wait(125)
	local part7 = StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_trailburst", vuurwerkreeks7.x, vuurwerkreeks7.y, vuurwerkreeks7.z, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
	UseParticleFxAssetNextCall("scr_indep_fireworks")
	Citizen.Wait(125)
	local part8 = StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_trailburst", vuurwerkreeks8.x, vuurwerkreeks8.y, vuurwerkreeks8.z, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
	UseParticleFxAssetNextCall("scr_indep_fireworks")
	local part9 = StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_trailburst", vuurwerkreeks9.x, vuurwerkreeks9.y, vuurwerkreeks9.z, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
	UseParticleFxAssetNextCall("scr_indep_fireworks")
	Citizen.Wait(125)
	local part10 = StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_trailburst", vuurwerkreeks10.x, vuurwerkreeks10.y, vuurwerkreeks10.z, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
	Citizen.Wait(750)
	-----------------------------------------------------------------
	UseParticleFxAssetNextCall("scr_indep_fireworks")
	local part11 = StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_trailburst", vuurwerkreeks10.x, vuurwerkreeks10.y, vuurwerkreeks10.z, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
	UseParticleFxAssetNextCall("scr_indep_fireworks")
	Citizen.Wait(125)
	local part12 = StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_trailburst", vuurwerkreeks9.x, vuurwerkreeks9.y, vuurwerkreeks9.z, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
	UseParticleFxAssetNextCall("scr_indep_fireworks")
	Citizen.Wait(125)
	local part13 = StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_trailburst", vuurwerkreeks8.x, vuurwerkreeks8.y, vuurwerkreeks8.z, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
	UseParticleFxAssetNextCall("scr_indep_fireworks")
	Citizen.Wait(125)
	local part14 = StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_trailburst", vuurwerkreeks7.x, vuurwerkreeks7.y, vuurwerkreeks7.z, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
	UseParticleFxAssetNextCall("scr_indep_fireworks")
	Citizen.Wait(125)
	local part15 = StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_trailburst", vuurwerkreeks6.x, vuurwerkreeks6.y, vuurwerkreeks6.z, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
	UseParticleFxAssetNextCall("scr_indep_fireworks")
	Citizen.Wait(125)
	local part16 = StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_trailburst", vuurwerkreeks5.x, vuurwerkreeks5.y, vuurwerkreeks5.z, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
	UseParticleFxAssetNextCall("scr_indep_fireworks")
	Citizen.Wait(125)
	local part17 = StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_trailburst", vuurwerkreeks4.x, vuurwerkreeks4.y, vuurwerkreeks4.z, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
	UseParticleFxAssetNextCall("scr_indep_fireworks")
	Citizen.Wait(125)
	local part18 = StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_trailburst", vuurwerkreeks3.x, vuurwerkreeks3.y, vuurwerkreeks3.z, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
	UseParticleFxAssetNextCall("scr_indep_fireworks")
	local part19 = StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_trailburst", vuurwerkreeks2.x, vuurwerkreeks2.y, vuurwerkreeks2.z, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
	UseParticleFxAssetNextCall("scr_indep_fireworks")
	Citizen.Wait(125)
	local part20 = StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_trailburst", vuurwerkreeks1.x, vuurwerkreeks1.y, vuurwerkreeks1.z, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
end)



RegisterNetEvent('fortis-fireworks:start')
AddEventHandler('fortis-fireworks:start', function(schoten, type)
	if type == 1 then
		vuurwerk = "scr_indep_firework_starburst"
	elseif type == 2 then
		vuurwerk = "scr_indep_firework_shotburst"
	elseif type == 3 then
		vuurwerk = "scr_indep_firework_trailburst"
	end

	RequestAnimDict(animlib)

	while not HasAnimDictLoaded(animlib) do
		   Citizen.Wait(10)
    end
        
	if not HasNamedPtfxAssetLoaded("scr_indep_fireworks") then
		RequestNamedPtfxAsset("scr_indep_fireworks")
		while not HasNamedPtfxAssetLoaded("scr_indep_fireworks") do
		   Wait(10)
		end
	end

	local pedcoords = GetEntityCoords(GetPlayerPed(-1))
	local ped = GetPlayerPed(-1)
	local times = schoten

	QBCore.Functions.Progressbar("untowing_vehicle", "Vuurwerk aan het plaasten..", 3000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "anim@mp_fireworks", 
        anim = "place_firework_3_box",
        flags = 16,
    }, {}, {}, function() -- Done
		ClearPedTasksImmediately(ClearPedTasks(ped))
		local box = CreateObject(GetHashKey('ind_prop_firework_03'), pedcoords, true, false, false)
		PlaceObjectOnGroundProperly(box)
		FreezeEntityPosition(box, true)
		local firecoords = GetEntityCoords(box)
	
		Citizen.Wait(10000)
		repeat
		UseParticleFxAssetNextCall("scr_indep_fireworks")
		local part1 = StartNetworkedParticleFxNonLoopedAtCoord(""..vuurwerk.."", firecoords, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
		times = times - 1
		Citizen.Wait(2000)
		until(times == 0)
		DeleteEntity(box)
		local box = nil
    end, function() -- Cancel
        ClearPedTasks(GetPlayerPed(-1))
        StopAnimTask(GetPlayerPed(-1), "mini@repair", "fixing_a_ped", 1.0)
        QBCore.Functions.Notify("Mislukt!", "error")
    end)
end)