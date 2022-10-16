QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

local doorInfo = {}

RegisterServerEvent('qb-doorlock:server:setupDoors')
AddEventHandler('qb-doorlock:server:setupDoors', function()
	local src = source
	TriggerClientEvent("qb-doorlock:client:setDoors", QB.Doors)
end)

RegisterServerEvent('qb-doorlock:server:updateState')
AddEventHandler('qb-doorlock:server:updateState', function(doorID, state)
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
	
	QB.Doors[doorID].locked = state

	TriggerClientEvent('qb-doorlock:client:setState', -1, doorID, state)
end)

RegisterServerEvent("qb-doorlock:server:updateStateGevangenis")
AddEventHandler("qb-doorlock:server:updateStateGevangenis", function(deur)
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)

	if deur == 1 then
		for k, v in pairs(QB.Doors) do
			if v.gevangenis1 ~= nil and v.gevangenis1 == true then
				QB.Doors[k].locked = false
				TriggerClientEvent('qb-doorlock:client:setState', -1, k, false)
			end
		end
	elseif deur == 2 then
		for k, v in pairs(QB.Doors) do
			if v.gevangenisFull ~= nil and v.gevangenisFull == true then
				QB.Doors[k].locked = false
				TriggerClientEvent('qb-doorlock:client:setState', -1, k, false)
			end
		end
	end
end)