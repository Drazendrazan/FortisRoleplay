local deadAnimDict = "dead"
local deadAnim = "dead_d"
local deadCarAnimDict = "veh@low@front_ps@idle_duck"
local deadCarAnim = "sit"

deathTime = 0
heeftGemeld = false

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local player = PlayerId()
		if NetworkIsPlayerActive(player) then
			local playerPed = PlayerPedId()
			if IsEntityDead(playerPed) and not isDead then
				local killer, killerWeapon = NetworkGetEntityKillerOfPlayer(player)
                local killerId = NetworkGetPlayerIndexFromPed(killer)
                local killerName = killerId ~= -1 and GetPlayerName(killerId) .. " " .. "("..GetPlayerServerId(killerId)..")" or "Zichzelf of NPC"
                local weaponLabel = QBCore.Shared.Weapons[killerWeapon] ~= nil and QBCore.Shared.Weapons[killerWeapon]["label"] or "Unknown"
                local weaponName = QBCore.Shared.Weapons[killerWeapon] ~= nil and QBCore.Shared.Weapons[killerWeapon]["name"] or "Unknown_Weapon"
                TriggerServerEvent("qb-log:server:CreateLog", "death", GetPlayerName(player) .. " ("..GetPlayerServerId(player)..") is dood", "red", "**".. killerName .. "** heeft ".. GetPlayerName(player) .." vermoord met **".. weaponLabel .. "** (" .. weaponName .. ")")

                SetPedCanBeTargetted(GetPlayerPed(-1), false)
                SetPedCanBeTargettedByPlayer(GetPlayerPed(-1), -1, false)
                SetEntityInvincible(GetPlayerPed(-1), true)

                deathTime = Config.DeathTime

                OnDeath()
                
                DeathTimer()
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if isDead then
            DisableAllControlActions(0)
            EnableControlAction(0, 1, true)
			EnableControlAction(0, 2, true)
			EnableControlAction(0, Keys['T'], true)
            EnableControlAction(0, Keys['E'], true)
            EnableControlAction(0, Keys['V'], true)
            EnableControlAction(0, Keys['ESC'], true)
            EnableControlAction(0, Keys['F1'], true)
            EnableControlAction(0, Keys['HOME'], true)
            EnableControlAction(0, Keys['G'], true)
            EnableControlAction(0, Keys['PAGEUP'], true)
			EnableControlAction(0, 249, true)
            if not isInHospitalBed then 
                if deathTime > 0 then
                    if not heeftGemeld and deathTime <= 440 then
                        -- Persoon heeft nog niet gemeld
                        DrawTxt(0.89, 1.44, 1.0, 1.0,0.6, "RESPAWN OVER: ~g~" .. math.ceil(deathTime) .. "~w~ SECONDEN - Druk op ~g~E~w~ om een melding te maken", 255, 255, 255, 255)
                        if IsControlPressed(0, 38) then
                            QBCore.Functions.TriggerCallback("hospital:server:checkTelefoon", function(cb)
                                if cb then
                                    heeftGemeld = true
                                    TriggerEvent("hospital:maakMeldingDood")
                                else
                                    QBCore.Functions.Notify("Je hebt geen telefoon!", "error")
                                end
                            end)
                        end
                    else
                        DrawTxt(0.89, 1.44, 1.0,1.0,0.6, "RESPAWN OVER: ~g~" .. math.ceil(deathTime) .. "~w~ SECONDEN", 255, 255, 255, 255)
                    end
                else
                    DrawTxt(0.89, 1.44, 1.0,1.0,0.6, "~w~ HOUD ~g~E ~w~INGEDRUKT OM TE RESPAWNEN (€"..Config.BillCost..")", 255, 255, 255, 255)
                end
            end

            if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
                loadAnimDict("veh@low@front_ps@idle_duck")
                if not IsEntityPlayingAnim(PlayerPedId(), "veh@low@front_ps@idle_duck", "sit", 3) then
                    TaskPlayAnim(PlayerPedId(), "veh@low@front_ps@idle_duck", "sit", 1.0, 1.0, -1, 1, 0, 0, 0, 0)
                end
            else
                if isInHospitalBed then 
                    if not IsEntityPlayingAnim(PlayerPedId(), inBedDict, inBedAnim, 3) then
                        loadAnimDict(inBedDict)
                        TaskPlayAnim(PlayerPedId(), inBedDict, inBedAnim, 1.0, 1.0, -1, 1, 0, 0, 0, 0)
                    end
                else
                    if not IsEntityPlayingAnim(PlayerPedId(), deadAnimDict, deadAnim, 3) then
                        loadAnimDict(deadAnimDict)
                        TaskPlayAnim(PlayerPedId(), deadAnimDict, deadAnim, 1.0, 1.0, -1, 1, 0, 0, 0, 0)
                    end
                end
            end

            SetCurrentPedWeapon(GetPlayerPed(-1), GetHashKey("WEAPON_UNARMED"), true)
		else
			Citizen.Wait(1000)
            heeftGemeld = false
		end
	end
end)

function OnDeath()
    if not isDead then
        isDead = true
        TriggerServerEvent("hospital:server:SetDeathStatus", true)
        TriggerServerEvent("InteractSound_SV:PlayOnSource", "demo", 0.1)
        local player = GetPlayerPed(-1)

        while GetEntitySpeed(player) > 0.5 or IsPedRagdoll(player) do
            Citizen.Wait(10)
        end

        if isDead then
            local pos = GetEntityCoords(player)
            local heading = GetEntityHeading(player)

            NetworkResurrectLocalPlayer(pos.x, pos.y, pos.z, heading, true, false)
            SetEntityInvincible(player, true)
            SetEntityHealth(player, GetEntityMaxHealth(GetPlayerPed(-1)))
            if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
                loadAnimDict("veh@low@front_ps@idle_duck")
                TaskPlayAnim(player, "veh@low@front_ps@idle_duck", "sit", 1.0, 1.0, -1, 1, 0, 0, 0, 0)
            else
                loadAnimDict(deadAnimDict)
                TaskPlayAnim(player, deadAnimDict, deadAnim, 1.0, 1.0, -1, 1, 0, 0, 0, 0)
            end
            TriggerEvent("hospital:client:AiCall")
        end
    end
end

function DeathTimer()
    local hold = 0
    while isDead do
        Citizen.Wait(1000)
        deathTime = deathTime - 1

        if deathTime <= 0 then
            if IsControlPressed(0, Keys["E"]) and hold > 1 and not isInHospitalBed then
                TriggerServerEvent("hospital:server:RespawnAtHospital")
                SetPedCanBeTargetted(GetPlayerPed(-1), true)
                SetPedCanBeTargettedByPlayer(GetPlayerPed(-1), -1, true)
                SetEntityInvincible(GetPlayerPed(-1), false)
                heeftGemeld = false
            end
            if IsControlPressed(0, Keys["E"]) then
                hold = hold + 1
            end
        end
    end
end

function DrawTxt(x, y, width, height, scale, text, r, g, b, a, outline)
    SetTextFont(4)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(2, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end

