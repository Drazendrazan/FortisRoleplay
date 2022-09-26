var naam = ""
var prijs = "";
var tier = "";
var verkoperID = "";
var model = ""; 

window.addEventListener('message', function(event) {
    if (event.data.type == "verkoopVoertuig") {
        naam = event.data.naam;
        prijs = event.data.prijs;
        tier = event.data.tier;
        verkoperID = event.data.verkoperID;
        model = event.data.model;
        OpenDocument(naam, prijs, tier, verkoperID)
    }
}); 

function OpenDocument(naam, prijs, tier, verkoperID) {
    var tier = tier;
    var verkoperID = verkoperID;

    document.getElementById("datumentijd").innerHTML = "Direct";
 
    document.getElementById("voornaam").innerHTML = naam;

    document.getElementById("achternaam").innerHTML = prijs;

    $("body").fadeIn("slow");
};

function annuleerbutton () {
    $("body").fadeOut("slow");
    $.post("http://fortis-luxury/annuleer", JSON.stringify({
        tier2: tier,
        verkoperID2: verkoperID,
    }));
}; 

function bevestigbutton () {
    $("body").fadeOut("slow");
    $.post("http://fortis-luxury/bevestigen", JSON.stringify({
        tier2: tier,
        verkoperID2: verkoperID,
        model2: model,
    }));
};