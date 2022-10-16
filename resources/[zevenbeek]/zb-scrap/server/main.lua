QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

local materiaalVerzameld = {}
local eerste = true

RegisterNetEvent("zb-scrap:server:itemGeven")
AddEventHandler("zb-scrap:server:itemGeven", function(materiaal, key)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local materiaal = materiaal
    local item = materiaal
    local steam = GetPlayerIdentifiers(src)[1]
    if materiaal == "Staal" then
        item = "steel"
        materiaal2 = "staal"
    elseif materiaal == "Plastic" then
        item = "plastic"
        materiaal2 = "plastic"
    elseif materiaal == "Koper" then
        item = "copper"
        materiaal2 = "koper"
    elseif materiaal == "Ijzer" then
        item = "iron"
        materiaal2 = "ijzer"
    elseif materiaal == "Rubber" then
        item = "rubber"
        materiaal2 = "rubber"
    elseif materiaal == "Aluminum" then
        item = "Aluminum"
        materiaal2 = "aluminium"
    elseif materiaal == "Glas" then
        item = "glass"
        materiaal2 = "glas"
    elseif materiaal == "Metaalschroot" then
        item = "metalscrap"
        materiaal2 = "metaalschroot"
    end
    if materiaal == "Rubber" then
        aantal = math.random(6, 13)
    else
        aantal = math.random(13, 26)
    end
    Player.Functions.AddItem(item, aantal)
    TriggerClientEvent('QBCore:Notify', src, "Je hebt "..aantal.." "..materiaal2.." ontvangen!")
end)

QBCore.Functions.CreateCallback("zb-scrap:server:checkScrap", function(source, cb, materiaal)
    local scrap = materiaal
    local src = source
    local steam = GetPlayerIdentifiers(src)[1]
    local volgende = false
    local callback = 0

    for k, v in pairs(materiaalVerzameld) do
        if k == steam then
            if v[1] == scrap or v[2] == scrap or v[3] == scrap or v[4] == scrap or v[5] == scrap or v[6] == scrap or v[7] == scrap or v[8] == scrap then
                callback = 1
            end
        end
    end        
    cb(callback)
end)
 
RegisterServerEvent("zb-scrap:server:klaar")
AddEventHandler("zb-scrap:server:klaar", function(materiaal, eerste)
    local src = source
    local steam = GetPlayerIdentifiers(src)[1]
    local materiaal = materiaal
    local eerste = eerste
    if eerste then
        materiaalVerzameld[steam] = {materiaal}
        eerste = false
        return
    end
    if not eerste then
        table.insert(materiaalVerzameld[steam], materiaal)
    end
end)

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