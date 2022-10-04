QBCore = nil

Citizen.CreateThread(function()
	while QBCore == nil do
		TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
		Citizen.Wait(1)
	end
end)

local MissionMarker =  vector3(-457.26, -2283.77, 7.21) --<<place where is the marker with the mission
local dealerCoords =  vector3(-457.26, -2283.77, 7.21)  							--<< place where the NPC dealer stands
local VehicleSpawn1 = vector3(-1327.479736328, -86.045326232910, 49.31)  		--<< below the coordinates for random vehicle responses
local VehicleSpawn2 = vector3(-2075.888183593, -233.73908996580, 21.10)
local VehicleSpawn3 = vector3(-972.1781616210, -1530.9045410150, 4.890)
local VehicleSpawn4 = vector3(798.18426513672, -1799.8173828125, 29.33)
local VehicleSpawn5 = vector3(1247.0718994141, -344.65634155273, 69.08)
local DriverWep = "WEAPON_COMBATPISTOL" 		--<< the weapon the driver is to be equipped with
local NavWep = "WEAPON_COMBATPISTOL"  			--<< the weapon the guard should be equipped with
local TimeToBlow = 15 * 1000 				--<< bomb detonation time after planting, default 20 seconds
local PickupMoney = 0
local BlowBackdoor = 0
local SilenceAlarm = 0
local PoliceAlert = 0
local PoliceBlip = 0
local moneyCalc = 1
local LootTime = 1
local GuardsDead = 0
local prop
local lootable = 0
local BlownUp = 0
local TruckBlip
local transport
local MissionStart = 0 
local warning = 0
local VehicleCoords = nil
local spawned = false
local melding = false
local PlayerJob = {} 
 
RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    QBCore.Functions.GetPlayerData(function(PlayerData)
        PlayerJob = PlayerData.job
    end)
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate')
AddEventHandler('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
end)

function hintToDisplay(text)
	SetTextComponentFormat("STRING")
	AddTextComponentString(text)
	DisplayHelpTextFromStringLabel(0, 0, 1, 20000)
end

function DrawText3D(x, y, z, text)
    local onScreen,_x,_y=World3dToScreen2d(x, y, z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.3, 0.3)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 90)
end

function IsWearingHandshoes()
    local armIndex = GetPedDrawableVariation(GetPlayerPed(-1), 3)
    local model = GetEntityModel(GetPlayerPed(-1))
    local retval = true
	
    if model == GetHashKey("mp_m_freemode_01") then
        if MaleNoHandshoes[armIndex] ~= nil and MaleNoHandshoes[armIndex] then
            retval = false
        end
    else 
        if FemaleNoHandshoes[armIndex] ~= nil and FemaleNoHandshoes[armIndex] then
            retval = false
        end
    end
    return retval
end

--Ped spawn and mission accept
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        local plyCoords = GetEntityCoords(PlayerPedId(), false)
        local dist = #(plyCoords - vector3(MissionMarker.x, MissionMarker.y, MissionMarker.z))

		RequestModel(GetHashKey("stockade"))
		if not spawned then
			while not HasModelLoaded(GetHashKey("stockade")) do
				Citizen.Wait(10)
			end
			local gruppe6 = CreateVehicle(GetHashKey("stockade"), dealerCoords.x, dealerCoords.y, dealerCoords.z - 1, 269.0, false, false)
			SetVehicleDoorsLocked(gruppe6, 1)
			SetVehicleHasBeenOwnedByPlayer(gruppe6, true)
			SetModelAsNoLongerNeeded(gruppe6)
			FreezeEntityPosition(gruppe6, true)
			spawned = true
		end

        if dist <= 1.0 then
			if IsPedInAnyVehicle(PlayerPedId(), false) then
				if GetVehicleDoorLockStatus(vehicle) == 2 then
					SetVehicleDoorsLocked(vehicle, 1)
				end
				DrawText3D(dealerCoords.x, dealerCoords.y, dealerCoords.z + 1 , "~g~[E]~w~ Waardetransport onderscheppen! $10.000")
				if IsControlJustPressed(0, 38) then
					QBCore.Functions.TriggerCallback("zb-truckrobbery:server:checkvoorreboot", function(resultaat)
						if resultaat then
							QBCore.Functions.Progressbar("repair_part", "reboot connecten..", math.random(8000, 12000), false, true, {
								disableMovement = true,
								disableCarMovement = true,
								disableMouse = false,
								disableCombat = true,
							}, {}, {}, {}, function()
								TriggerServerEvent("AttackTransport:akceptujto")
								melding = false
								Citizen.Wait(500)
							end, function()
								QBCore.Functions.Notify("Connectie geweigerd..", "error")
							end)
						else
							QBCore.Functions.Notify("Je hebt geen reboot...", "error")
						end
					end)
				end
			end
        else
			Citizen.Wait(1000)
		end
	end
