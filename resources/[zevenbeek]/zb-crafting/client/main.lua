Keys = {
	['ESC'] = 322, ['F1'] = 288, ['F2'] = 289, ['F3'] = 170, ['F5'] = 166, ['F6'] = 167, ['F7'] = 168, ['F8'] = 169, ['F9'] = 56, ['F10'] = 57,
	['~'] = 243, ['1'] = 157, ['2'] = 158, ['3'] = 160, ['4'] = 164, ['5'] = 165, ['6'] = 159, ['7'] = 161, ['8'] = 162, ['9'] = 163, ['-'] = 84, ['='] = 83, ['BACKSPACE'] = 177,
	['TAB'] = 37, ['Q'] = 44, ['W'] = 32, ['E'] = 38, ['R'] = 45, ['T'] = 245, ['Y'] = 246, ['U'] = 303, ['P'] = 199, ['['] = 39, [']'] = 40, ['ENTER'] = 18,
	['CAPS'] = 137, ['A'] = 34, ['S'] = 8, ['D'] = 9, ['F'] = 23, ['G'] = 47, ['H'] = 74, ['K'] = 311, ['L'] = 182,
	['LEFTSHIFT'] = 21, ['Z'] = 20, ['X'] = 73, ['C'] = 26, ['V'] = 0, ['B'] = 29, ['N'] = 249, ['M'] = 244, [','] = 82, ['.'] = 81,
	['LEFTCTRL'] = 36, ['LEFTALT'] = 19, ['SPACE'] = 22, ['RIGHTCTRL'] = 70,
	['HOME'] = 213, ['PAGEUP'] = 10, ['PAGEDOWN'] = 11, ['DELETE'] = 178,
	['LEFT'] = 174, ['RIGHT'] = 175, ['TOP'] = 27, ['DOWN'] = 173,
}

QBCore = nil
local itemInfos = {}

Citizen.CreateThread(function()
	while QBCore == nil do
		TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
		Citizen.Wait(0)
	end
	ItemsToItemInfo()
end)

function DrawText3D(x, y, z, text)
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

local maxDistance = 1.25

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local pos, awayFromObject = GetEntityCoords(GetPlayerPed(-1)), true
		local craftObject = GetClosestObjectOfType(pos, 2.0, -573669520, false, false, false)
		if craftObject ~= 0 then
			local objectPos = GetEntityCoords(craftObject)
			if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, objectPos.x, objectPos.y, objectPos.z, true) < 1.5 then
				awayFromObject = false
				DrawText3D(objectPos.x, objectPos.y, objectPos.z + 1.0, "~g~E~w~ - Werkbank")
				if IsControlJustReleased(0, Keys["E"]) then
					local crafting = {}
					crafting.label = "Werkbank"
					crafting.items = GetThresholdItems()
					TriggerServerEvent("inventory:server:OpenInventory", "crafting", math.random(1, 99), crafting)
				end
			end
		end

		if awayFromObject then
			Citizen.Wait(1000)
		end
	end
end)

function GetThresholdItems()
	local items = {}
	for k, item in pairs(Config.CraftingItems) do
		if QBCore.Functions.GetPlayerData().metadata["craftingrep"] >= Config.CraftingItems[k].threshold then
			items[k] = Config.CraftingItems[k]
		end
	end
	return items
end

function GetAttachmentThresholdItems()
	local items = {}
	for k, item in pairs(Config.AttachmentCrafting["items"]) do
		local itemInfo = QBCore.Shared.Items[item.name:lower()]
		items[item.slot] = {
			name = itemInfo["name"],
			amount = tonumber(item.amount),
			info = itemInfos[item.slot],
			label = itemInfo["label"],
			description = itemInfo["description"] ~= nil and itemInfo["description"] or "",
			weight = itemInfo["weight"], 
			type = itemInfo["type"], 
			unique = itemInfo["unique"], 
			useable = itemInfo["useable"], 
			image = itemInfo["image"],
			slot = item.slot,
			costs = item.costs,
			threshold = item.threshold,
			points = item.points,
		}
	end
	Config.AttachmentCrafting["items"] = items
end

