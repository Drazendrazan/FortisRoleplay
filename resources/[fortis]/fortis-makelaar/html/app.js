window.addEventListener("message", function(event) {
    if (event.data.type == "open") {
        $("#beheerComputer").fadeIn("fast");
    }
});

document.onkeydown = function(evt) { /* Escape event */
    evt = evt || window.event;
    if (evt.key == "Escape") {
        $("#beheerComputer").fadeOut("fast");
        $.post("http://fortis-makelaar/sluiten", JSON.stringify({}));
    }
};

function afsluiten() {
    $("#beheerComputer").fadeOut("fast");
    $.post("http://fortis-makelaar/sluiten", JSON.stringify({}));
}

function koopMagazijn() {
    $("#beheerComputer").fadeOut("fast");
    $.post("http://fortis-makelaar/sluiten", JSON.stringify({}));
    $.post("http://fortis-groothandel/koopGroothandel", JSON.stringify({}));
}