QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

verify_token = function(req, res)
    print("[Fortis-API] API-request ontvangen voor: " .. req.path)
    local token = req.body['token']
    if (token == nil) then
        return fail()
    end
	if token == 'j8SL3xGdFCzn7GdS8zLEViDsekHscRxpHE2fxPzdZDm78' then return handleRequest(req, res) end
    return false
end

fail = function()
    res.send(json.encode({success=false}))
    return false
end

SetHttpHandler(function(req, res)
    req.path = string.sub(req.path, 2)
    res.writeHead(200, { ["Access-Control-Allow-Origin"] = "*"} )
    if req.method == 'POST' then
        return req.setDataHandler(function (body)
            req.body = json.decode(body)
            return verify_token(req, res)
        end)
    end
    return fail()
end)

handleRequest = function(req, res)
    local path = req.path
    if path == "kickZnMoer" then
        return kickZnMoer(req, res)
    end
end

kickZnMoer = function(req, res)
    local steamid = req.body['steamid']
    local reden = req.body['reden']

    local src = QBCore.Functions.GetSource(steamid)
    if src ~= nil then
        local Player = QBCore.Functions.GetPlayer(src)
        TriggerClientEvent('chatMessage', -1, "SERVER", "error", GetPlayerName(src).." is zojuist verbannen voor: "..reden.."")
        DropPlayer(src, "[Fortis Admin Panel]: Je bent verbannen met de reden: "..reden)
        res.send(json.encode({success=succeed}))
    end
end