end)
---

function CheckGuards()
	if IsPedDeadOrDying(pilot) == 1 or IsPedDeadOrDying(navigator) == 1 then
		GuardsDead = 1
	end
end

function AlertPolice()
	local a,b,c = table.unpack(GetEntityCoords(transport))
	local AlertCoordA = tonumber(string.format("%.2f", a))
	local AlertCoordB = tonumber(string.format("%.2f", b))
	local AlertCoordC = tonumber(string.format("%.2f", c))
	TriggerServerEvent('AttackTransport:zawiadompsy', AlertCoordA, AlertCoordB, AlertCoordC)
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

RegisterNetEvent('AttackTransport:InfoForLspd')
AddEventHandler('AttackTransport:InfoForLspd', function(x, y, z)
	local coords = {x = x, y = y, z= z}
	if PlayerJob ~= nil and PlayerJob.name == 'police' then
		if not melding then
			melding = true
			local store = "Waardetransport"
				PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
				TriggerEvent('qb-policealerts:client:AddPoliceAlert', {
					timeOut = 10000,
					alertTitle = "Mogelijk gewapende overval",
					coords = {
						x = coords.x,
						y = coords.y,
						z = coords.z,
					},
					details = {
						[1] = {
							icon = '<i class="fas fa-university"></i>',
							detail = store,
						},
					},
					callSign = QBCore.Functions.GetPlayerData().metadata["callsign"],
				})

			local transG = 250
			local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
			SetBlipSprite(blip, 487)
			SetBlipColour(blip, 4)
			SetBlipDisplay(blip, 4)
			SetBlipAlpha(blip, transG)
			SetBlipScale(blip, 1.2)
			SetBlipFlashes(blip, true)
			BeginTextCommandSetBlipName('STRING')
			AddTextComponentString("112: Mogelijk bewapende geldwagen overval")
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

			while true do
				Citizen.Wait(1)
				local PoliceCoords = GetEntityCoords(PlayerPedId(), false)
				local PoliceDist = #(PoliceCoords - vector3(coords.x, coords.y, coords.z))
				if PoliceDist <= 4.5 then
					local dict = "anim@mp_player_intmenu@key_fob@"
				
					RequestAnimDict(dict)
					while not HasAnimDictLoaded(dict) do
						Citizen.Wait(100)
					end
					if SilenceAlarm == 0 then
						QBCore.Functions.Notify("Je kan met G zorgen dat de omgeving opgeruimd word!", "error")
						SilenceAlarm = 1
					end
					if IsControlPressed(0, 47) and GuardsDead == 1 then
						local vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 50, GetHashKey("stockade"), 45)
						DeleteVehicle(vehicle)
						TaskPlayAnim(PlayerPedId(), dict, "fob_click_fp", 8.0, 8.0, -1, 48, 1, false, false, false)
						TriggerEvent('AttackTransport:CleanUp')
						RemoveBlip(TruckBlip)
						Citizen.Wait(500)
						return
					end
				end
			end
		end
	end
end)

function MissionNotification()
	Citizen.Wait(2000)
	TriggerServerEvent("qb-phone:server:sendNewMail", {
		sender = "ANON",
		subject = "Waardetransport overval",
		message = "Goed we houden het kort en simpel, jij bent de persoon die denkt deze klus te kunnen klaren dus doe dat ook.. omdat jullie toch allemaal amateurs zijn geef ik je 1 tip.. Ga niet onbewapend! De locatie is ingesteld",
	})
	Citizen.Wait(3000)
