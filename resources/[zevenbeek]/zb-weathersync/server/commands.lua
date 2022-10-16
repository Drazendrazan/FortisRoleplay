QBCore.Commands.Add("blackout", "Creeërt een blackout voor de gehele server.", {}, false, function(source, args)
    ToggleBlackout()
end, "admin")

QBCore.Commands.Add("weather", "Verandert het weer naar het aangegven argument.", {}, false, function(source, args)
    for _, v in pairs(AvailableWeatherTypes) do
        if args[1]:upper() == v then
            SetWeather(args[1])
            return
        end
    end
end, "admin")