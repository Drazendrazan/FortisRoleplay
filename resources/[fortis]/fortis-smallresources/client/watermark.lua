servername = "fortisroleplay.nl"

offset = {x = 0.005, y = 0.001}

rgb = {r = 28, g = 202, b = 155}

alpha = 255

scale = 0.35

font = 4

Citizen.CreateThread(function()
	while true do
		Wait(1)
		SetTextColour(rgb.r, rgb.g, rgb.b, alpha)		

		SetTextFont(font)
		SetTextScale(scale, scale)
		SetTextWrap(0.0, 1.0)
		SetTextCentre(false)
		SetTextDropshadow(2, 2, 0, 0, 0)
		SetTextEdge(1, 0, 0, 0, 205)
		SetTextEntry("STRING")
		AddTextComponentString(servername)
		DrawText(offset.x, offset.y)

		SetTextColour(rgb.r, rgb.g, rgb.b, alpha)

		local year, month, day, hour, minute, second = GetLocalTime()

		

		if hour == 24 then
			hour = 00
		end

		if hour == 25 then
			hour = 01
		end

		if minute < 10 then
			minute = "0"..minute
		end

		SetTextFont(font)
		SetTextScale(0.3, 0.3)
		SetTextWrap(0.0, 1.0)
		SetTextCentre(false)
		SetTextDropshadow(2, 2, 0, 0, 0)
		SetTextEdge(1, 0, 0, 0, 205)
		SetTextEntry("STRING")
		AddTextComponentString(day.."-"..month.."-"..year.." | "..hour..":"..minute)
		DrawText(0.005, 0.02)


	end
end)
