QBcore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)


local magazijnen = {}

-- Loop om handel app data per magazijn te updaten elk uur
local serverOpgestart = false
Citizen.CreateThread(function()
    while true do
        if not serverOpgestart then
            serverOpgestart = true
            QBCore.Functions.ExecuteSql(true, "SELECT * FROM `groothandels`", function(rows)
                if rows ~= nil and #rows > 0 then
                    -- Loop over elk magazijn, en sla hem op met handel app data en sources :)
                    for k, v in pairs(rows) do
                        v.data = json.decode(v.data)

                        magazijnen[v.id] = {
                            ["sources"] = {},
                            ["handel_data"] = {},
                            ["specialisaties"] = v.data.specialisaties,
                            ["illegaal"] = v.data.illegaal
                        }

                        Wait(10)
                        -- Als je hieronder iets aanpast, vergeet dan niet bij het kopen van een magazijn aan te passen & hieronder bij de else natuurlijk bitchass
                        local tmp_handel_count_done = 0
                        while (tmp_handel_count_done < 20) do
                            tmp_handel_count_done = tmp_handel_count_done + 1

                            -- Product nummer generaten (Categorie basically)
                            local product_nummer = nil
                            if v.data.illegaal then
                                product_nummer = math.random(1, #Config.categorieen)
                            else
                                product_nummer = math.random(1, 10)
                            end
                            
                            local tmp_handel_tabel = {
                                ["naam"] = Config.randomNamen[math.random(1, #Config.randomNamen)],
                                ["product"] = Config.categorieen[product_nummer],
                                ["product_cfg_nummer"] = product_nummer,
                                ["transport"] = math.random(1, 3)
                            }

                            -- Bepaal type (inkopen of verkopen in tabel)
                            if tmp_handel_count_done > 10 then
                                -- Inkopen
                                if magazijnen[v.id].handel_data.inkopen == nil then
                                    magazijnen[v.id].handel_data["inkopen"] = {}
                                end

                                -- Kosten genereren
                                local tmp_bedragKey = Config.doosPrijzen["inkopen"][tmp_handel_tabel.transport]
                                tmp_handel_tabel["bedrag"] = math.random(tmp_bedragKey.minimaal, tmp_bedragKey.maximaal)
                                table.insert(magazijnen[v.id].handel_data.inkopen, tmp_handel_tabel)
                            else
                                -- Verkopen
                                if magazijnen[v.id].handel_data.verkopen == nil then
                                    magazijnen[v.id].handel_data["verkopen"] = {}
                                end

                                -- Kosten genereren
                                local tmp_bedragKey = Config.doosPrijzen["verkopen"][tmp_handel_tabel.transport]
                                tmp_handel_tabel["bedrag"] = math.random(tmp_bedragKey.minimaal, tmp_bedragKey.maximaal)
                                table.insert(magazijnen[v.id].handel_data.verkopen, tmp_handel_tabel)
                            end
                        end
                    end
                end
            end)
        else
            -- Server is al opgestart, sync nu nieuwe handel data  op basis van de tabel
            for k, v in pairs(magazijnen) do

                magazijnen[k].handel_data = {}

                Wait(10)
                -- Als je hieronder iets aanpast, vergeet dan niet bij het kopen van een magazijn aan te passen
                local tmp_handel_count_done = 0
                while (tmp_handel_count_done < 20) do
                    tmp_handel_count_done = tmp_handel_count_done + 1

                    -- Product nummer generaten (Categorie basically)
                    local product_nummer = nil
                    if v.illegaal then
                        product_nummer = math.random(1, #Config.categorieen)
                    else
                        product_nummer = math.random(1, 10)
                    end

                    local tmp_handel_tabel = {
                        ["naam"] = Config.randomNamen[math.random(1, #Config.randomNamen)],
                        ["product"] = Config.categorieen[product_nummer],
                        ["product_cfg_nummer"] = product_nummer,
                        ["transport"] = math.random(1, 3)
                    }

                    -- Bepaal type (inkopen of verkopen in tabel)
                    if tmp_handel_count_done > 10 then
                        -- Inkopen
                        if magazijnen[k].handel_data.inkopen == nil then
                            magazijnen[k].handel_data["inkopen"] = {}
                        end

                        -- Kosten genereren
                        local tmp_bedragKey = Config.doosPrijzen["inkopen"][tmp_handel_tabel.transport]
                        tmp_handel_tabel["bedrag"] = math.random(tmp_bedragKey.minimaal, tmp_bedragKey.maximaal)
                        table.insert(magazijnen[k].handel_data.inkopen, tmp_handel_tabel)
                    else
                        -- Verkopen
                        if magazijnen[k].handel_data.verkopen == nil then
                            magazijnen[k].handel_data["verkopen"] = {}
                        end

                        -- Kosten genereren
                        local tmp_bedragKey = Config.doosPrijzen["verkopen"][tmp_handel_tabel.transport]
                        tmp_handel_tabel["bedrag"] = math.random(tmp_bedragKey.minimaal, tmp_bedragKey.maximaal)
                        table.insert(magazijnen[k].handel_data.verkopen, tmp_handel_tabel)
                    end
                end
                -- Sync naar spelers
                for _k, _v in pairs(v.sources) do
                    TriggerClientEvent("zb-groothandel:client:syncMagazijnHandelData", _v, magazijnen[k].handel_data)
                end
            end
        end
        
        -- Wacht weer een uur
        Wait(60 * 60000)
    end
end)

-- Speler logt in
RegisterNetEvent("zb-groothandel:server:playerLoggedIn")
AddEventHandler("zb-groothandel:server:playerLoggedIn", function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if Player ~= nil then
        local citizenid = Player.PlayerData.citizenid
        QBCore.Functions.ExecuteSql(true, "SELECT * FROM `groothandels` WHERE citizenid = '"..citizenid.."' OR werknemers LIKE '%"..citizenid.."%';", function(row)
            if #row == 0 then return else
                -- Heeft een groothandel magazijn OF is werknemer
                local row = row[1]
                if row.citizenid == citizenid then
                    -- Is eigenaar, haal ook meer shit op over werknemers
                    row.werknemers = json.decode(row.werknemers)
                    local fullWerknemersTable = {}

                    for k, v in pairs(row.werknemers) do
                        -- row.werknemers[k].gegevens = {voornaam = "Iris", achternaam = "Cute"}
                        QBCore.Functions.ExecuteSql(true, "SELECT charinfo FROM players WHERE citizenid = '"..v.."'", function(werknemer_row)
                            if #werknemer_row > 0 then
                                werknemer_row = json.decode(werknemer_row[1].charinfo)

                                -- Zet data in de tmp nieuwe table die we gaan returnen
                                fullWerknemersTable[v] = {voornaam = werknemer_row.firstname, achternaam = werknemer_row.lastname}
                            end
                        end)
                    end
                    TriggerClientEvent("zb-groothandel:client:syncWerknemers", src, json.encode(fullWerknemersTable))
                    row["werknemer"] = false
                else
                    -- Is medewerker
                    row["werknemer"] = true
                end
                voegSourceToe(src, row.id)
                TriggerClientEvent("zb-groothandel:client:syncMagazijn", src, row)
            end
        end)
    end
end)

function voegSourceToe(source, id)
    for k, v in pairs(magazijnen) do
        if k == id then
            table.insert(v.sources, source)
            return
        end
    end
    return
end


-- Kopen van een groothandel
RegisterNetEvent("zb-groothandel:server:koopGroothandel")
AddEventHandler("zb-groothandel:server:koopGroothandel", function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if Player ~= nil then
        local citizenid = Player.PlayerData.citizenid
        QBCore.Functions.ExecuteSql(true, "SELECT * FROM `groothandels` WHERE citizenid = '"..citizenid.."' OR werknemers LIKE '%"..citizenid.."%'", function(resultaat)
            if #resultaat == 0 then
                local bank = Player.PlayerData.money["bank"]
                if bank >= Config.groothandelPrijs then
                    -- Kan groothandel betalen, start aankoop
                    Player.Functions.RemoveMoney("bank", Config.groothandelPrijs, "Groothandel gekocht")
                
                    -- Data klaarmaken voor in de database
                    local dataTable = {
                        ["coords"] = Config.groothandelDeuren[math.random(1, #Config.groothandelDeuren)],
                        ["voertuigen"] = {
                            ["auto"] = false,
                            ["busje"] = false,
                            ["vrachtwagen"] = false
                        },
                        ["specialisaties"] = {
                            [1] = math.random(1, 5),
                            [2] = math.random(6, 10)
                        },
                        ["specialisatie_timeout"] = os.time() + 604800, -- 7 dagen
                        ["werknemerspots"] = 0,
                        ["illegaal"] = false
                    }
                
                    local opslagTable = {
                        [1] = {
                            ["gevuld"] = 0,
                            ["categorie"] = 0
                        },
                        [2] = {
                            ["gevuld"] = 0,
                            ["categorie"] = 0
                        },
                        [3] = {
                            ["gevuld"] = 0,
                            ["categorie"] = 0
                        },
                        [4] = {
                            ["gevuld"] = 0,
                            ["categorie"] = 0
                        },
                        [5] = {
                            ["gevuld"] = 0,
                            ["categorie"] = 0
                        },
                        [6] = {
                            ["gevuld"] = 0,
                            ["categorie"] = 0
                        },
                        [7] = {
                            ["gevuld"] = 0,
                            ["categorie"] = 0
                        },
                        [8] = {
                            ["gevuld"] = 0,
                            ["categorie"] = 0
                        },
                        [9] = {
                            ["gevuld"] = 0,
                            ["categorie"] = 0
                        },
                        [10] = {
                            ["gevuld"] = 0,
                            ["categorie"] = 0
                        }
                    }
                
                    -- Push het naar de database
                    QBCore.Functions.ExecuteSql(true, "INSERT INTO `groothandels` (citizenid, data, opslag, werknemers) VALUES ('"..citizenid.."', '"..json.encode(dataTable).."', '"..json.encode(opslagTable).."', '"..json.encode({}).."')")
                    QBCore.Functions.ExecuteSql(true, "SELECT * FROM `groothandels` WHERE citizenid = '"..citizenid.."'", function(groothandelRow)
                        groothandelRow = groothandelRow[1]
                        groothandelRow["werknemer"] = false
                        TriggerClientEvent("zb-groothandel:client:syncMagazijn", src, groothandelRow)
                        local legeWerknemersTable = {}
                        TriggerClientEvent("zb-groothandel:client:syncWerknemers", src, json.encode(legeWerknemersTable))
                    
                        -- Zet het magazijn in de tabel
                        groothandelRow.data = json.decode(groothandelRow.data)
                        magazijnen[groothandelRow.id] = {
                            ["sources"] = {},
                            ["handel_data"] = {},
                            ["specialisaties"] = groothandelRow.data.specialisaties
                        }
                        voegSourceToe(src, groothandelRow.id)
                    
                        -- Als je hieronder iets aanpast, vergeet dan niet bij de grote loop van het genereren van specialisaties te veranderen!
                        local tmp_handel_count_done = 0
                        while (tmp_handel_count_done < 20) do
                            tmp_handel_count_done = tmp_handel_count_done + 1
                        
                            -- Product nummer generaten (Categorie basically)
                            local product_nummer = math.random(1, 10)
                            

                            local tmp_handel_tabel = {
                                ["naam"] = Config.randomNamen[math.random(1, #Config.randomNamen)],
                                ["product"] = Config.categorieen[product_nummer],
                                ["product_cfg_nummer"] = product_nummer,
                                ["transport"] = math.random(1, 3)
                            }
                        
                            -- Bepaal type (inkopen of verkopen in tabel)
                            if tmp_handel_count_done > 10 then
                                -- Inkopen
                                if magazijnen[groothandelRow.id].handel_data.inkopen == nil then
                                    magazijnen[groothandelRow.id].handel_data["inkopen"] = {}
                                end

                                -- Kosten genereren
                                local tmp_bedragKey = Config.doosPrijzen["inkopen"][tmp_handel_tabel.transport]
                                tmp_handel_tabel["bedrag"] = math.random(tmp_bedragKey.minimaal, tmp_bedragKey.maximaal)
                                table.insert(magazijnen[groothandelRow.id].handel_data.inkopen, tmp_handel_tabel)
                            else
                                -- Verkopen
                                if magazijnen[groothandelRow.id].handel_data.verkopen == nil then
                                    magazijnen[groothandelRow.id].handel_data["verkopen"] = {}
                                end

                                -- Kosten genereren
                                local tmp_bedragKey = Config.doosPrijzen["verkopen"][tmp_handel_tabel.transport]
                                tmp_handel_tabel["bedrag"] = math.random(tmp_bedragKey.minimaal, tmp_bedragKey.maximaal)
                                table.insert(magazijnen[groothandelRow.id].handel_data.verkopen, tmp_handel_tabel)
                            end
                        end

                        TriggerClientEvent("QBCore:Notify", src, "Je hebt een groothandel gekocht, hij staat binnen enkele ogenblikken op je kaart!", "success", "4500")
                    end)
                

                else
                    -- Kan groothandel niet betalen
                    TriggerClientEvent("QBCore:Notify", src, "Je hebt niet genoeg geld op je bank! Je mist €"..(Config.groothandelPrijs - bank).."!", "error")
                end
            else
                -- Heeft al groothandel
                TriggerClientEvent("QBCore:Notify", src, "Je hebt al een groothandel, of zit al bij een groothandel, verlaat deze eerst!", "error", "5000")
            end
        end)
    end
end)

-- Groothandel binnen gaan
QBCore.Functions.CreateCallback("zb-groothandel:server:getMagazijnSpots", function(source, cb, magazijnId)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if Player ~= nil then
        -- Check of er al een magazijn met dit ID bestaat
        for k, v in pairs(Config.shellSpots) do
            if v.actief == true and v.magazijnData ~= nil and v.magazijnData.magazijnID == magazijnId then
                -- Magazijn is al ergens door OF de owner OF een werknemer
                table.insert(Config.shellSpots[k].magazijnData.sources, src)
                cb(k)
                return
            end
        end

        -- Als de loop hier aankomt, dan betekent het dat er nog geen magazijn met dat magazijn ID gespawned is door OF een owner OF medewerker
        for k, v in pairs(Config.shellSpots) do
            if v.actief == false then
                Config.shellSpots[k].actief = true
                Config.shellSpots[k].magazijnData = {
                    ["magazijnID"] = magazijnId,
                    ["sources"] = {src}
                }
                cb(k)
                return
            end
        end
    end
end)

-- Groothandel uit gaan
RegisterNetEvent("zb-groothandel:server:verlaatMagazijn")
AddEventHandler("zb-groothandel:server:verlaatMagazijn", function(spotKeyID)
    local src = source

    if spotKeyID ~= nil then
        if Config.shellSpots[spotKeyID] ~= nil then
            -- Valid request dinges
            if #Config.shellSpots[spotKeyID].magazijnData.sources == 1 then
                -- Delete dat hele kanker ding, er zit toch maar een persoon in (deze dus)
                Config.shellSpots[spotKeyID].actief = false
                Config.shellSpots[spotKeyID].magazijnData = nil
                -- Done
            else
                -- Hij was niet de enigste, verwijder hem wel uit magazijn tho!
                for k, v in pairs(Config.shellSpots[spotKeyID].magazijnData.sources) do
                    -- Check of source overeenkomt met de source die hier in staat
                    if v == src then
                        -- Dit is de juiste,verwijder!!!!!!!!
                        table.remove(Config.shellSpots[spotKeyID].magazijnData.sources, k)
                        if #Config.shellSpots[spotKeyID].magazijnData.sources == 0 then
                            -- Er zijn geen sources meer over, maak die kanker magazijn vrij a goon
                            Config.shellSpots[spotKeyID].actief = false
                            Config.shellSpots[spotKeyID].magazijnData = nil
                        end
                    end
                end
            end
        end
    end
end)

-- Speler leaved server, of zn gimma is gecrashed kanker goedkope kanker budget kanker gamer
AddEventHandler("playerDropped", function(reason)
    local src = source

    if src ~= nil then
        for k, v in pairs(Config.shellSpots) do
            if v.actief == true and v.magazijnData ~= nil then
                -- Dit is een actief magazijn, check of hij hier een onderdeel van was, zo ja vrijmaken die kkr troep
                for _k, _v in pairs(v.magazijnData.sources) do
                    -- Check of source overeenkomt met de source die hier in staat
                    if _v == src then
                        -- Dit is de juiste,verwijder!!!!!!!!
                        table.remove(Config.shellSpots[k].magazijnData.sources, _k)
                        if #Config.shellSpots[k].magazijnData.sources == 0 then
                            -- Er zijn geen sources meer over, maak die kanker magazijn vrij a goon
                            Config.shellSpots[k].actief = false
                            Config.shellSpots[k].magazijnData = nil
                        end
                    end
                end
            end
        end
    end
end)

-- Speler gaat magazijn binnen en vraag handel data op (als ie die nog niet heeft)
RegisterNetEvent("zb-groothandel:server:vraagHandelData")
AddEventHandler("zb-groothandel:server:vraagHandelData", function(groothandelID)
    local src = source

    if groothandelID ~= nil and magazijnen[groothandelID] ~= nil and magazijnen[groothandelID].handel_data ~= nil then
        TriggerClientEvent("zb-groothandel:client:syncMagazijnHandelData", src, magazijnen[groothandelID].handel_data)
    end
end)

-- Speler neemt werknemer aan in magazijn callback :(
QBCore.Functions.CreateCallback("zb-groothandel:server:werknemerAannemen", function(source, cb, cidSpeler, groothandelID)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if Player ~= nil and cidSpeler ~= nil then
        cidSpeler = cidSpeler:upper()
        -- Speler ophalen die aangenomen moet worden
        local werknemerData = QBCore.Functions.GetPlayerByCitizenId(cidSpeler)

        if werknemerData ~= nil then
            if werknemerData.PlayerData.source ~= src then

                -- Check of de speler die uitgenodigd wordt niet al ZELF een magazijn heeft of al bij een magazijn ZIT
                QBCore.Functions.ExecuteSql(true, "SELECT * FROM `groothandels` WHERE citizenid = '"..cidSpeler.."' OR werknemers LIKE '%"..cidSpeler.."%'", function(resultaat)
                    if #resultaat == 0 then
                        -- Speler zit niet bij een magazijn, en beheert zelf ook geen magazijn
                        TriggerEvent("qb-phone:server:sendNewMail", {
                            sender = Player.PlayerData.charinfo.firstname.." "..Player.PlayerData.charinfo.lastname,
                            subject = "Arbeidsovereenkomst",
                            message = "Beste "..werknemerData.PlayerData.charinfo.firstname..",<br><br>Ik wil je bij deze uitnodigen om in mijn groothandel te komen werken!<br><br>Wil je dit aannemen? Klik dan op het vinkje onderaan in de mail. En dan zie ik je hopelijk snel!",
                            button = {
                                enabled = true,
                                buttonEvent = "zb-groothandel:client:joinGroothandel",
                                buttonData = {
                                    ["magazijnID"] = groothandelID
                                }
                            }
                        }, werknemerData.PlayerData.source)
                        cb(true, "De persoon is uitgenodigd!")
                    else
                        -- Persoon zit bij een magazijn, of beheert er een
                        cb(false, "Persoon zit al bij een groothandel")
                    end
                end)
            else
                cb(false, "Je kan jezelf niet aannemen!")
            end
        else
            cb(false, "Dit is een ongeldige BSN, of de persoon is niet aanwezig op het eiland!")            
        end
    else
        cb(false, "Ongeldig!")
    end
end)

-- Speler ontslaat goon uit magazijn
RegisterNetEvent("zb-groothandel:server:werknemerOntslaan")
AddEventHandler("zb-groothandel:server:werknemerOntslaan", function(citizenid, groothandelID)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)


    if Player ~= nil and citizenid ~= nil and groothandelID ~= nil then
        QBCore.Functions.ExecuteSql(true, "SELECT * FROM groothandels WHERE id = '"..groothandelID.."' AND citizenid = '"..Player.PlayerData.citizenid.."'", function(magazijn_resultaat)
            if #magazijn_resultaat > 0 then
                -- Hij is daadwerkelijk de eigenaar, ontsla die mathafacker
                magazijn_resultaat = magazijn_resultaat[1]

                local werknemersRow = json.decode(magazijn_resultaat.werknemers)
                local deletedWerknemer = false
                for k, v in pairs(werknemersRow) do
                    if v == citizenid then
                        table.remove(werknemersRow, k)
                        deletedWerknemer = true
                    end
                end
                magazijn_resultaat.werknemers = json.encode(werknemersRow)

                -- Check of er echt een citizenid verwijderd is zodat we database queries besparen voor mongolen
                if deletedWerknemer then
                    QBCore.Functions.ExecuteSql(true, "UPDATE groothandels SET werknemers = '"..json.encode(werknemersRow).."' WHERE id = '"..groothandelID.."'")

                    local srcVanOntslagenSpeler = QBCore.Functions.GetPlayerByCitizenId(citizenid)

                    -- Sync werknemers voor eigenaar opnieuw
                    local werknemerslijst = json.decode(magazijn_resultaat.werknemers)
                    local fullWerknemersTable = {}

                    for k, v in pairs(werknemerslijst) do
                        QBCore.Functions.ExecuteSql(true, "SELECT charinfo FROM players WHERE citizenid = '"..v.."'", function(werknemer_row)
                            if #werknemer_row > 0 then
                                werknemer_row = json.decode(werknemer_row[1].charinfo)

                                -- Zet data in de tmp nieuwe table die we gaan returnen
                                fullWerknemersTable[v] = {voornaam = werknemer_row.firstname, achternaam = werknemer_row.lastname}
                            end
                        end)
                    end
                    TriggerClientEvent("zb-groothandel:client:syncWerknemers", src, json.encode(fullWerknemersTable))

                    -- Stuur nog een regular sync
                    for k, v in pairs(magazijnen[magazijn_resultaat.id].sources) do
                        if srcVanOntslagenSpeler.PlayerData.source ~= nil and v == srcVanOntslagenSpeler.PlayerData.source then
                            -- Deze goon is ontslagen, stuur hem zn moeder
                            TriggerClientEvent("zb-groothandel:client:spelerOntslagen", srcVanOntslagenSpeler.PlayerData.source)
                        else
                            -- Stuur regular sync
                            TriggerClientEvent("zb-groothandel:client:syncMagazijn", v, magazijn_resultaat)
                        end
                    end
                end
            end
        end)
    end
end)

-- Speler neemt groothandel mail aan
RegisterNetEvent("zb-groothandel:server:joinGroothandel")
AddEventHandler("zb-groothandel:server:joinGroothandel", function(magazijnID)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if Player ~= nil and magazijnID ~= nil then
        local cidSpeler = Player.PlayerData.citizenid
        QBCore.Functions.ExecuteSql(true, "SELECT * FROM `groothandels` WHERE citizenid = '"..cidSpeler.."' OR werknemers LIKE '%"..cidSpeler.."%'", function(resultaat)
            if #resultaat == 0 then
                TriggerClientEvent("QBCore:Notify", src, "Je hebt het contract aangenomen! De groothandel zal binnen enkele momenten op je GPS staan.", "success")
                QBCore.Functions.ExecuteSql(true, "SELECT * FROM groothandels WHERE id = "..magazijnID.."", function(tmp_groothandel_row)
                    if #tmp_groothandel_row > 0 then
                        tmp_groothandel_row = tmp_groothandel_row[1]

                        local tmp_werknemers = json.decode(tmp_groothandel_row.werknemers)
                        table.insert(tmp_werknemers, cidSpeler)

                        QBCore.Functions.ExecuteSql(true, "UPDATE groothandels SET werknemers = '"..json.encode(tmp_werknemers).."' WHERE id = "..magazijnID.."")
                        Wait(500)

                        QBCore.Functions.ExecuteSql(true, "SELECT * FROM `groothandels` WHERE citizenid = '"..cidSpeler.."' OR werknemers LIKE '%"..cidSpeler.."%';", function(row)
                            if #row == 0 then return else
                                -- Heeft een groothandel magazijn OF is werknemer
                                local row = row[1]

                                if row.citizenid == cidSpeler then
                                    -- Is eigenaar
                                    row["werknemer"] = false
                                else
                                    -- Is medewerker
                                    row["werknemer"] = true
                                end

                                -- Sync werknemers voor eigenaar opnieuw

                                local srcVanEigenaar = QBCore.Functions.GetPlayerByCitizenId(row.citizenid)
                                if srcVanEigenaar ~= nil then
                                    -- Eigenaar is online update zn lijsie met zn meisie
                                    local werknemerslijst = json.decode(row.werknemers)
                                    local fullWerknemersTable = {}

                                    for k, v in pairs(werknemerslijst) do
                                        QBCore.Functions.ExecuteSql(true, "SELECT charinfo FROM players WHERE citizenid = '"..v.."'", function(werknemer_row)
                                            if #werknemer_row > 0 then
                                                werknemer_row = json.decode(werknemer_row[1].charinfo)
                                            
                                                -- Zet data in de tmp nieuwe table die we gaan returnen
                                                fullWerknemersTable[v] = {voornaam = werknemer_row.firstname, achternaam = werknemer_row.lastname}
                                            end
                                        end)
                                    end
                                    TriggerClientEvent("zb-groothandel:client:syncWerknemers", srcVanEigenaar.PlayerData.source, json.encode(fullWerknemersTable))
                                end

                                voegSourceToe(src, row.id)
                                Wait(100)
                                -- Sync shit naar elke gast die in magazijn zit
                                for k, v in pairs(magazijnen[row.id].sources) do
                                    TriggerClientEvent("zb-groothandel:client:syncMagazijn", v, row)
                                end
                            end
                        end)

                    end
                end)
            else
                TriggerClientEvent("QBCore:Notify", src, "Je hebt al een groothandel, of zit al bij een groothandel, verlaat deze eerst!", "error", "5000")
            end

        end)
    else
        TriggerClientEvent("QBCore:Notify", src, "Er is iets fout gegaan, vraag een nieuwe uitnodiging aan!", "error", "5000")
    end

end)

-- Eigenaar koopt werknemer slot erbij
RegisterNetEvent("zb-groothandel:server:koopWerknemerSlot")
AddEventHandler("zb-groothandel:server:koopWerknemerSlot", function(groothandelID)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if groothandelID ~= nil and Player ~= nil then
        QBCore.Functions.ExecuteSql(true, "SELECT * FROM groothandels WHERE id = '"..groothandelID.."' AND citizenid = '"..Player.PlayerData.citizenid.."'", function(tmp_groothandel)
            if #tmp_groothandel > 0 then
                -- Persoon is eigenaar, laat m slotje kopen oulleh
                local bank = Player.PlayerData.money["bank"]
                if bank >= Config.werknemerSlotPrijs then
                    -- Data manipuleren
                    tmp_groothandel = tmp_groothandel[1]
                    tmp_groothandel.data = json.decode(tmp_groothandel.data)

                    if tmp_groothandel.data.werknemerspots < 5 then
                        -- Geld weghalen
                        Player.Functions.RemoveMoney("bank", Config.werknemerSlotPrijs, "Werknemerslot gekocht")
                        
                        tmp_groothandel.data.werknemerspots = tmp_groothandel.data.werknemerspots + 1
                        
                        tmp_groothandel.data = json.encode(tmp_groothandel.data)

                        tmp_groothandel.werknemer = false
                        
                        -- Push naar database
                        QBCore.Functions.ExecuteSql(true, "UPDATE groothandels SET data = '"..tmp_groothandel.data.."' WHERE id = '"..groothandelID.."'")
                        TriggerClientEvent("QBCore:Notify", src, "Je hebt een extra werknemer slot bij gekocht!", "success", "5000")
                        Wait(100)
                        TriggerClientEvent("zb-groothandel:client:syncMagazijn", src, tmp_groothandel)
                    else
                        TriggerClientEvent("QBCore:Notify", src, "Je hebt al het maximaal aantal werknemer spots!", "error", "5000")
                    end
                else
                    TriggerClientEvent("QBCore:Notify", src, "Je hebt niet genoeg geld op je bank om een werknemer slot te kunnen betalen! Dit kost: €"..Config.werknemerSlotPrijs, "error", "5000")
                end
            end
        end)
    end
end)

-- Eigenaar veranderd specialisties, altijd lit!!!!!!!!!!!!!!!!!!!!!!!
RegisterNetEvent("zb-groothandel:server:veranderSpecialisaties")
AddEventHandler("zb-groothandel:server:veranderSpecialisaties", function(groothandelID)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if Player ~= nil and groothandelID ~= nil then
        -- Lua is lit oh shit
        local citizenidOWNER = Player.PlayerData.citizenid
        QBCore.Functions.ExecuteSql(true, "SELECT * FROM groothandels WHERE citizenid = '"..citizenidOWNER.."' AND id = "..groothandelID.."", function(tmp_groothandel)
            if #tmp_groothandel > 0 then
                -- JAja hij heeft er een, geen hacker wat goeeeeeewed :sdfasjdljkfdsljkafdsjlffsjdfasafsdsfafsd sorry was in slaap gevallen op mn toetsenbord van dit leuke script, bye
                tmp_groothandel = tmp_groothandel[1]
                -- Bingus
                tmp_groothandel.data = json.decode(tmp_groothandel.data)
                local current_specialisaties = tmp_groothandel.data.specialisaties

                -- Nieuwe species maken
                local specie1 = math.random(1, 5)
                local specie2 = math.random(6, 10)

                -- Meest mongolische check ooit maar ewa ja heb geen zin toch, dan heb j e dat
                if specie1 == current_specialisaties[1] or specie1 == current_specialisaties[2] then
                    specie1 = math.random(1, 5)
                end
                if specie2 == current_specialisaties[2] or specie2 == current_specialisaties[1] then
                    specie2 = math.random(1, 5)
                end
                
                local nieuweSpecies = {
                    [1] = specie1,
                    [2] = specie2
                }
                tmp_groothandel.data.specialisaties = nieuweSpecies
                tmp_groothandel.data.specialisatie_timeout = os.time() + 604800 -- 7 dagen

                tmp_groothandel.data = json.encode(tmp_groothandel.data)

                -- update naar db 
                QBCore.Functions.ExecuteSql(true, "UPDATE groothandels SET data = '"..tmp_groothandel.data.."' WHERE id = "..groothandelID.."")

                for k, v in pairs(magazijnen[tmp_groothandel.id].sources) do
                    TriggerClientEvent("zb-groothandel:client:syncMagazijn", v, tmp_groothandel)
                end
                
            end
        end)
    end
end)


-- Eigenaar neemt geld op van bedrijfs rekeningnoe
RegisterNetEvent("zb-groothandel:server:balansOpnemen")
AddEventHandler("zb-groothandel:server:balansOpnemen", function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if Player ~= nil and src ~= nil then
        local citizenid = Player.PlayerData.citizenid
        QBCore.Functions.ExecuteSql(true, "SELECT * FROM groothandels WHERE citizenid = '"..citizenid.."'", function(tmp_groothandel)
            if #tmp_groothandel > 0 then
                tmp_groothandel = tmp_groothandel[1]
                QBCore.Functions.ExecuteSql(true, "UPDATE groothandels SET bank = '0' WHERE id = "..tmp_groothandel.id.."")
                if tmp_groothandel.bank > 0 then
                    TriggerClientEvent("QBCore:Notify", src, "Er is "..tmp_groothandel.bank.." naar je rekening overgemaakt!", "success")
                    Player.Functions.AddMoney("bank", tmp_groothandel.bank, "Geld van groothandel bedrijfsrekening opgenomen")
                    tmp_groothandel.bank = 0
                    TriggerClientEvent("zb-groothandel:client:syncMagazijn", src, tmp_groothandel)
                else
                    TriggerClientEvent("QBCore:Notify", src, "Je hebt geen geld op je bedrijfsrekening staan!", "error")
                end
            end
        end)
    end
end)

-- Speler koopt voertuig in magazijn app
RegisterNetEvent("zb-groothandel:server:koopVoertuig")
AddEventHandler("zb-groothandel:server:koopVoertuig", function(voertuig)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local bedrag = nil

    if voertuig == "auto" then bedrag = 50000 end
    if voertuig == "busje" then bedrag = 75000 end
    if voertuig == "vrachtwagen" then bedrag = 100000 end

    if Player ~= nil and src ~= nil then
        local citizenid = Player.PlayerData.citizenid
        if Player.PlayerData.money["bank"] >= bedrag then
            QBCore.Functions.ExecuteSql(true, "SELECT * FROM groothandels WHERE citizenid = '"..citizenid.."'", function(tmp_groothandel)
                if #tmp_groothandel > 0 then
                    tmp_groothandel = tmp_groothandel[1]
                    local tmp_data = json.decode(tmp_groothandel.data)
                    tmp_data.voertuigen[voertuig] = true
                    QBCore.Functions.ExecuteSql(true, "UPDATE groothandels SET data = '"..json.encode(tmp_data).."' WHERE id = '"..tmp_groothandel.id.."'")
                    tmp_groothandel.data = json.encode(tmp_data)
                    for k, v in pairs(magazijnen[tmp_groothandel.id].sources) do
                        TriggerClientEvent("zb-groothandel:client:syncMagazijn", v, tmp_groothandel)
                    end
                    TriggerClientEvent("QBCore:Notify", src, "Je hebt een "..voertuig.." gekocht voor €"..bedrag.."!", "success")
                    Player.Functions.RemoveMoney("bank", bedrag, "Voertuig in groothandel gekocht")
                end
            end)
        else
            TriggerClientEvent("QBCore:Notify", src, "Je hebt niet genoeg geld op je rekening staan!", "error")
        end
    end
end)

-- Speler neemt inkoop/verkoop ronde aan, verwijder rij uit app
QBCore.Functions.CreateCallback("zb-groothandel:server:verwijderHandelRij", function(source, cb, rijID, type, groothandelID, aantal)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if rijID ~= nil and type ~= nil and groothandelID ~= nil and magazijnen[groothandelID] ~= nil then
        if type == "inkopen" then
            if magazijnen[groothandelID].handel_data.inkopen[rijID] ~= nil then

                -- Geld afschrijven en checken of ie genoeg heeft
                if Player.PlayerData.money["bank"] >= magazijnen[groothandelID].handel_data.inkopen[rijID].bedrag then
                    Player.Functions.RemoveMoney("bank", magazijnen[groothandelID].handel_data.inkopen[rijID].bedrag, "Inkoopronde groothandel, transport type: "..aantal)
                else
                    local tmp_return_table = {correct = false, message = "Je hebt niet genoeg geld om deze ronde te starten!"}
                    cb(tmp_return_table)
                    return
                end

                table.remove(magazijnen[groothandelID].handel_data.inkopen, rijID)
                -- Sync naar spelers
                for k, v in pairs(magazijnen[groothandelID].sources) do
                    TriggerClientEvent("zb-groothandel:client:syncMagazijnHandelData", v, magazijnen[groothandelID].handel_data)
                end

                local tmp_return_table = {correct = true, message = ""}
                cb(tmp_return_table)
            else
                local tmp_return_table = {correct = false, message = "Deze taak is al door iemand anders aangenomen!"}
                cb(tmp_return_table)
            end
        elseif type == "verkopen" then
            if magazijnen[groothandelID].handel_data.verkopen[rijID] ~= nil then
                -- Check of het magazijn van hem dit wel echt bezit
                QBCore.Functions.ExecuteSql(true, "SELECT * FROM groothandels WHERE id = '"..groothandelID.."'", function(tmp_groothandel)
                    if #tmp_groothandel > 0 then
                        tmp_groothandel = tmp_groothandel[1]
                        local tmp_groothandel_rekdata = json.decode(tmp_groothandel.opslag)
                        local product_id = magazijnen[groothandelID].handel_data.verkopen[rijID].product_cfg_nummer
                        
                        local totaalGevonden = 0
                        local tmp_rekken_nummers_legen = {}
                        for k, v in pairs(tmp_groothandel_rekdata) do
                            if v.categorie == product_id then
                                -- Ja hij heeft er minimaal 1 van deze categorie, even optellen
                                totaalGevonden = totaalGevonden + v.gevuld
                                table.insert(tmp_rekken_nummers_legen, k)
                            end
                        end

                        if totaalGevonden >= aantal and tmp_rekken_nummers_legen ~= nil then
                            -- Persoon heeft genoeg dozen om te verkopen! Verwijder handel rij, verwijder uit groothandel, en syncen
                            for k, v in pairs(tmp_rekken_nummers_legen) do
                                if aantal > 0 then
                                    -- Doorgaan, er moet nog wat vanaf
                                    if tmp_groothandel_rekdata[v].gevuld < aantal then
                                        -- Niet genoeg in dit kanker rek, haal deze kanker moeder leeg, en zoek door in ander kanker rek
                                        aantal = aantal - tmp_groothandel_rekdata[v].gevuld
                                        tmp_groothandel_rekdata[v].gevuld = 0
                                        tmp_groothandel_rekdata[v].categorie = 0
                                    else
                                        tmp_groothandel_rekdata[v].gevuld = tmp_groothandel_rekdata[v].gevuld - aantal
                                        aantal = 0
                                        if tmp_groothandel_rekdata[v].gevuld == 0 then
                                            -- Leeg maken
                                            tmp_groothandel_rekdata[v].gevuld = 0
                                            tmp_groothandel_rekdata[v].categorie = 0
                                        end
                                    end
                                end
                            end


                            -- Update rekken
                            QBCore.Functions.ExecuteSql(true, "UPDATE groothandels SET opslag = '"..json.encode(tmp_groothandel_rekdata).."' WHERE id = '"..groothandelID.."'")
                            -- Sync naar alle kanker daapjes
                            tmp_groothandel.opslag = json.encode(tmp_groothandel_rekdata)
                            for k, v in pairs(magazijnen[groothandelID].sources) do
                                TriggerClientEvent("zb-groothandel:client:syncMagazijn", v, tmp_groothandel)
                            end

                            table.remove(magazijnen[groothandelID].handel_data.verkopen, rijID)
                            -- Sync naar spelers
                            for k, v in pairs(magazijnen[groothandelID].sources) do
                                TriggerClientEvent("zb-groothandel:client:syncMagazijnHandelData", v, magazijnen[groothandelID].handel_data)
                            end
            
                            local tmp_return_table = {correct = true, message = ""}
                            cb(tmp_return_table)
                        else
                            local tmp_return_table = {correct = false, message = "Je hebt niet genoeg van dit product in je groothandel!"}
                            cb(tmp_return_table)
                        end
                    else
                        local tmp_return_table = {correct = false, message = "Er ging iets fout (Groothandel niet gevonden)!"}
                        cb(tmp_return_table)
                    end
                end)
            else
                local tmp_return_table = {correct = false, message = "Deze taak is al door iemand anders aangenomen!"}
                cb(tmp_return_table)
            end
        end
    else
        cb(false)
    end
end)

-- Speler is klaar met inkoopronde, vul magazijn
RegisterNetEvent("zb-groothandel:server:inkoopklaar")
AddEventHandler("zb-groothandel:server:inkoopklaar", function(groothandelID, rondeData)
    local src = source

    if groothandelID ~= nil and rondeData ~= nil and src ~= nil then
        -- Haal groothandel op
        QBCore.Functions.ExecuteSql(true, "SELECT * FROM groothandels WHERE id = '"..groothandelID.."'", function(tmp_groothandel)
            if #tmp_groothandel > 0 then
                tmp_groothandel = tmp_groothandel[1]
                -- Globale data
                local opslag = json.decode(tmp_groothandel.opslag) -- tabel met alle opslag uit db (rekken basically)
                local categorie_nummer = rondeData.product_cfg_nummer
                local aantal_bijvullen = rondeData.transport

                -- Check of er al rekken gevuld zijn
                local _gevuldeRekken = {} -- Hierin komen alle rekken die al GEVULD ZIJN met DEZELFDE categorie
                local legeRekken = {} -- Hierin komen compleet lege rekken yeet

                for k, v in pairs(opslag) do
                    if v.categorie == categorie_nummer then
                        -- In dit rek zit hetzelfde categorie, check of er uberhaupt nog plek over is
                        if v.gevuld < 3 then
                            -- Er is nog plek, tyf deze in de tabel
                            table.insert(_gevuldeRekken, k)
                        end
                    elseif v.categorie == 0 then
                        -- Deze is kanker leeg, deze kunnen we dus altijd gebruiken litty
                        table.insert(legeRekken, k)
                    end
                end

                -- Check of er rekken gevuld waren, zo ja, check of er nog plek in vrij is
                local gaDoorMetVullen = true -- Als deze op vals staat gaan we niet proberen lege rekken te vullen
                if #_gevuldeRekken > 0 then
                    -- Er zijn rekken gevuld, even checken of er nog rekken zijn waar dit bij past
                    for k, v in pairs(_gevuldeRekken) do
                        if aantal_bijvullen > 0 then
                            -- Er zijn nog dozen die gevuld moeten worden
                            if opslag[v].gevuld == 1 then
                                -- Er kan max 2 bij
                                if opslag[v].gevuld + aantal_bijvullen > 3 then
                                    -- Er blijft wat over
                                    local _overhouden = (opslag[v].gevuld + aantal_bijvullen) - 3 -- TEst dit
                                    opslag[v].gevuld = 3
                                    aantal_bijvullen = _overhouden
                                else
                                    -- Helemaal klaar opgekankerd
                                    gaDoorMetVullen = false
                                    opslag[v].gevuld = opslag[v].gevuld + aantal_bijvullen
                                    aantal_bijvullen = 0
                                end


                            elseif opslag[v].gevuld == 2 then
                                -- Er kan max 1 bij
                                if opslag[v].gevuld + aantal_bijvullen > 3 then
                                    -- Er blijft wat over
                                    local _overhouden = (opslag[v].gevuld + aantal_bijvullen) - 3 -- TEst dit
                                    opslag[v].gevuld = 3
                                    aantal_bijvullen = _overhouden
                                else
                                    -- Helemaal klaar opgekankerd
                                    gaDoorMetVullen = false
                                    opslag[v].gevuld = opslag[v].gevuld + aantal_bijvullen
                                    aantal_bijvullen = 0
                                end
                            end
                        end
                    end
                end

                -- Klaar met loopen over alle betaande rekken, ga nu checken of je nog lege rekken moet gebruiken
                if gaDoorMetVullen and aantal_bijvullen > 0 then
                    if #legeRekken > 0 then
                        -- Er zijn lege rekken over
                        for k, v in pairs(legeRekken) do
                            -- Deze is leeg vul deze en stop
                            if aantal_bijvullen > 0 then
                                opslag[v].gevuld = aantal_bijvullen
                                opslag[v].categorie = categorie_nummer
                                aantal_bijvullen = 0
                            end
                        end
                    else
                        -- Er zijn geen lege rekken, maar wel dozen die nog gevuld moeten worden, waarshcuw speler dat hij kaulo dom is
                        TriggerClientEvent("QBCore:Notify", src, "WAARSCHUWING: Je opslag rekken zijn vol, er zijn "..aantal_bijvullen.." dozen verloren gegaan!", "error", "15000")
                    end
                end

                -- Helemaal klaar, update deze kanker troep in de KANKER database
                QBCore.Functions.ExecuteSql(true, "UPDATE groothandels SET opslag = '"..json.encode(opslag).."', s_opgehaald = s_opgehaald + 1 WHERE id = '"..groothandelID.."'")
                tmp_groothandel.s_opgehaald = tmp_groothandel.s_opgehaald + 1

                -- Sync naar alle kanker daapjes
                tmp_groothandel.opslag = json.encode(opslag)
                for k, v in pairs(magazijnen[groothandelID].sources) do
                    TriggerClientEvent("zb-groothandel:client:syncMagazijn", v, tmp_groothandel)
                end

            else
                TriggerClientEvent("QBCore:Notify", src, "Er is iets fout gegaan...", "error")
            end
        end)
    end
end)

-- Speler is klaar met verkoopronde, stort geld op bedrijfs rekening
RegisterNetEvent("zb-groothandel:server:verkoopklaar")
AddEventHandler("zb-groothandel:server:verkoopklaar", function(groothandelID, rondeData)
    local src = source

    if groothandelID ~= nil and rondeData ~= nil and src ~= nil then
        -- Stort geld op die rekening
        QBCore.Functions.ExecuteSql(true, "UPDATE groothandels SET s_verkocht = s_verkocht + 1, s_verdiend = s_verdiend + "..rondeData.bedrag..", bank = bank +"..rondeData.bedrag.." WHERE id = '"..groothandelID.."'")
        QBCore.Functions.ExecuteSql(true, "SELECT * FROM groothandels WHERE id = '"..groothandelID.."'", function(tmp_groothandel)
            if #tmp_groothandel > 0 then
                tmp_groothandel = tmp_groothandel[1]

                for k, v in pairs(magazijnen[groothandelID].sources) do
                    TriggerClientEvent("zb-groothandel:client:syncMagazijn", v, tmp_groothandel)
                end
            end
        end)

    end

    
end)






-- Shit functies
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