window.addEventListener("message", function(event) {
    if (event.data.type == "open") {
        $("#beheerComputer").fadeIn("fast");
        fetch(`https://zb-bitcoin/laptopData`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json; charset=UTF-8',
            },
            body: JSON.stringify({})
        }).then(resp => resp.json()).then(resp => openLaptopje(resp));
    }
});

function openLaptopje(response) {
    $("#serverdata td").remove(); 
    if (response.length != 0) {
        $("#no-result").fadeOut(50);
        $(".servers-buttons").fadeIn(50);
        var totalBitcoins = 0;
        for (let i = 0; i < response.length; i++) {
            let serverdata = [
                {RackID: response[i].rackid, Warmte: response[i].warmth * 8 + "°C" , Processor: response[i].processor * 8 + "°C", GPU: response[i].GPU * 8 + "°C", Bitcoins: response[i].bitcoins, Knop: response[i].rackid},
            ];
            totalBitcoins = totalBitcoins + response[i].bitcoins

            function generateTable(table, data) {
                for (let element of data) {
                    let row = table.insertRow();
                    for (key in element) {
                        if (key == "Knop") {
                            let cell = row.insertCell();
                            let button = document.createElement("button");
                            button.innerHTML = '<i class="fas fa-trash"></i>';
                            button.onclick = function() {
                                serverVerwijderen(response[i].rackid);
                            };
                            cell.appendChild(button);
                        } else {
                            let cell = row.insertCell();
                            let text = document.createTextNode(element[key]);
                            // Kleur erop tyfen
                            switch (key) {
                                case "Warmte":
                                    if (response[i].warmth * 8 >= 80) {
                                        cell.style.color = "#c3130a";
                                    } else if (response[i].warmth * 8 >= 40) {
                                        cell.style.color = "#EB7E5E";
                                    } else {
                                        cell.style.color = "#168D14";
                                    }

                                    if (response[i].warmth * 8 >= 130) {
                                        text = document.createTextNode('✕');
                                    }
                                    break;
                                case "Processor":
                                    if (response[i].processor * 8 >= 80) {
                                        cell.style.color = "#c3130a";
                                    } else if (response[i].processor * 8 >= 40) {
                                        cell.style.color = "#EB7E5E";
                                    } else {
                                        cell.style.color = "#168D14";
                                    }

                                    if (response[i].processor * 8 >= 130) {
                                        text = document.createTextNode('✕');
                                    }
                                    break;
                                case "GPU":
                                    if (response[i].GPU * 8 >= 80) {
                                        cell.style.color = "#c3130a";
                                    } else if (response[i].GPU * 8 >= 40) {
                                        cell.style.color = "#EB7E5E";
                                    } else {
                                        cell.style.color = "#168D14";
                                    }

                                    if (response[i].GPU * 8 >= 130) {
                                        text = document.createTextNode('✕');
                                    }
                                    break;
                                default:
                                    break;
                            }
                            cell.appendChild(text);
                        } 
                    }
                }
            }

            let table = document.querySelector("table");

            generateTable(table, serverdata);
        };
        document.getElementById("total-bitcoins").innerHTML = totalBitcoins + " Bitcoins claimen";
    } else {
        $("#no-result").fadeIn(50);
        $(".servers-buttons").fadeOut(50);
    } 
}

document.onkeydown = function(evt) { /* Escape event */
    evt = evt || window.event;
    if (evt.key == "Escape") {
        $("#beheerComputer").fadeOut("fast");
        $.post("https://zb-bitcoin/sluiten", JSON.stringify({}));
    }
};

function afsluiten() {
    $("#beheerComputer").fadeOut("fast");
    $.post("https://zb-bitcoin/sluiten", JSON.stringify({}));
}

function Beginscherm() {
    $(".servers-lijst").fadeOut(50);
    $(".onderdelen-lijst").fadeOut(50);
    setTimeout(() => {
        $(".beginscherm-wrapper").fadeIn(50);
        $(".nav-items-left").fadeOut(50);
    }, 100);
}

function OpenServers() {
    $(".beginscherm-wrapper").fadeOut(50);
    setTimeout(() => {
        $(".nav-items-left").fadeIn(50);
        $(".servers-lijst").fadeIn(50);
    }, 100);
    
}

function OpenShop() {
    $(".beginscherm-wrapper").fadeOut(50);
    setTimeout(() => {
        $(".nav-items-left").fadeIn(50);
        $(".onderdelen-lijst").fadeIn(50);
    }, 100);
}

// Onderdelen bestellen
function BestelOnderdeelGPU() {
    var x = document.getElementById("amountbutton1").value;
    document.getElementById("koop-button5").disabled = true;
    document.getElementById("koop-button4").disabled = true;
    document.getElementById("koop-button3").disabled = true;
    document.getElementById("koop-button2").disabled = true;
    document.getElementById("koop-button1").disabled = true;

    if (x != 0 && x < 11) {
        $.post("https://zb-bitcoin/bestellingStarten", JSON.stringify({
            type: "gpu",
            amount: x
        }));
        shitGekocht()
        document.getElementById("amountbutton1").value = "";
        setTimeout(() => {
            document.getElementById("koop-button5").disabled = false;
            document.getElementById("koop-button4").disabled = false;
            document.getElementById("koop-button3").disabled = false;
            document.getElementById("koop-button2").disabled = false;
            document.getElementById("koop-button1").disabled = false;
        }, 1000);
    } else { 
        document.getElementById("koop-button5").disabled = false;
        document.getElementById("koop-button4").disabled = false;
        document.getElementById("koop-button3").disabled = false;
        document.getElementById("koop-button2").disabled = false;
        document.getElementById("koop-button1").disabled = false;
        $.post("https://zb-bitcoin/alert", JSON.stringify({}));
    }
}

