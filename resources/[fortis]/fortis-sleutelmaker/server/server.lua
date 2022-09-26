QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

RegisterNetEvent("fortis-sleutelmaker:server:successBetaald")
AddEventHandler("fortis-sleutelmaker:server:successBetaald", function(vervangen)
    local src = source
    local Player = QBCore.Functions.GetPlayer(source)
    local aantal = math.random(475, 650)
    Player.Functions.AddMoney("bank", aantal, "Slotenmaker job")
    TriggerClientEvent("QBCore:Notify", src, "Super werk geleverd, ik ben hier super blij mee! Ik heb het factuurbedrag van €"..aantal.." aan je overgemaakt!", "success")

end)

RegisterNetEvent("fortis-sleutelmaker:server:successBetaaldExtra")
AddEventHandler("fortis-sleutelmaker:server:successBetaaldExtra", function(vervangen)
    local src = source
    local Player = QBCore.Functions.GetPlayer(source)
    local aantal = math.random(175, 250)
    local extra = math.random(150, 275)

    local totaal = extra + aantal

    Player.Functions.AddMoney("bank", totaal, "Slotenmaker job + extra")

    TriggerClientEvent("QBCore:Notify", src, "Super werk geleverd, ik ben hier super blij mee! Ik heb het factuurbedrag van €"..totaal.." aan je overgemaakt! Hier zit ook een extratje bij", "success")

end)  

RegisterNetEvent("fortis-sleutelmaker:server:kauloHacker")
AddEventHandler("fortis-sleutelmaker:server:kauloHacker", function()
    local src = source
    TriggerClientEvent('chatMessage', -1, "Fortis AntiCheat", "error", GetPlayerName(src).." is automatisch verbannen voor hacken binnen het Sleutelmaker script.")
    local reason = "Hacken binnen het Sleutelmaker script"
    QBCore.Functions.ExecuteSql(false, "INSERT INTO `bans` (`name`, `steam`, `license`, `discord`,`ip`, `reason`, `expire`, `bannedby`) VALUES ('"..GetPlayerName(src).."', '"..GetPlayerIdentifiers(src)[1].."', '"..GetPlayerIdentifiers(src)[2].."', '"..GetPlayerIdentifiers(src)[3].."', '"..GetPlayerIdentifiers(src)[4].."', '"..reason.."', 2145913200, '"..GetPlayerName(src).."')")
    DropPlayer(src, "Hacken binnen het sleutelmaker script: https://fortisroleplay.nl/discord")
end)