end
---
--
RegisterNetEvent('AttackTransport:Pozwolwykonac')
AddEventHandler('AttackTransport:Pozwolwykonac', function()
MissionNotification()
local DrawCoord = math.random(1,5)
if DrawCoord == 1 then
VehicleCoords = VehicleSpawn1
elseif DrawCoord == 2 then
VehicleCoords = VehicleSpawn2
elseif DrawCoord == 3 then
VehicleCoords = VehicleSpawn3
elseif DrawCoord == 4 then
VehicleCoords = VehicleSpawn4
elseif DrawCoord == 5 then
VehicleCoords = VehicleSpawn5
end

RequestModel(GetHashKey('stockade'))
while not HasModelLoaded(GetHashKey('stockade')) do
Citizen.Wait(0)
end

SetNewWaypoint(VehicleCoords.x, VehicleCoords.y)
QBCore.Functions.Notify("De locatie is ingesteld op de map!", "success")
ClearAreaOfVehicles(VehicleCoords.x, VehicleCoords.y, VehicleCoords.z, 15.0, false, false, false, false, false)
transport = CreateVehicle(GetHashKey('stockade'), VehicleCoords.x, VehicleCoords.y, VehicleCoords.z, 52.0, true, true)
SetEntityAsMissionEntity(transport)
TruckBlip = AddBlipForEntity(transport)
SetBlipSprite(TruckBlip, 57)
SetBlipColour(TruckBlip, 1)
SetBlipFlashes(TruckBlip, true)
BeginTextCommandSetBlipName("STRING")
AddTextComponentString('Waardetransport')
EndTextCommandSetBlipName(TruckBlip)
--
RequestModel("s_m_m_security_01")
while not HasModelLoaded("s_m_m_security_01") do
	Wait(10)
end
pilot = CreatePed(26, "s_m_m_security_01", VehicleCoords.x, VehicleCoords.y, VehicleCoords.z, 268.9422, true, false)
navigator = CreatePed(26, "s_m_m_security_01", VehicleCoords.x, VehicleCoords.y, VehicleCoords.z, 268.9422, true, false)
SetPedIntoVehicle(pilot, transport, -1)
SetPedIntoVehicle(navigator, transport, 0)
SetPedFleeAttributes(pilot, 0, true)
SetPedCombatAttributes(pilot, 46, 1)
SetPedCombatAbility(pilot, 2)
SetPedCombatMovement(pilot, 2)
SetPedCombatRange(pilot, 2)
SetPedKeepTask(pilot, true)
GiveWeaponToPed(pilot, GetHashKey(DriverWep),250,false,true)
--
SetPedFleeAttributes(navigator, 0, true)
SetPedCombatAttributes(navigator, 46, 1)
SetPedCombatAbility(navigator, 100)
SetPedCombatMovement(navigator, 2)
SetPedCombatRange(navigator, 2)
SetPedKeepTask(navigator, true)
TaskEnterVehicle(navigator,transport,-1,0,1.0,1)
GiveWeaponToPed(navigator, GetHashKey(NavWep),250,false,true)
--
TaskVehicleDriveWander(pilot, transport, 80.0, 786603 )
MissionStart = 1
end)