function BestelOnderdeelGPU2() {
    var x = document.getElementById("amountbutton2").value;
    document.getElementById("koop-button5").disabled = true;
    document.getElementById("koop-button4").disabled = true;
    document.getElementById("koop-button3").disabled = true;
    document.getElementById("koop-button2").disabled = true;
    document.getElementById("koop-button1").disabled = true;
    
    if (x != 0 && x < 11) {
        $.post("https://zb-bitcoin/bestellingStarten", JSON.stringify({
            type: "gpu",
            amount: x
        }));
        shitGekocht()
        document.getElementById("amountbutton2").value = "";
        setTimeout(() => {
            document.getElementById("koop-button5").disabled = false;
            document.getElementById("koop-button4").disabled = false;
            document.getElementById("koop-button3").disabled = false;
            document.getElementById("koop-button2").disabled = false;
            document.getElementById("koop-button1").disabled = false;
        }, 1000);
    } else {
        document.getElementById("koop-button5").disabled = false;
        document.getElementById("koop-button4").disabled = false;
        document.getElementById("koop-button3").disabled = false;
        document.getElementById("koop-button2").disabled = false;
        document.getElementById("koop-button1").disabled = false;
        $.post("https://zb-bitcoin/alert", JSON.stringify({}));    
    }
}

function BestelOnderdeelProcessor() {
    var z = document.getElementById("amountbutton3").value;
    document.getElementById("koop-button5").disabled = true;
    document.getElementById("koop-button4").disabled = true;
    document.getElementById("koop-button3").disabled = true;
    document.getElementById("koop-button2").disabled = true;
    document.getElementById("koop-button1").disabled = true;

    if (z != 0 && z < 11) {
        $.post("https://zb-bitcoin/bestellingStarten", JSON.stringify({
            type: "processor",
            amount: z
        }));
        shitGekocht()
        document.getElementById("amountbutton3").value = "";
        setTimeout(() => {
            document.getElementById("koop-button5").disabled = false;
            document.getElementById("koop-button4").disabled = false;
            document.getElementById("koop-button3").disabled = false;
            document.getElementById("koop-button2").disabled = false;
            document.getElementById("koop-button1").disabled = false;
        }, 1000);
    } else {
        document.getElementById("koop-button5").disabled = false;
        document.getElementById("koop-button4").disabled = false;
        document.getElementById("koop-button3").disabled = false;
        document.getElementById("koop-button2").disabled = false;
        document.getElementById("koop-button1").disabled = false;
        $.post("https://zb-bitcoin/alert", JSON.stringify({}));    
    }

}

function BestelOnderdeelProcessor2() {
    var z = document.getElementById("amountbutton4").value;
    document.getElementById("koop-button5").disabled = true;
    document.getElementById("koop-button4").disabled = true;
    document.getElementById("koop-button3").disabled = true;
    document.getElementById("koop-button2").disabled = true;
    document.getElementById("koop-button1").disabled = true;

    if (z != 0 && z < 11) {
        $.post("https://zb-bitcoin/bestellingStarten", JSON.stringify({
            type: "processor",
            amount: z
        }));
        shitGekocht()
        document.getElementById("amountbutton4").value = "";
        setTimeout(() => {
            document.getElementById("koop-button5").disabled = false;
            document.getElementById("koop-button4").disabled = false;
            document.getElementById("koop-button3").disabled = false;
            document.getElementById("koop-button2").disabled = false;
            document.getElementById("koop-button1").disabled = false;
        }, 1000);
    } else {
        document.getElementById("koop-button5").disabled = false;
        document.getElementById("koop-button4").disabled = false;
        document.getElementById("koop-button3").disabled = false;
        document.getElementById("koop-button2").disabled = false;
        document.getElementById("koop-button1").disabled = false;
        $.post("https://zb-bitcoin/alert", JSON.stringify({}));    
    }

}
 
function BestelOnderdeelKoelpasta() {
    var y = document.getElementById("amountbutton5").value;
    document.getElementById("koop-button5").disabled = true;
    document.getElementById("koop-button4").disabled = true;
    document.getElementById("koop-button3").disabled = true;
    document.getElementById("koop-button2").disabled = true;
    document.getElementById("koop-button1").disabled = true;
    if (y != 0 && y < 11) {
        $.post("https://zb-bitcoin/bestellingStarten", JSON.stringify({
            type: "koelpasta",
            amount: y
        }));
        document.getElementById("amountbutton5").value = "";
        shitGekocht()
        setTimeout(() => {
            document.getElementById("koop-button5").disabled = false;
            document.getElementById("koop-button4").disabled = false;
            document.getElementById("koop-button3").disabled = false;
            document.getElementById("koop-button2").disabled = false;
            document.getElementById("koop-button1").disabled = false;
        }, 1000);
    } else {
        document.getElementById("koop-button5").disabled = false;
        document.getElementById("koop-button4").disabled = false;
        document.getElementById("koop-button3").disabled = false;
        document.getElementById("koop-button2").disabled = false;
        document.getElementById("koop-button1").disabled = false;
        $.post("https://zb-bitcoin/alert", JSON.stringify({}));    
    }
}

function shitGekocht() {
    var audio = document.getElementById("shitgekocht");
    audio.play();
}

function uitbetalen() {
    document.getElementById("total-bitcoins").disabled = true;
    $.post("https://zb-bitcoin/minenUitbetalenCrypto", JSON.stringify({}));
    afsluiten();
    setTimeout(() => {
        document.getElementById("total-bitcoins").disabled = false;
    }, 3000);
} 

function serverVerwijderen(rackid) {
    $.post("https://zb-bitcoin/verwijderKast", JSON.stringify({
        verwijderRackId: rackid,
    }));
    afsluiten();
}