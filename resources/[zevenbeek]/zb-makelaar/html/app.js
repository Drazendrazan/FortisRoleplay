window.addEventListener("message", function(event) {
    if (event.data.type == "open") {
        $("#beheerComputer").fadeIn("fast");
    }
});

document.onkeydown = function(evt) { /* Escape event */
    evt = evt || window.event;
    if (evt.key == "Escape") {
        $("#beheerComputer").fadeOut("fast");
        $.post("https://zb-makelaar/sluiten", JSON.stringify({}));
    }
};

function afsluiten() {
    $("#beheerComputer").fadeOut("fast");
    $.post("https://zb-makelaar/sluiten", JSON.stringify({}));
}

function koopMagazijn() {
    $("#beheerComputer").fadeOut("fast");
    $.post("https://zb-makelaar/sluiten", JSON.stringify({}));
    $.post("https://zb-groothandel/koopGroothandel", JSON.stringify({}));
}