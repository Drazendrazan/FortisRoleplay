QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
local synctable = {
	['CITIZENID'] = {
		coords = {x = 1239.68, y = 1903.85, z = 78.82},
		text = '~g~E~w~ - Bezoek Lab',
		action = 'lab'
	}
}

--[[Citizen.CreateThread(function()
    QBCore.Functions.ExecuteSql(true, "SELECT * FROM `zb-labs`", function(result)
        for i=1, #result, 1 do
            table.insert(synctable, {
                coords = result[i].coords,
                level = result[i].level,
                owner = result[i].identifier
            })
        end
    end)
end)--]]

QBCore.Functions.CreateCallback('fr-drugs:server:requestTable', function(source, cb)
    while synctable == nil do Wait(500) end
    cb(synctable)
end)

RegisterServerEvent('fr-drugs:server:requestSort')
AddEventHandler('fr-drugs:server:requestSort', function(sort)
	for k,v in pairs(synctable) do
		if k == sort then
			doAction(v.action)
		end
	end
end)

doAction = function(sort)
	if sort == 'lab' then
	
	elseif sort == '' then
	
	elseif sort == '' then
	
	elseif sort == '' then
	
	end
end