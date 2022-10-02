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
        $.post("https://zb-bmshop/sluiten", JSON.stringify({}));
    }
};

function Koop(id) {
    $.post("https://zb-bmshop/kopen", JSON.stringify({
        id: id
    }));
    $("main").fadeOut("fast");
}