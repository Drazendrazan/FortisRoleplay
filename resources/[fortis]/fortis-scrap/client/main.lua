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

letsleep = true
bezig = true
proberen = true
lassen = true
inrange = false
kaas = false
klaar = false
marker = true
kiesbaar = false
getriggerd = false
steaminsert = true
eerste = true

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		for k, v in pairs(Config.Locaties) do
			local pos = GetEntityCoords(GetPlayerPed(-1))
			if GetDistanceBetweenCoords(pos, v.coords.x, v.coords.y, v.coords.z) <75 then
				materiaal = k
				kaas = true
			else
				Citizen.Wait(500)
			end

			verzamelen = materiaal
			
			if materiaal == "Staal" then
				bericht = "Staal aan het lassen..."
				animdict = "amb@world_human_welding@male@base"
				anim = "base"
			elseif materiaal == "Plastic" then
				bericht = "Plastic aan het oppakken..."
				animdict = "veh@break_in@0h@p_m_one@"
				anim = "low_force_entry_ds"
				flags = 16
			elseif materiaal == "Koper" then
				bericht = "Koper aan het lassen..."
				animdict = "veh@break_in@0h@p_m_one@"
				anim = "low_force_entry_ds"
				flags = 16
			elseif materiaal == "Ijzer" then
				bericht = "Ijzer aan het lassen..."
				animdict = "veh@break_in@0h@p_m_one@"
				anim = "low_force_entry_ds"
				flags = 16
			elseif materiaal == "Rubber" then
				bericht = "Rubber aan het afsnijden..."
				animdict = "veh@break_in@0h@p_m_one@"
				anim = "low_force_entry_ds"
				flags = 16
			elseif materiaal == "Aluminum" then
				bericht = "Aluminium aan het verzamelen..."
				animdict = "veh@break_in@0h@p_m_one@"
				anim = "low_force_entry_ds"
				flags = 16
			elseif materiaal == "Glas" then
				bericht = "Glas aan het verzamelen..."
				animdict = "mp_ped_interaction"
				anim = "handshake_guy_a"
				flags = 16
			elseif materiaal == "Metaalschroot" then
				bericht = "Metaalschroot aan het verzamelen..."
				animdict = "veh@break_in@0h@p_m_one@"
				anim = "low_force_entry_ds"
				flags = 16
			end
		end
	end
