var aantalAchtergronden = 60; // Verander dit als je een achtergrond hebt toegevoegd.
var achtergrondDiv = document.getElementById("achtergrond");

function veranderdAchtergrond() {
    // Verander de achtergrond
    var achtergrondNummer = Math.floor(Math.random() * aantalAchtergronden) + 1;
    achtergrondDiv.style.backgroundImage = "url(./assets/images/achtergronden/"+ achtergrondNummer +".jpg)";

    setTimeout(veranderdAchtergrond, 7000);
}
veranderdAchtergrond();