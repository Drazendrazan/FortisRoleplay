QBCore = nil
Citizen.CreateThread(function()
	while QBCore == nil do
		TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
		Citizen.Wait(1)
	end
end)

ingelogd = false
opgehaald = false
minuten = 0
db_id = 0

RegisterNetEvent("QBCore:Client:OnPlayerLoaded")
AddEventHandler("QBCore:Client:OnPlayerLoaded", function()
	QBCore.Functions.TriggerCallback("fortis-playtime:server:ontvangPlaytime", function(playtimeTabel)
        if playtimeTabel ~= nil then
            minuten = playtimeTabel.minuten
            if playtimeTabel.db_id > 0 then
                db_id = playtimeTabel.db_id
            else
                db_id = false
            end
        end
	end)
	Wait(400)
	ingelogd = true
end)

Citizen.CreateThread(function()
    while true do
		Citizen.Wait(1)
        if ingelogd then
            minuten = minuten + 1
            if type(db_id) == "boolean" then
			    TriggerServerEvent("fortis-playtime:server:updatePlaytime", minuten, 0)
            else
                TriggerServerEvent("fortis-playtime:server:updatePlaytime", minuten, db_id)
            end
			Citizen.Wait(60000)
        else
            Citizen.Wait(3000)
        end
    end
end)

RegisterCommand("playtime", function(source, args)
    local dagen = 0
	local uren = math.floor(minuten/60)
    local minuten = minuten - uren * 60
    while uren >= 24 do
        dagen = dagen + 1
        uren = uren - 24
    end

    local dagenText = "dagen"
    local urenText = "uren"
    local minutenText = "minuten"

    if dagen == 1 then
        dagenText = "dag"
    end
    if uren <= 1 then
        urenText = "uur"
    end
    if minuten == 1 then
        minutenText = "minuut"
    end


    TriggerEvent("chat:addMessage", {
        args = {
            "Playtime",
            "Je hebt "..dagen.." "..dagenText..", "..uren.." "..urenText.." en "..minuten.." "..minutenText.." speeltijd."
        },
        color = {5, 255, 255}
    })
end, false)