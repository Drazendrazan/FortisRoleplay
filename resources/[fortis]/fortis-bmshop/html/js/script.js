window.addEventListener("message", function(event) {
    if (event.data.type == "open") {
        $("main").fadeIn(300);
        document.getElementById("mainDiv").style.display = "flex";
    }
});

// Escape toets
document.onkeydown = function(evt) {
    evt = evt || window.event;
    if (evt.key == "Escape") {
        $("main").fadeOut("fast");
        $.post("http://fortis-bmshop/sluiten", JSON.stringify({}));
    }
};

function Koop(id) {
    $.post("http://fortis-bmshop/kopen", JSON.stringify({
        id: id
    }));
    $("main").fadeOut("fast");
}