--Crims side of the mission
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
		if MissionStart == 1 then
			local plyCoords = GetEntityCoords(PlayerPedId(), false)
			local transCoords = GetEntityCoords(transport)
			local dist = #(plyCoords - transCoords)
			if dist <= 55.0  then
				DrawMarker(0, transCoords.x, transCoords.y, transCoords.z + 4.5, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 135, 31, 35, 100, 1, 0, 0, 0)
				if warning == 0 then
					warning = 1
					QBCore.Functions.Notify("Zorg dat er geen bewakers meer zijn voordat je de bom plaatst!.", "error")
					TaskVehicleDriveWander(pilot, transport, 80.0, 1074528293)
				end

				if GuardsDead == 0 then
					CheckGuards()
				end
			end

			if dist <= 7 and BlownUp == 0 and PlayerJob.name ~= 'police' then
				if BlowBackdoor == 0 then
					QBCore.Functions.Notify("Met G kan je de bom op de deuren zetten!", "error")
					BlowBackdoor = 1
				end
				if IsControlPressed(0, 47) and GuardsDead == 1 then
					if not IsPedInAnyVehicle(PlayerPedId(), false) then
						CheckVehicleInformation(transCoords)
						Citizen.Wait(500)
					else
						QBCore.Functions.Notify("Je mag niet in een auto zitten!", "error")
					end
				end
			end

			if IsVehicleSeatFree(transport, -1) or IsVehicleSeatFree(transport, 0) then
				TaskLeaveVehicle(pilot, GetVehiclePedIsIn(pilot, false))
				TaskLeaveVehicle(navigator, GetVehiclePedIsIn(navigator, false))
				if not melding then
					print("melding")
					AlertPolice()
					melding = true
				end
			end

		else
			Citizen.Wait(1500)
		end
	end
end) 

function CheckVehicleInformation(transCoords)
	if IsVehicleStopped(transport) then
		if IsVehicleSeatFree(transport, -1) and IsVehicleSeatFree(transport, 0) and IsVehicleSeatFree(transport, 1) and GuardsDead == 1 then
			if not IsEntityInWater(PlayerPedId()) then
				RequestAnimDict('anim@heists@ornate_bank@thermal_charge_heels')
				while not HasAnimDictLoaded('anim@heists@ornate_bank@thermal_charge_heels') do
					Citizen.Wait(50)
				end
				local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
				prop = CreateObject(GetHashKey('prop_c4_final_green'), x, y, z+0.2,  true,  true, true)
				AttachEntityToEntity(prop, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 60309), 0.06, 0.0, 0.06, 90.0, 0.0, 0.0, true, true, false, true, 1, true)
				SetCurrentPedWeapon(PlayerPedId(), GetHashKey("WEAPON_UNARMED"),true)
				FreezeEntityPosition(PlayerPedId(), true)
				TaskPlayAnim(PlayerPedId(), 'anim@heists@ornate_bank@thermal_charge_heels', "thermal_charge", 3.0, -8, -1, 63, 0, 0, 0, 0 )
				Citizen.Wait(5500)
				ClearPedTasks(PlayerPedId())
				DetachEntity(prop)
				AttachEntityToEntity(prop, transport, GetEntityBoneIndexByName(transport, 'door_pside_r'), -0.7, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, true)
				if not IsWearingHandshoes() then
					local pos = GetEntityCoords(PlayerPedId())
					TriggerServerEvent("evidence:server:CreateFingerDrop", pos)
				end
				QBCore.Functions.Notify('De bom gaat af in '..TimeToBlow / 1000 ..' seconden.', "error")
				FreezeEntityPosition(PlayerPedId(), false)
				Citizen.Wait(TimeToBlow)
				local transCoords = GetEntityCoords(transport)
				SetVehicleDoorBroken(transport, 2, false)
				SetVehicleDoorBroken(transport, 3, false)
				AddExplosion(transCoords.x,transCoords.y,transCoords.z, 'EXPLOSION_TANKER', 2.0, true, false, 2.0)
				ApplyForceToEntity(transport, 0, transCoords.x,transCoords.y,transCoords.z, 0.0, 0.0, 0.0, 1, false, true, true, true, true)
				BlownUp = 1
				lootable = 1
				QBCore.Functions.Notify('Je kan het geld gaan pakken uit de laadruimte met E!', "success")
				RemoveBlip(TruckBlip)
			else
				QBCore.Functions.Notify('Ga het water uit!', "error")
			end
		else
			QBCore.Functions.Notify('Het voertuig moet leeg zijn voordat je de bom kan plaatsen!', "error")
		end
	else
		QBCore.Functions.Notify('Je kan geen rijdende truck beroven!.', "error")
	end
end