end)


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		local pos = GetEntityCoords(PlayerPedId())
        while PlayerData == nil do Wait(500) end
        while PlayerData.job == nil do Wait(500) end

		if kaas then
			if GetDistanceBetweenCoords(pos, Config.Locaties[materiaal].coords.x, Config.Locaties[materiaal].coords.y, Config.Locaties[materiaal].coords.z, true) < 75 then
				letsleep = false	
				if not inrange then
					if GetDistanceBetweenCoords(pos, Config.Locaties[materiaal].coords.x, Config.Locaties[materiaal].coords.y, Config.Locaties[materiaal].coords.z, true) < 2 then
						if IsControlJustPressed(0, 38) then
							if not getriggerd then
								QBCore.Functions.TriggerCallback("fortis-scrap:server:checkScrap", function(callback)
									resultaat = callback
									if #Config.Locaties[materiaal]["lasCoords"] > 0 then
										if resultaat ~= 1 then
											bezig = true
											marker = false
											inrange = true
											kiesbaar = true
											getriggerd = true
											steaminsert = false
											TriggerServerEvent("fortis-scrap:server:klaar", materiaal, eerste)
										else
											QBCore.Functions.Notify("Je bent klaar voor vandaag!", "error")
											bezig = false
											marker = true
										end
									else
										QBCore.Functions.Notify("Je bent klaar voor vandaag!", "error")
										bezig = false
										marker = true
									end
								end, materiaal)
							end
						end
					end			
				end

				if resultaat ~= 1 and resultaat ~= nil then 
					if bezig then
						if GetDistanceBetweenCoords(pos, Config.Locaties[materiaal].coords.x, Config.Locaties[materiaal].coords.y, Config.Locaties[materiaal].coords.z, true) < 75 then
							if #Config.Locaties[materiaal]["lasCoords"] > 0 then
								if kiesbaar then
									if not klaar then
										locatieKeuze()
										klaar = true
										kiesbaar = false
									end							
								end
							else
								getriggerd = false
							end
							if locatie ~= nil then
								if GetDistanceBetweenCoords(pos, locatie.x, locatie.y, locatie.z, true) < 15 then
									DrawMarker(2, locatie.x, locatie.y, locatie.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.4, 0.2, 28, 202, 155, 155, false, false, false, true, false, false, false)
									if not IsPedInAnyVehicle(PlayerPedId()) then
										if GetDistanceBetweenCoords(pos, locatie.x, locatie.y, locatie.z, true) < 1.5 then
											if lassen then
												QBCore.Functions.DrawText3D(locatie.x, locatie.y, locatie.z + 0.5, "~g~E~w~ - Verzamelen")
											else
												QBCore.Functions.DrawText3D(locatie.x, locatie.y, locatie.z + 0.5, "~g~E~w~ - Oppakken")
											end
											if IsControlJustPressed(0, 38) then
												if PlayerData.job.name ~= "police" and PlayerData.job.name ~= "ambulance" then
													if proberen then -- 8000, 15000
														QBCore.Functions.Progressbar("Staal aan het lassen", ""..bericht.. "", math.random(6000), false, false, {
															disableMovement = true,
															disableCarMovement = true,
															disableMouse = false,
															disableCombat = true,
														}, {
															animDict = ""..animdict.."",
															anim = ""..anim.."",
															flags = flags,
														}, {}, {}, function() -- Done
															ClearPedTasksImmediately(PlayerPedId())
															proberen = false
															lassen = false
														end)
													else
														QBCore.Functions.Progressbar("Staal aan het af lassen", ""..verzamelen.. " aan het verzamelen...", math.random(5000), false, false, {
															disableMovement = true,
															disableCarMovement = true,
															disableMouse = false,
															disableCombat = true,
														}, {
															animDict = "anim@heists@narcotics@trash",
        	    	        	    		    	        anim = "pickup",
        	    	        	    		    	        flags = 16,
														}, {}, {}, function() -- Done
															TriggerServerEvent("fortis-scrap:server:itemGeven", materiaal, key)
															lassen = true
															proberen = true
															klaar = false
															kiesbaar = true
															locatie = nil
															if #Config.Locaties[materiaal]["lasCoords"] == 0 then
																locatieKeuze()
															end
														end)
													end
												else
                            	                    QBCore.Functions.Notify("Je kan dit niet verzamelen als hulpdienst!")
                            	                end
											end
										end
									end
								end
							end
						end
					end
				else
					bezig = false
				end
			else
				letsleep = true
				inrange = false
			end
			if letsleep then
				Citizen.Wait(1000)
			end
			if marker then
				if GetDistanceBetweenCoords(pos, Config.Locaties[materiaal].coords.x, Config.Locaties[materiaal].coords.y, Config.Locaties[materiaal].coords.z, true) < 20 then
					DrawMarker(2, Config.Locaties[materiaal].coords.x, Config.Locaties[materiaal].coords.y, Config.Locaties[materiaal].coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.4, 0.2, 28, 202, 155, 155, false, false, false, true, false, false, false)
					if GetDistanceBetweenCoords(pos, Config.Locaties[materiaal].coords.x, Config.Locaties[materiaal].coords.y, Config.Locaties[materiaal].coords.z, true) < 2 then
						QBCore.Functions.DrawText3D(Config.Locaties[materiaal].coords.x, Config.Locaties[materiaal].coords.y, Config.Locaties[materiaal].coords.z + 0.5, "~g~E~w~ - Verzamelen")
					end
				end
			end
			if not steaminsert then
				TriggerServerEvent("fortis-scrap:server:insterSteam", materiaal)
				steaminsert = true
				Citizen.Wait(500)
				eerste = false
			end
		end
	end
end)



function locatieKeuze()
	if resultaat ~= 1 then
		if #Config.Locaties[materiaal]["lasCoords"] > 0 then
			key = math.random(1, #Config.Locaties[materiaal]["lasCoords"])
			locatie = Config.Locaties[materiaal]["lasCoords"][key]
			table.remove(Config.Locaties[materiaal]["lasCoords"], key)
			dump(Config.Locaties[materiaal]["lasCoords"])
		elseif resultaat == 0 and #Config.Locaties[materiaal]["lasCoords"] == 0 then
			QBCore.Functions.Notify("Je bent klaar voor vandaag!", "error")
			klaar = false
			marker = true
			inrange = false
			kiesbaar = true
			locatie = nil
			bezig = false
			getriggerd = false
		elseif resultaat == 1 and #Config.Locaties[materiaal]["lasCoords"] > 0 then
			key = math.random(1, #Config.Locaties[materiaal]["lasCoords"])
			locatie = Config.Locaties[materiaal]["lasCoords"][key]
			table.remove(Config.Locaties[materiaal]["lasCoords"], key)
			dump(Config.Locaties[materiaal]["lasCoords"])
		end
	else
		QBCore.Functions.Notify("Je bent klaar voor vandaag!", "error")
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