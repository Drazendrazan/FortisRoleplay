window.addEventListener('message', function(event) {
    if (event.data.type == "openOverlijden") {
        var voornaam = event.data.voornaam;
        var achternaam = event.data.achternaam;
        var ledemaat = event.data.ledemaat;
        var reden = event.data.reden;
        OpenDocument(voornaam, achternaam, ledemaat, reden)
    }
}); 
 
function OpenDocument(voornaam, achternaam, ledemaat, reden) {

    var currentdate = new Date(); 
    var datetime = ""+ currentdate.getDate() + "/"
                + (currentdate.getMonth()+1)  + "/" 
                + currentdate.getFullYear() + " "   
                + currentdate.getHours() + ":"  
                + currentdate.getMinutes() + ""  

    document.getElementById("ledemaat").innerHTML = ledemaat;

    document.getElementById("datumentijd").innerHTML = datetime;
 
    document.getElementById("voornaam").innerHTML = voornaam;

    document.getElementById("achternaam").innerHTML = achternaam;

    $("body").fadeIn("slow");
} 
 
function annuleerbutton () {
    $("body").fadeOut("slow");
    $.post("http://hospital/annuleer", JSON.stringify({}));
}

function bevestigbutton () {
    $("body").fadeOut("slow");

    $.post("http://hospital/bevestig", JSON.stringify({}));
} 