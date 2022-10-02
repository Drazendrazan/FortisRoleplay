SetupWeerApp = function(data) {
    // Alle icoontjes weg halen
    document.getElementById("icoon-zonnig").style.display = "none";
    document.getElementById("icoon-regen").style.display = "none";
    document.getElementById("icoon-onweer").style.display = "none";
    document.getElementById("icoon-bewolkt").style.display = "none";

    // Bepalen welk icoontje
    if (data["CurrentWeather"] == "EXTRASUNNY") {
        document.getElementById("icoon-zonnig").style.display = "block";
        document.getElementById("weer-type").innerHTML = "Zonnig";
    } else if (data["CurrentWeather"] == "THUNDER") {
        document.getElementById("icoon-onweer").style.display = "block";
        document.getElementById("weer-type").innerHTML = "Onweer bui";
    } else if (data["CurrentWeather"] == "RAIN") {
        document.getElementById("icoon-regen").style.display = "block";
        document.getElementById("weer-type").innerHTML = "Regenbui";
    } else if (data["CurrentWeather"] == "FOGGY" || data["CurrentWeather"] == "OVERCAST") {
        document.getElementById("icoon-bewolkt").style.display = "block";
        document.getElementById("weer-type").innerHTML = "Bewolkt";
    }

    // Toekomstige weer verkklaring bepalen
    if (data["regenVoorspeld"] == true) {
        document.getElementById("weer-voorspelling").innerHTML = "Er komt een regenbui aan";
    } else if (data["onweerVoorspeld"] == true) {
        document.getElementById("weer-voorspelling").innerHTML = "Er lijkt een onweer bui aan te komen";
    } else if (data["bewolkt"] == true) {
        document.getElementById("weer-voorspelling").innerHTML = "Het blijft bewolkt";
    } else {
        document.getElementById("weer-voorspelling").innerHTML = "Het blijft zonnig!";
    }

    var date = new Date();
    var dag = date.getDate();
    var maand = date.getMonth() + 1;
    if (maand < 10) {
        maand = "0" + maand;
    }
    var jaar = date.getFullYear();
    document.getElementById("weer-datum").innerHTML = dag + "-" + maand + "-" + jaar + " " + data["uren"] + ":" + data["minuten"];
}

document.getElementById("refresh-weer").addEventListener("click", function(event) {
    $.post("https://zb-phone/GetWeerData", JSON.stringify({}), function(data) {
        SetupWeerApp(data);
        document.getElementById("refresh-weer").classList.toggle("refreshWeerAnimatie");
    });
});