function ItemsToItemInfo()
	itemInfos = {
		-- HQ scrap items
		[1] = {costs = QBCore.Shared.Items["aluminum"]["label"] .. ": 100x."}, -- HQ
		[2] = {costs = QBCore.Shared.Items["copper"]["label"] .. ": 100x."}, -- HQ
		[3] = {costs = QBCore.Shared.Items["glass"]["label"] .. ": 100x."}, -- HQ
		[4] = {costs = QBCore.Shared.Items["iron"]["label"] .. ": 100x."}, -- HQ
		[5] = {costs = QBCore.Shared.Items["metalscrap"]["label"] .. ": 100x."}, -- HQ
		[6] = {costs = QBCore.Shared.Items["plastic"]["label"] .. ": 100x."}, -- HQ
		[7] = {costs = QBCore.Shared.Items["rubber"]["label"] .. ": 100x."}, -- HQ
		[8] = {costs = QBCore.Shared.Items["steel"]["label"] .. ": 100x."}, -- HQ
		-- Normale items
		[9] = {costs = QBCore.Shared.Items["metalscrap"]["label"] .. ": 22x, " ..QBCore.Shared.Items["plastic"]["label"] .. ": 32x."}, -- Lockpick
		[10] = {costs = QBCore.Shared.Items["metalscrap"]["label"] .. ": 30x, " ..QBCore.Shared.Items["plastic"]["label"] .. ": 42x."}, -- screwdriverset
		[11] = {costs = QBCore.Shared.Items["metalscrap"]["label"] .. ": 30x, " ..QBCore.Shared.Items["plastic"]["label"] .. ": 45x, "..QBCore.Shared.Items["aluminum"]["label"] .. ": 28x."}, -- electronickit
		[12] = {costs = QBCore.Shared.Items["iron"]["label"] .. ": 30x, " ..QBCore.Shared.Items["aluminum"]["label"] .. ": 30x, "..QBCore.Shared.Items["electronickit"]["label"] .. ": 1x."}, -- reboot
		[13] = {costs = QBCore.Shared.Items["electronickit"]["label"] .. ": 2x, " ..QBCore.Shared.Items["plastic"]["label"] .. ": 52x, "..QBCore.Shared.Items["steel"]["label"] .. ": 40x."}, -- radioscanner
		[14] = {costs = QBCore.Shared.Items["metalscrap"]["label"] .. ": 10x, " ..QBCore.Shared.Items["plastic"]["label"] .. ": 50x, "..QBCore.Shared.Items["aluminum"]["label"] .. ": 30x, "..QBCore.Shared.Items["iron"]["label"] .. ": 17x, "..QBCore.Shared.Items["electronickit"]["label"] .. ": 1x."}, -- gatecrack
		[15] = {costs = QBCore.Shared.Items["metalscrap"]["label"] .. ": 36x, " ..QBCore.Shared.Items["steel"]["label"] .. ": 24x, "..QBCore.Shared.Items["aluminum"]["label"] .. ": 28x."}, -- handcuffs
		[16] = {costs = QBCore.Shared.Items["aluminum"]["label"] .. ": 28x, " ..QBCore.Shared.Items["plastic"]["label"] .. ": 55x."}, -- hoofdzak
		[17] = {costs = QBCore.Shared.Items["iron"]["label"] .. ": 180x, " ..QBCore.Shared.Items["glass"]["label"] .. ": 90x."}, -- ironoxide
		[18] = {costs = QBCore.Shared.Items["aluminum"]["label"] .. ": 180x, " ..QBCore.Shared.Items["glass"]["label"] .. ": 90x."}, -- aluminumoxide
		[19] = {costs = QBCore.Shared.Items["aluminumoxide"]["label"] .. ": 1x, " ..QBCore.Shared.Items["ironoxide"]["label"] .. ": 1x, "..QBCore.Shared.Items["plastic"]["label"] .. ":75x."}, -- c4
		[20] = {costs = QBCore.Shared.Items["iron"]["label"] .. ": 33x, " ..QBCore.Shared.Items["steel"]["label"] .. ": 44x, "..QBCore.Shared.Items["plastic"]["label"] .. ": 55x, "..QBCore.Shared.Items["aluminum"]["label"] .. ": 22x."}, -- armor
		[21] = {costs = QBCore.Shared.Items["iron"]["label"] .. ": 50x, " ..QBCore.Shared.Items["steel"]["label"] .. ": 50x, "..QBCore.Shared.Items["screwdriverset"]["label"] .. ": 3x, "..QBCore.Shared.Items["advancedlockpick"]["label"] .. ": 2x."}, -- drill
		[22] = {costs = QBCore.Shared.Items["aluminumoxide"]["label"] .. ": 1x, " ..QBCore.Shared.Items["ironoxide"]["label"] .. ": 1x, "..QBCore.Shared.Items["aluminum"]["label"] .. ":75x."}, -- thermite bomb
		-- Wapen items
		[23] = {costs = QBCore.Shared.Items["hq_rubber"]["label"] .. ": 1x, " ..QBCore.Shared.Items["hq_plastic"]["label"] .. ": 10x."}, -- craft_switchblade_handvat
		[24] = {costs = QBCore.Shared.Items["hq_steel"]["label"] .. ": 10x, " ..QBCore.Shared.Items["hq_ironplate"]["label"] .. ": 10x."}, -- craft_switchblade_mes
		[25] = {costs = QBCore.Shared.Items["hq_rubber"]["label"] .. ": 1x, " ..QBCore.Shared.Items["hq_plastic"]["label"] .. ": 15x."}, -- craft_machete_handvat
		[26] = {costs = QBCore.Shared.Items["hq_steel"]["label"] .. ": 15x, " ..QBCore.Shared.Items["hq_ironplate"]["label"] .. ": 15x."}, -- craft_machete_mes
		[27] = {costs = QBCore.Shared.Items["hq_plastic"]["label"] .. ": 10x, " ..QBCore.Shared.Items["hq_ironplate"]["label"] .. ": 10x, "..QBCore.Shared.Items["hq_copper"]["label"] .. ": 10x."}, -- craft_snspistol_handvat
		[28] = {costs = QBCore.Shared.Items["hq_metalscrap"]["label"] .. ": 20x, " ..QBCore.Shared.Items["hq_steel"]["label"] .. ": 20x,"}, -- craft_snspistol_loop
		[29] = {costs = QBCore.Shared.Items["hq_plastic"]["label"] .. ": 12x, " ..QBCore.Shared.Items["hq_ironplate"]["label"] .. ": 12x, "..QBCore.Shared.Items["hq_copper"]["label"] .. ": 12x."}, -- craft_pistol_handvat
		[30] = {costs = QBCore.Shared.Items["hq_metalscrap"]["label"] .. ": 25x, " ..QBCore.Shared.Items["hq_steel"]["label"] .. ": 25x,"}, -- craft_pistol_loop
		[31] = {costs = QBCore.Shared.Items["hq_plastic"]["label"] .. ": 13x, " ..QBCore.Shared.Items["hq_ironplate"]["label"] .. ": 13x, "..QBCore.Shared.Items["hq_copper"]["label"] .. ": 13x."}, -- craft_ceramic_handvat
		[32] = {costs = QBCore.Shared.Items["hq_metalscrap"]["label"] .. ": 28x, " ..QBCore.Shared.Items["hq_steel"]["label"] .. ": 28x,"}, -- craft_ceramic_loop
		[33] = {costs = QBCore.Shared.Items["hq_plastic"]["label"] .. ": 15x, " ..QBCore.Shared.Items["hq_ironplate"]["label"] .. ": 15x, "..QBCore.Shared.Items["hq_copper"]["label"] .. ": 15x."}, -- craft_machinepistol_handvat
		[34] = {costs = QBCore.Shared.Items["hq_copper"]["label"] .. ": 10x, " ..QBCore.Shared.Items["hq_aluminum"]["label"] .. ": 20x,"}, -- craft_machinepistol_magazijn
		[35] = {costs = QBCore.Shared.Items["hq_metalscrap"]["label"] .. ": 25x, " ..QBCore.Shared.Items["hq_steel"]["label"] .. ": 25x,"}, -- craft_machinepistol_loop
		[36] = {costs = QBCore.Shared.Items["hq_plastic"]["label"] .. ": 20x, " ..QBCore.Shared.Items["hq_ironplate"]["label"] .. ": 20x, "..QBCore.Shared.Items["hq_copper"]["label"] .. ": 15x."}, -- craft_minismg_handvat
		[37] = {costs = QBCore.Shared.Items["hq_copper"]["label"] .. ": 15x, " ..QBCore.Shared.Items["hq_aluminum"]["label"] .. ": 25x,"}, -- craft_minismg_magazijn
		[38] = {costs = QBCore.Shared.Items["hq_metalscrap"]["label"] .. ": 25x, " ..QBCore.Shared.Items["hq_steel"]["label"] .. ": 25x,"}, -- craft_minismg_loop
		[39] = {costs = QBCore.Shared.Items["hq_rubber"]["label"] .. ": 5x, " ..QBCore.Shared.Items["hq_plastic"]["label"] .. ": 40x, "..QBCore.Shared.Items["hq_copper"]["label"] .. ": 40x."}, -- craft_sawnoffshotgun_handvat
		[40] = {costs = QBCore.Shared.Items["hq_metalscrap"]["label"] .. ": 40x, " ..QBCore.Shared.Items["hq_steel"]["label"] .. ": 40x,"}, -- craft_sawnoffshotgun_loop
		[41] = {costs = QBCore.Shared.Items["hq_rubber"]["label"] .. ": 3x, " ..QBCore.Shared.Items["hq_plastic"]["label"] .. ": 30x, "..QBCore.Shared.Items["hq_ironplate"]["label"] .. ": 30x."}, -- craft_compactrifle_handvat
		[42] = {costs = QBCore.Shared.Items["hq_copper"]["label"] .. ": 20x, " ..QBCore.Shared.Items["hq_aluminum"]["label"] .. ": 20x,"}, -- craft_compactrifle_magazijn
		[43] = {costs = QBCore.Shared.Items["hq_metalscrap"]["label"] .. ": 25x, " ..QBCore.Shared.Items["hq_steel"]["label"] .. ": 25x,"}, -- craft_compactrifle_loop
		[44] = {costs = QBCore.Shared.Items["hq_plastic"]["label"] .. ": 10x, "..QBCore.Shared.Items["hq_ironplate"]["label"] .. ": 10x."}, -- craft_pumpshotgun_kolf
		[45] = {costs = QBCore.Shared.Items["hq_rubber"]["label"] .. ": 5x, " ..QBCore.Shared.Items["hq_plastic"]["label"] .. ": 40x, "..QBCore.Shared.Items["hq_ironplate"]["label"] .. ": 40x."}, -- craft_pumpshotgun_handvat
		[46] = {costs = QBCore.Shared.Items["hq_metalscrap"]["label"] .. ": 40x, " ..QBCore.Shared.Items["hq_steel"]["label"] .. ": 40x,"}, -- craft_pumpshotgun_loop
		[47] = {costs = QBCore.Shared.Items["hq_rubber"]["label"] .. ": 5x, " ..QBCore.Shared.Items["hq_plastic"]["label"] .. ": 35x, "..QBCore.Shared.Items["hq_ironplate"]["label"] .. ": 35x."}, -- craft_assaultrifle_handvat
		[48] = {costs = QBCore.Shared.Items["hq_copper"]["label"] .. ": 25x, " ..QBCore.Shared.Items["hq_aluminum"]["label"] .. ": 25x,"}, -- craft_assaultrifle_magazijn
		[49] = {costs = QBCore.Shared.Items["hq_metalscrap"]["label"] .. ": 30x, " ..QBCore.Shared.Items["hq_steel"]["label"] .. ": 30x,"}, -- craft_assaultrifle_loop
		[50] = {costs = QBCore.Shared.Items["hq_plastic"]["label"] .. ": 5x, "..QBCore.Shared.Items["hq_ironplate"]["label"] .. ": 5x."}, -- craft_bullpuprifle_kolf
		[51] = {costs = QBCore.Shared.Items["hq_rubber"]["label"] .. ": 7x, " ..QBCore.Shared.Items["hq_plastic"]["label"] .. ": 40x, "..QBCore.Shared.Items["hq_ironplate"]["label"] .. ": 40x."}, -- craft_bullpuprifle_handvat
		[52] = {costs = QBCore.Shared.Items["hq_copper"]["label"] .. ": 30x, " ..QBCore.Shared.Items["hq_aluminum"]["label"] .. ": 30x,"}, -- craft_bullpuprifle_magazijn
		[53] = {costs = QBCore.Shared.Items["hq_metalscrap"]["label"] .. ": 35x, " ..QBCore.Shared.Items["hq_steel"]["label"] .. ": 35x,"}, -- craft_bullpuprifle_loop
		[54] = {costs = QBCore.Shared.Items["hq_plastic"]["label"] .. ": 50x, " ..QBCore.Shared.Items["hq_rubber"]["label"] .. ": 9x,"}, -- craft_gusenberg_handvat
		[55] = {costs = QBCore.Shared.Items["hq_aluminum"]["label"] .. ": 35x, " ..QBCore.Shared.Items["hq_steel"]["label"] .. ": 40x, "..QBCore.Shared.Items["hq_ironplate"]["label"] .. ": 25x."}, -- craft_gusenberg_magazijn
		[56] = {costs = QBCore.Shared.Items["hq_metalscrap"]["label"] .. ": 40x, " ..QBCore.Shared.Items["hq_ironplate"]["label"] .. ": 25x,"}, -- craft_gusenberg_loop
		[57] = {costs = QBCore.Shared.Items["hq_plastic"]["label"] .. ": 5x, "..QBCore.Shared.Items["hq_ironplate"]["label"] .. ": 5x."}, -- craft_specialcarbine_kolf
		[58] = {costs = QBCore.Shared.Items["hq_rubber"]["label"] .. ": 9x, " ..QBCore.Shared.Items["hq_plastic"]["label"] .. ": 45x, "..QBCore.Shared.Items["hq_ironplate"]["label"] .. ": 45x."}, -- craft_specialcarbine_handvat
		[59] = {costs = QBCore.Shared.Items["hq_copper"]["label"] .. ": 35x, " ..QBCore.Shared.Items["hq_aluminum"]["label"] .. ": 35x,"}, -- craft_specialcarbine_magazijn
		[60] = {costs = QBCore.Shared.Items["hq_metalscrap"]["label"] .. ": 40x, " ..QBCore.Shared.Items["hq_steel"]["label"] .. ": 40x,"}, -- craft_specialcarbine_loop
		[61] = {costs = QBCore.Shared.Items["hq_plastic"]["label"] .. ": 10x, "..QBCore.Shared.Items["hq_ironplate"]["label"] .. ": 10x."}, -- craft_sniperrifle_kolf
		[62] = {costs = QBCore.Shared.Items["hq_rubber"]["label"] .. ": 9x, " ..QBCore.Shared.Items["hq_plastic"]["label"] .. ": 45x, "..QBCore.Shared.Items["hq_ironplate"]["label"] .. ": 45x."}, -- craft_sniperrifle_handvat
		[63] = {costs = QBCore.Shared.Items["hq_copper"]["label"] .. ": 35x, " ..QBCore.Shared.Items["hq_aluminum"]["label"] .. ": 35x,"}, -- craft_sniperrifle_magazijn
		[64] = {costs = QBCore.Shared.Items["hq_metalscrap"]["label"] .. ": 50x, " ..QBCore.Shared.Items["hq_steel"]["label"] .. ": 50x, "..QBCore.Shared.Items["hq_glassplate"]["label"] .. ": 50x."}, -- craft_sniperrifle_loop
		[65] = {costs = QBCore.Shared.Items["metalscrap"]["label"] .. ": 180x, " ..QBCore.Shared.Items["steel"]["label"] .. ": 290x, "..QBCore.Shared.Items["hq_glassplate"]["label"] .. ": 10x."}, -- nightvision
	}

	local items = {}
	for k, item in pairs(Config.CraftingItems) do
		local itemInfo = QBCore.Shared.Items[item.name:lower()]
		items[item.slot] = {
			name = itemInfo["name"],
			amount = tonumber(item.amount),
			info = itemInfos[item.slot],
			label = itemInfo["label"],
			description = itemInfo["description"] ~= nil and itemInfo["description"] or "",
			weight = itemInfo["weight"], 
			type = itemInfo["type"], 
			unique = itemInfo["unique"], 
			useable = itemInfo["useable"], 
			image = itemInfo["image"],
			slot = item.slot,
			costs = item.costs,
			threshold = item.threshold,
			points = item.points,
		}
	end
	Config.CraftingItems = items
end