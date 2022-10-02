local handsUpStatus = false

Citizen.CreateThread(function()
    while true do
        if IsControlJustPressed(0, 303) then
            if handsUpStatus == true then
                local ped = GetPlayerPed(-1)
                ClearPedTasks(ped)
                handsUpStatus = false
            else
                loadAnimDict("missminuteman_1ig_2")
                TaskPlayAnim(GetPlayerPed(-1), "missminuteman_1ig_2", "handsup_enter", 8.0, 2.0, -1, 50, 2.0, 0, 0, 0 )
                handsUpStatus = true
            end
        end
        Citizen.Wait(0)
    end
end)

function loadAnimDict( dict )
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(0)
    end
end