--Crim Client
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)

		if lootable == 1 then
			local plyCoords = GetEntityCoords(PlayerPedId(), false)
			local transCoords = GetEntityCoords(transport)
            local dist = #(plyCoords - transCoords)

			if dist > 45.0 then
			Citizen.Wait(500)
			end

			if dist <= 4.5 then
				if PickupMoney == 0 then
					PickupMoney = 1
				end
				if IsControlJustPressed(0, 38) then
				lootable = 0
				TakingMoney()
				Citizen.Wait(500)
				end
			end
		else
		Citizen.Wait(1500)
		end
end
end)


RegisterNetEvent('AttackTransport:CleanUp')
AddEventHandler('AttackTransport:CleanUp', function()
	PickupMoney = 0
	BlowBackdoor = 0
	SilenceAlarm = 0
	PoliceAlert = 0
	PoliceBlip = 0
	moneyCalc = 1
	LootTime = 1
	GuardsDead = 0
	lootable = 0
	BlownUp = 0
	MissionStart = 0
	warning = 0
	melding = false
end)

--Crim Client
function TakingMoney()
	RequestAnimDict('anim@heists@ornate_bank@grab_cash_heels')
	while not HasAnimDictLoaded('anim@heists@ornate_bank@grab_cash_heels') do
		Citizen.Wait(50)
	end

	local PedCoords = GetEntityCoords(PlayerPedId())
	bag = CreateObject(GetHashKey('prop_cs_heist_bag_02'),PedCoords.x, PedCoords.y,PedCoords.z, true, true, true)
	AttachEntityToEntity(bag, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), 0.0, 0.0, -0.16, 250.0, -30.0, 0.0, false, false, false, false, 2, true)
	TaskPlayAnim(PlayerPedId(), "anim@heists@ornate_bank@grab_cash_heels", "grab", 8.0, -8.0, -1, 1, 0, false, false, false)
	FreezeEntityPosition(PlayerPedId(), true)
	QBCore.Functions.Notify('Je bent de truck aan het leeg halen! Druk op G om te stoppen!', "success")
	local _time = GetGameTimer()
	while GetGameTimer() - _time < 15000 do
		if IsControlPressed(0, 47) then
			break
		end
		Citizen.Wait(1)
	end
	LootTime = GetGameTimer() - _time
	DeleteEntity(bag)
	ClearPedTasks(PlayerPedId())
	FreezeEntityPosition(PlayerPedId(), false)
	SetPedComponentVariation(PlayerPedId(), 5, 45, 0, 2)
	TriggerServerEvent("AttackTransport:graczZrobilnapad", LootTime)
	TriggerEvent('AttackTransport:CleanUp')
	Citizen.Wait(2500)
end

MaleNoHandshoes = {
    [0] = true,
    [1] = true,
    [2] = true,
    [3] = true,
    [4] = true,
    [5] = true,
    [6] = true,
    [7] = true,
    [8] = true,
    [9] = true,
    [10] = true,
    [11] = true,
    [12] = true,
    [13] = true,
    [14] = true,
    [15] = true,
    [18] = true,
    [26] = true,
    [52] = true,
    [53] = true,
    [54] = true,
    [55] = true,
    [56] = true,
    [57] = true,
    [58] = true,
    [59] = true,
    [60] = true,
    [61] = true,
    [62] = true,
    [112] = true,
    [113] = true,
    [114] = true,
    [118] = true,
    [125] = true,
    [132] = true,
}
FemaleNoHandshoes = {
    [0] = true,
    [1] = true,
    [2] = true,
    [3] = true,
    [4] = true,
    [5] = true,
    [6] = true,
    [7] = true,
    [8] = true,
    [9] = true,
    [10] = true,
    [11] = true,
    [12] = true,
    [13] = true,
    [14] = true,
    [15] = true,
    [19] = true,
    [59] = true,
    [60] = true,
    [61] = true,
    [62] = true,
    [63] = true,
    [64] = true,
    [65] = true,
    [66] = true,
    [67] = true,
    [68] = true,
    [69] = true,
    [70] = true,
    [71] = true,
    [129] = true,
    [130] = true,
    [131] = true,
    [135] = true,
    [142] = true,
    [149] = true,
    [153] = true,
    [157] = true,
    [161] = true,
    [165] = true,
}