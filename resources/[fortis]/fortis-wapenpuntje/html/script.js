window.addEventListener('message', function(event){
    if (event.data.type == "aan") {
        aan();
    } else if (event.data.type == "uit") {
        uit();
    }
});

var puntje = document.getElementById("puntje");

function aan() {
    puntje.style.display = "block";
}

function uit() {
    puntje.style.display = "none";
}